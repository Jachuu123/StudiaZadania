// zadania.js
// ===== Pomocnicze =====
function digitsOf(n) {
  return String(n).split("").map(d => Number(d));
}
function sumDigits(n) {
  return digitsOf(n).reduce((a, b) => a + b, 0);
}

// ===== 2) Liczby 1..100000 podzielne przez każdą ze swoich cyfr ORAZ przez sumę cyfr =====
// Uwaga: jeśli liczba zawiera cyfrę 0 -> odpada (dzielenie przez 0 jest niedozwolone)
function isDivisibleByAllDigitsAndSum(n) {
  const ds = digitsOf(n);
  if (ds.includes(0)) return false;
  if (!ds.every(d => n % d === 0)) return false;
  return n % ds.reduce((a, b) => a + b, 0) === 0;
}
function task2() {
  console.time("task2");
  const res = [];
  for (let n = 1; n <= 100000; n++) {
    if (isDivisibleByAllDigitsAndSum(n)) res.push(n);
  }
  console.timeEnd("task2");
  console.log("Wynik (liczby spełniające warunek):", res);
  return res;
}

// ===== 3) Liczby pierwsze w [2, 100000] – prosta metoda (dzielenie próbne) =====
// Wersja bardzo prosta (do sqrt(n)), bez sit: czytelna i wystarczająca.
function isPrimeSimple(n) {
  if (n < 2) return false;
  if (n === 2) return true;
  if (n % 2 === 0) return false;
  const limit = Math.floor(Math.sqrt(n));
  for (let d = 3; d <= limit; d += 2) {
    if (n % d === 0) return false;
  }
  return true;
}
function task3() {
  console.time("task3");
  const primes = [];
  for (let n = 2; n <= 100000; n++) {
    if (isPrimeSimple(n)) primes.push(n);
  }
  console.timeEnd("task3");
  console.log("Liczba znalezionych pierwszych:", primes.length);
  // Jeśli chcesz, odkomentuj, ale to bardzo długi log:
  // console.log(primes);
  return primes;
}

// ===== 5) Fibonacci: iteracyjnie vs rekurencyjnie + pomiary czasu =====
function fibIter(n) {
  if (n <= 1) return n;
  let a = 0, b = 1;
  for (let i = 2; i <= n; i++) {
    const c = a + b;
    a = b;
    b = c;
  }
  return b;
}
// Naiwna rekurencja (bez memoizacji) – celowo nieoptymalna:
function fibRec(n) {
  if (n <= 1) return n;
  return fibRec(n - 1) + fibRec(n - 2);
}

// Pomiar konsolowy dla n=10..N. Dla rekurencji zatrzymujemy się,
// gdy czas zaczyna być “nierealny” do sensownego porównania.
function measureFibTimes({ startN = 10, maxNHard = 60, thresholdMs = 2000 } = {}) {
  const rows = [];
  let maxNRecursive = startN;
  for (let n = startN; n <= maxNHard; n++) {
    // iter
    const labelIter = `fibIter(${n})`;
    console.time(labelIter);
    const vi = fibIter(n);
    console.timeEnd(labelIter);

    // rec – mierz i ewentualnie przerwij gdy zbyt długo
    const labelRec = `fibRec(${n})`;
    let vr = null;
    let recOk = true;
    const t0 = (typeof performance !== "undefined" && performance.now) ? performance.now() : Date.now();
    try {
      console.time(labelRec);
      vr = fibRec(n);
      console.timeEnd(labelRec);
    } catch (e) {
      console.timeEnd(labelRec);
      recOk = false;
    }
    const t1 = (typeof performance !== "undefined" && performance.now) ? performance.now() : Date.now();
    const recMs = t1 - t0;

    rows.push({
      n,
      fibIter: vi,
      fibRec: recOk ? vr : "—",
      recMs: recOk ? recMs.toFixed(2) : "—"
    });

    if (!recOk || recMs > thresholdMs) {
      maxNRecursive = n;
      console.log(
        `Przerywam rekurencję przy n=${n} (czas ~${recMs.toFixed(0)} ms > ${thresholdMs} ms).`
      );
      break;
    } else {
      maxNRecursive = n;
    }
  }
  console.log("Tabela wyników (pierwsze kolumny to wartości, recMs = czas rekurencji w ms):");
  if (console.table) console.table(rows);
  else console.log(rows);

  console.log(
    `Dla rekurencji sensowne n mieści się ~do ${maxNRecursive} przy progu ${thresholdMs} ms (zależne od silnika JS).`
  );

  return rows;
}

// ===== Uruchom wszystkie zadania po kolei =====
(function main() {
  console.log("=== Zadanie 2 ===");
  task2();

  console.log("\n=== Zadanie 3 ===");
  task3();

  console.log("\n=== Zadanie 5 ===");
  // Zakres od 10 w górę, twardy limit 60, próg 2s na pojedyncze n:
  measureFibTimes({ startN: 10, maxNHard: 60, thresholdMs: 2000 });
})();
