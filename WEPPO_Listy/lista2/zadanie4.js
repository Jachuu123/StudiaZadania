class User {
  constructor(name) {
    this.name = name;
  }
}

const user = new User('Marta');
const items = ['desk', 'lamp'];
const plain = 'text';

console.log('typeof user ->', typeof user); // object
console.log('user instanceof User ->', user instanceof User); // true
console.log('user instanceof Array ->', user instanceof Array); // false

console.log('typeof items ->', typeof items); // object
console.log('items instanceof Array ->', items instanceof Array); // true
console.log('items instanceof Object ->', items instanceof Object); // true, bo Array dziedziczy po Object

console.log('typeof plain ->', typeof plain); // string
console.log('plain instanceof String ->', plain instanceof String); // false (bo plain to prymityw)
console.log('new String(plain) instanceof String ->', new String(plain) instanceof String); // true (obiekt owijka)

console.log('\\ntypeof opisuje kategorie prymitywow oraz zwraca \"object\" lub \"function\" dla innych wartosci.');
console.log('instanceof sprawdza lancuch prototypow pomiedzy obiektem a konstruktorem.');
