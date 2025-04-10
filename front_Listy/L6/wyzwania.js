// ===============================
// Wyzwanie 1
// ===============================
// Aby zachować kolejność linii (czyli wywołanie funkcji przed jej definicją)
// zmieniamy funkcję strzałkową na deklarację funkcji,
// ponieważ deklaracje funkcji są hoistowane.

console.log(capitalize("alice"));

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

// ===============================
// Wyzwanie 2
// ===============================
// Funkcja capitalizeSentence dzieli podany ciąg na wyrazy, dla każdego wyrazu
// wywołuje funkcję capitalize, a następnie scala wynik z powrotem w zdanie.
function capitalizeSentence(sentence) {
  return sentence
    .split(" ")
    .map(word => capitalize(word))
    .join(" ");
}

console.log(capitalizeSentence("alice"));
console.log(capitalizeSentence("alice in wonderland"));

// ===============================
// Wyzwanie 3
// ===============================
// Aby usprawnić działanie funkcji generateId, zamiast tablicy wykorzystamy obiekt Set,
// który ma o wiele lepszą wydajność przy sprawdzaniu przynależności elementu.
const ids = new Set();

function generateId() {
  let id = 0;
  do {
    id++;
  } while (ids.has(id));
  
  ids.add(id);
  return id;
}

// Test wydajności funkcji generateId:
console.time("generateId");
for (let i = 0; i < 3000; i++) {
  generateId();
}
console.timeEnd("generateId");

// ===============================
// Wyzwanie 4
// ===============================
// Funkcja compareObjects porównuje dwa obiekty rekurencyjnie.
// Zakładamy, że obiekty zawierają jedynie typy: number, string oraz zagnieżdżone obiekty o tej samej strukturze.
function compareObjects(obj1, obj2) {
  // Jeśli któryś z obiektów nie jest obiektem lub jest null, porównujemy je bezpośrednio
  if (
    typeof obj1 !== "object" ||
    obj1 === null ||
    typeof obj2 !== "object" ||
    obj2 === null
  ) {
    return obj1 === obj2;
  }

  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  // Jeśli liczba kluczy się różni, obiekty nie są równe
  if (keys1.length !== keys2.length) return false;

  // Dla każdego klucza sprawdzamy, czy istnieje w drugim obiekcie i czy wartości są równe
  for (let key of keys1) {
    if (!obj2.hasOwnProperty(key)) return false;
    if (!compareObjects(obj1[key], obj2[key])) return false;
  }
  return true;
}

// Testy funkcji compareObjects:
const obj1 = {
  name: "Alice",
  age: 25,
  address: {
    city: "Wonderland",
    country: "Fantasy",
  },
};

const obj2 = {
  name: "Alice",
  age: 25,
  address: {
    city: "Wonderland",
    country: "Fantasy",
  },
};

const obj3 = {
  age: 25,
  address: {
    city: "Wonderland",
    country: "Fantasy",
  },
  name: "Alice",
};

const obj4 = {
  name: "Alice",
  age: 25,
  address: {
    city: "Not Wonderland",
    country: "Fantasy",
  },
};

const obj5 = {
  name: "Alice",
};

console.log("Should be True:", compareObjects(obj1, obj2));
console.log("Should be True:", compareObjects(obj1, obj3));
console.log("Should be False:", compareObjects(obj1, obj4));
console.log("Should be True:", compareObjects(obj2, obj3));
console.log("Should be False:", compareObjects(obj2, obj4));
console.log("Should be False:", compareObjects(obj3, obj4));
console.log("Should be False:", compareObjects(obj1, obj5));
console.log("Should be False:", compareObjects(obj5, obj1));

// ===============================
// Wyzwanie 5
// ===============================
// Funkcja addBookToLibrary z walidacją przekazywanych argumentów.
// Warunki walidacji:
// - title oraz author muszą być niepustymi napisami
// - pages musi być dodatnią liczbą
// - isAvailable musi być typu boolean
// - ratings musi być tablicą liczb z zakresu 0-5 (tablica może być pusta)
let library = [];

