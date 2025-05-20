// public/app.js
// ------------------------------------------------------------------
//  Prototyp Banku – logika front-endu (zgodna z CSP: script-src 'self')
// ------------------------------------------------------------------

// ---------- Konfiguracja ----------
const API     = '/api';
const SCREENS = ['signup', 'login', 'reset', 'newpass'];

// ---------- Elementy DOM ----------
const signupForm = document.getElementById('signupForm');
const suLogin    = document.getElementById('suLogin');
const suEmail    = document.getElementById('suEmail');
const suPass     = document.getElementById('suPass');
const suPass2    = document.getElementById('suPass2');
const signupMsg  = document.getElementById('signupMsg');

const loginForm = document.getElementById('loginForm');
const liLogin   = document.getElementById('liLogin');
const liPass    = document.getElementById('liPass');
const loginMsg  = document.getElementById('loginMsg');

const resetForm = document.getElementById('resetForm');
const reEmail   = document.getElementById('reEmail');
const resetMsg  = document.getElementById('resetMsg');

const newpassForm = document.getElementById('newpassForm');
const npPass      = document.getElementById('npPass');
const npPass2     = document.getElementById('npPass2');
const newpassMsg  = document.getElementById('newpassMsg');

// ---------- Pomocnicze funkcje ----------
/** Pokaż jedną sekcję, ukryj pozostałe */
function show(id) {
  SCREENS.forEach(s => {
    document.getElementById(s).hidden = (s !== id);
  });
}

/** Ustaw komunikat (zielony/czerwony) */
function setMsg(el, text, ok = true) {
  el.textContent      = text;
  el.style.color      = ok ? 'green' : '#c00';
}

// ---------- Nawigacja bez inline onclick ----------
document.getElementById('btnSignup').addEventListener('click', () => show('signup'));
document.getElementById('btnLogin') .addEventListener('click', () => show('login'));
document.getElementById('btnReset') .addEventListener('click', () => show('reset'));

// ---------- SIGNUP ----------
signupForm.addEventListener('submit', async e => {
  e.preventDefault();
  if (suPass.value !== suPass2.value) {
    setMsg(signupMsg, 'Hasła różne', false);
    return;
  }
  try {
    const r = await fetch(API + '/signup', {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ login: suLogin.value.trim(), email: suEmail.value.trim(), password: suPass.value })
    });
    const text = await r.text();
    setMsg(signupMsg, text, r.ok);
    if (r.ok) {
      signupForm.reset();
      show('login');
    }
  } catch {
    setMsg(signupMsg, 'Błąd sieci', false);
  }
});

// ---------- LOGIN ----------
loginForm.addEventListener('submit', async e => {
  e.preventDefault();
  try {
    const r = await fetch(API + '/login', {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ login: liLogin.value.trim(), password: liPass.value })
    });
    const text = await r.text();
    setMsg(loginMsg, text, r.ok);
    if (r.ok) loginForm.reset();
  } catch {
    setMsg(loginMsg, 'Błąd sieci', false);
  }
});

// ---------- RESET LINK ----------
resetForm.addEventListener('submit', async e => {
  e.preventDefault();
  try {
    const r = await fetch(API + '/reset', {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ email: reEmail.value.trim() })
    });
    const text = await r.text();
    setMsg(resetMsg, text, r.ok);
    if (r.ok) resetForm.reset();
  } catch {
    setMsg(resetMsg, 'Błąd sieci', false);
  }
});

// ---------- NEW PASSWORD ----------
newpassForm.addEventListener('submit', async e => {
  e.preventDefault();
  if (npPass.value !== npPass2.value) {
    setMsg(newpassMsg, 'Hasła różne', false);
    return;
  }
  const token = new URLSearchParams(location.search).get('token');
  if (!token) {
    setMsg(newpassMsg, 'Brak tokenu resetu', false);
    return;
  }
  try {
    const r = await fetch(API + '/newpass', {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ token, password: npPass.value })
    });
    const text = await r.text();
    setMsg(newpassMsg, text, r.ok);
    if (r.ok) {
      newpassForm.reset();
      history.replaceState({}, '', location.pathname);
      show('login');
    }
  } catch {
    setMsg(newpassMsg, 'Błąd sieci', false);
  }
});

// ---------- Ekran startowy ----------
(() => {
  const token = new URLSearchParams(location.search).get('token');
  token ? show('newpass') : show('signup');
})();
