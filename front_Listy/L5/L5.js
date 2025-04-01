/**
 * Typ obiektu reprezentującego produkt na liście zakupów.
 * @typedef {Object} Product
 * @property {number} id - Id produktu
 * @property {string} name - Nazwa produktu
 * @property {number} quantity - Liczba sztuk do zakupienia
 * @property {Date} dueDate - Data, do której produkt powinien być zakupiony
 * @property {boolean} purchased - Status informujący, czy produkt został zakupiony
 * @property {number} [price] - Opcjonalna cena za sztukę (dotyczy tylko zakupionych produktów)
 */

/**
 * Zmienna przechowująca listę produktów.
 * @type {Product[]}
 */
let shoppingList = [];

/**
 * Funkcja generująca unikalne id dla nowego produktu.
 * @returns {number} - Unikalne id
 */
function generateId() {
  return Math.floor(Math.random() * 1000000);
}

/**
 * Funkcja dodająca nowy produkt do listy zakupów.
 * @param {string} name - Nazwa produktu
 * @param {string} dueDateStr - Data, do której produkt powinien być zakupiony (format 'YYYY-MM-DD')
 * @param {number} quantity - Liczba sztuk do zakupienia
 */
function addProduct(name, dueDateStr, quantity) {
  const id = generateId();
  const dueDate = new Date(dueDateStr);
  const product = {
    id,
    name,
    quantity,
    dueDate,
    purchased: false,
  };
  shoppingList.push(product);
}

/**
 * Funkcja usuwająca produkt z listy zakupów na podstawie id.
 * @param {number} id - Id produktu do usunięcia
 */
function removeProduct(id) {
  shoppingList = shoppingList.filter(product => product.id !== id);
}

/**
 * Funkcja edytująca nazwę produktu.
 * @param {number} id - Id produktu do edycji
 * @param {string} newName - Nowa nazwa produktu
 */
function editProductName(id, newName) {
  const product = shoppingList.find(product => product.id === id);
  if (product) {
    product.name = newName;
  }
}

/**
 * Funkcja edytująca status zakupu produktu.
 * @param {number} id - Id produktu do edycji
 * @param {boolean} newStatus - Nowy status zakupu
 */
function editProductStatus(id, newStatus) {
  const product = shoppingList.find(product => product.id === id);
  if (product) {
    product.purchased = newStatus;
  }
}

/**
 * Funkcja edytująca liczbę sztuk produktu.
 * @param {number} id - Id produktu do edycji
 * @param {number} newQuantity - Nowa liczba sztuk
 */
function editProductQuantity(id, newQuantity) {
  const product = shoppingList.find(product => product.id === id);
  if (product) {
    product.quantity = newQuantity;
  }
}

/**
 * Funkcja edytująca datę zakupu produktu.
 * @param {number} id - Id produktu do edycji
 * @param {string} newDueDateStr - Nowa data zakupu w formacie 'YYYY-MM-DD'
 */
function editProductDueDate(id, newDueDateStr) {
  const product = shoppingList.find(product => product.id === id);
  if (product) {
    product.dueDate = new Date(newDueDateStr);
  }
}

/**
 * Funkcja zmieniająca kolejność produktów na liście.
 * @param {number} id - Id produktu do przesunięcia
 * @param {string} direction - Kierunek przesunięcia ('up' lub 'down')
 */
function changeProductOrder(id, direction) {
  const index = shoppingList.findIndex(product => product.id === id);
  if (index !== -1) {
    if (direction === 'up' && index > 0) {
      const temp = shoppingList[index];
      shoppingList[index] = shoppingList[index - 1];
      shoppingList[index - 1] = temp;
    } else if (direction === 'down' && index < shoppingList.length - 1) {
      const temp = shoppingList[index];
      shoppingList[index] = shoppingList[index + 1];
      shoppingList[index + 1] = temp;
    }
  }
}

/**
 * Funkcja zwracająca listę produktów, które powinny być zakupione dziś.
 * @returns {Product[]} - Lista produktów do zakupu dzisiaj
 */
function getProductsToBuyToday() {
  const today = new Date().toDateString();
  return shoppingList.filter(product => product.dueDate.toDateString() === today && !product.purchased);
}

/**
 * Funkcja umożliwiająca wprowadzenie ceny dla zakupionych produktów.
 * @param {number} id - Id produktu
 * @param {number} price - Cena za sztukę
 */
function setProductPrice(id, price) {
  const product = shoppingList.find(product => product.id === id);
  if (product && product.purchased) {
    product.price = price;
  }
}

/**
 * Funkcja obliczająca koszt zakupów danego dnia.
 * @param {string} dateStr - Data w formacie 'YYYY-MM-DD' dla której obliczany jest koszt
 * @returns {number} - Łączny koszt zakupów
 */
function calculateDailyCost(dateStr) {
  const date = new Date(dateStr);
  const productsForTheDay = shoppingList.filter(product => {
    return product.dueDate.toDateString() === date.toDateString() && product.purchased;
  });
  let totalCost = 0;
  productsForTheDay.forEach(product => {
    if (product.price) {
      totalCost += product.price * product.quantity;
    }
  });
  return totalCost;
}

/**
 * Funkcja masowo modyfikująca produkty na liście na podstawie ich id.
 * @param {number[]} ids - Lista id produktów do modyfikacji
 * @param {function} modifyFunction - Funkcja modyfikująca pojedynczy produkt
 */
function bulkModifyProducts(ids, modifyFunction) {
  shoppingList.forEach(product => {
    if (ids.includes(product.id)) {
      modifyFunction(product);
    }
  });
}

//jsdoc -d=docs L5.js

// Wywołania funkcji dla przetestowania działania
addProduct('Chleb', '2025-04-01', 2);
addProduct('Mleko', '2025-04-01', 1);
addProduct('Jabłka', '2025-04-02', 5);

console.log(shoppingList);
editProductName(shoppingList[0].id, 'Chleb pszenny');
changeProductOrder(shoppingList[0].id, 'down');
setProductPrice(shoppingList[1].id, 3.5);
console.log(getProductsToBuyToday());
console.log(calculateDailyCost('2025-04-01'));
