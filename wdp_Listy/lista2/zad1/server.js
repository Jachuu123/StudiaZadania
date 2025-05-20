import express from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import sqlite3 from "sqlite3";
import argon2 from "argon2";
import { body, validationResult } from "express-validator";
import crypto from "crypto";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app  = express();
const db   = new sqlite3.Database("./bank.db");

const argon2Options = {
  type: argon2.argon2id,   // lub argon2i jeżeli zależy Ci na stricte i-only
  memoryCost : 2 ** 17,    // 128 MiB
  timeCost   : 4,          // 4 iteracje
  parallelism: 2           // wątków (= rdzeni CPU)
};

// ── baza ───────────────────────────────────────────────────────────────────
db.serialize(() => {
  db.run("PRAGMA foreign_keys = ON");
  db.run(`CREATE TABLE IF NOT EXISTS users(
            id       INTEGER PRIMARY KEY,
            login    TEXT UNIQUE    NOT NULL,
            email    TEXT UNIQUE    NOT NULL,
            password TEXT           NOT NULL
          )`);
  db.run(`CREATE TABLE IF NOT EXISTS resets(
            token   TEXT PRIMARY KEY,
            login   TEXT  NOT NULL,
            expires INTEGER NOT NULL,
            FOREIGN KEY(login) REFERENCES users(login) ON DELETE CASCADE
          )`);
});

// ── middleware ────────────────────────────────────────────────────────────
app.use(helmet());
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));      // front-end
app.use("/api/",
  rateLimit({ windowMs: 15 * 60_000, max: 100 })              // 100 żądań / 15 min
);

// ── helpery ───────────────────────────────────────────────────────────────
const vSignup = [
  body("login").isAlphanumeric().isLength({ min: 3, max: 20 }),
  body("email").isEmail().normalizeEmail(),
  body("password").isStrongPassword({ minLength: 8, minSymbols: 0 })
];
const vLogin   = [ body("login").notEmpty(), body("password").notEmpty() ];
const vReset   = [ body("email").isEmail().normalizeEmail() ];
const vNewPass = [
  body("token").isHexadecimal().isLength({ min: 32, max: 32 }),
  body("password").isStrongPassword({ minLength: 8, minSymbols: 0 })
];
const validate = (req, res, next) =>
  validationResult(req).isEmpty() ? next()
  : res.status(400).send("Niepoprawne dane");

// ── endpointy ─────────────────────────────────────────────────────────────
app.post("/api/signup", vSignup, validate, async (req, res) => {
  const { login, email, password } = req.body;
  db.get("SELECT 1 FROM users WHERE login=? OR email=?", [login, email], async (_e, row) => {
    if (row) return res.status(409).send("Login lub email zajęty");
    const hash = await argon2.hash(password, argon2Options);
    db.run("INSERT INTO users(login,email,password) VALUES(?,?,?)",
       [login, email, hash]);
    res.status(201).send("Konto utworzone");
  });
});

app.post("/api/login", vLogin, validate, (req, res) => {
  const { login, password } = req.body;
  db.get(
    "SELECT password FROM users WHERE login = ?",
    [login],
    async (_e, row) => {
      // jeśli brak wiersza lub weryfikacja Argon2 nie przejdzie
      if (!row || !(await argon2.verify(row.password, password))) {
        return res.status(401).send("Błędny login lub hasło");
      }

      // w przeciwnym razie
      res.send("Zalogowano");
    }
  );
});

// reset hasła: generowanie tokenu
app.post("/api/reset", vReset, validate, (req, res) => {
  const { email } = req.body;

  db.get("SELECT login FROM users WHERE email = ?", [email], (_e, row) => {
    // nie zdradzamy, czy mail istnieje
    if (!row) return res.send("Jeśli email istnieje, link został wysłany");

    const token   = crypto.randomBytes(16).toString("hex");
    const expires = Date.now() + 15 * 60_000;                // 15 min

    db.run(
      "INSERT INTO resets(token, login, expires) VALUES (?, ?, ?)",
      [token, row.login, expires]
    );

    console.log("[DEV] Link resetu:", `http://localhost:3000/?token=${token}`);
    res.send("Sprawdź maila – jeśli adres jest poprawny, dostaniesz link");
  });
});

// ustawienie nowego hasła
app.post("/api/newpass", vNewPass, validate, async (req, res) => {
  const { token, password } = req.body;

  db.get(
    "SELECT login, expires FROM resets WHERE token = ?",
    [token],
    async (_e, row) => {
      if (!row || row.expires < Date.now()) {
        return res.status(410).send("Token wygasł");
      }

      const hash = await bcrypt.hash(password, 12);
      db.run("UPDATE users SET password = ? WHERE login = ?", [hash, row.login]);
      db.run("DELETE FROM resets WHERE token = ?", [token]);

      res.send("Hasło zmienione");
    }
  );
});

// ── start ─────────────────────────────────────────────────────────────────
const PORT = process.env.PORT || 3000;   // możesz zmienić port zmienną środowiskową

app.listen(PORT, () => {
  console.log(`▶︎ http://localhost:${PORT} – serwer działa`);
});