function addBookToLibrary(title, author, pages, isAvailable, ratings) {
  if (typeof title !== "string" || title.trim() === "") {
    throw new Error("Invalid title");
  }
  if (typeof author !== "string" || author.trim() === "") {
    throw new Error("Invalid author");
  }
  if (typeof pages !== "number" || pages <= 0) {
    throw new Error("Invalid pages");
  }
  if (typeof isAvailable !== "boolean") {
    throw new Error("Invalid isAvailable - must be a boolean");
  }
  if (!Array.isArray(ratings)) {
    throw new Error("Invalid ratings - should be an array");
  }
  for (const rating of ratings) {
    if (typeof rating !== "number" || rating < 0 || rating > 5) {
      throw new Error(
        "Invalid rating value: ratings should be numbers between 0 and 5"
      );
    }
  }
  library.push({
    title,
    author,
    pages,
    available: isAvailable,
    ratings,
  });
}

// ===============================
// Wyzwanie 6
// ===============================
// Funkcja testAddingBooks przyjmuje tablicę testów, gdzie każdy test to obiekt
// zawierający:
/// - testCase: tablica argumentów dla addBookToLibrary
/// - shouldFail: wartość boolowska określająca, czy błąd był oczekiwany.
// Funkcja wypisuje stosowne komunikaty w zależności od wyniku testu.
function testAddingBooks(testCases) {
  for (const test of testCases) {
    const { testCase, shouldFail } = test;
    try {
      addBookToLibrary(...testCase);
      if (shouldFail) {
        console.log(
          "Test failed:",
          testCase,
          "- Expected failure but function succeeded."
        );
      } else {
        console.log("Test passed:", testCase);
      }
    } catch (err) {
      if (shouldFail) {
        console.log("Test passed:", testCase, "- Error:", err.message);
      } else {
        console.log("Test failed:", testCase, "- Unexpected error:", err.message);
      }
    }
  }
}

// Testy funkcji testAddingBooks:
const testCases = [
  { testCase: ["", "Author", 200, true, []], shouldFail: true },
  { testCase: ["Title", "", 200, true, []], shouldFail: true },
  { testCase: ["Title", "Author", -1, true, []], shouldFail: true },
  { testCase: ["Title", "Author", 200, "yes", []], shouldFail: true },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, 6]], shouldFail: true },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, "yes"]], shouldFail: true },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, {}]], shouldFail: true },
  { testCase: ["Title", "Author", 200, true, []], shouldFail: false },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3]], shouldFail: false },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, 4]], shouldFail: false },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, 4, 5]], shouldFail: false },
  { testCase: ["Title", "Author", 200, true, [1, 2, 3, 4, 5]], shouldFail: false },
];

testAddingBooks(testCases);

// ===============================
// Wyzwanie 7
// ===============================
// Funkcja addBooksToLibrary przyjmuje tablicę tablic argumentów, a następnie
// dla każdego zestawu argumentów wywołuje addBookToLibrary, dodając książki do biblioteki.
function addBooksToLibrary(books) {
  for (const bookArgs of books) {
    addBookToLibrary(...bookArgs);
  }
}

const books = [
  ["Alice in Wonderland", "Lewis Carroll", 200, true, [1, 2, 3]],
  ["1984", "George Orwell", 300, true, [4, 5]],
  ["The Great Gatsby", "F. Scott Fitzgerald", 150, true, [3, 4]],
  ["To Kill a Mockingbird", "Harper Lee", 250, true, [2, 3]],
  ["The Catcher in the Rye", "J.D. Salinger", 200, true, [1, 2]],
  ["The Hobbit", "J.R.R. Tolkien", 300, true, [4, 5]],
  ["Fahrenheit 451", "Ray Bradbury", 200, true, [3, 4]],
  ["Brave New World", "Aldous Huxley", 250, true, [2, 3]],
  ["The Alchemist", "Paulo Coelho", 200, true, [1, 2]],
  ["The Picture of Dorian Gray", "Oscar Wilde", 300, true, [4, 5]],
];

addBooksToLibrary(books);
console.log(library);
