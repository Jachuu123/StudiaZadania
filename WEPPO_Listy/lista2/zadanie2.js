console.log('=== Dostep do pol obiektu ===');
const person = {
  firstName: 'Anna',
  'favorite color': 'blue',
};

console.log('Dot:', person.firstName);
console.log('Bracket z nazwa z odstepem:', person['favorite color']);

const dynamicKey = 'lastName';
person[dynamicKey] = 'Nowak';
console.log('Bracket z kluczem dynamicznym:', person.lastName);

console.log('Dot wymaga poprawnego identyfikatora, bracket przyjmuje dowolny napis lub wynik konwersji do napisu.\n');

console.log('=== Operator [] z innymi typami na obiekcie ===');
const oddKeys = {};
oddKeys[42] = 'numeric key';
oddKeys[{ toString: () => 'object-key' }] = 'custom toString key';
oddKeys[{ foo: 'bar' }] = 'default toString key';

console.log('Klucze po konwersji:', Object.keys(oddKeys));
console.log('Wartosci:', oddKeys['42'], oddKeys['object-key'], oddKeys['[object Object]']);
console.log('Argument jest konwertowany na napis; liczby staja sie odpowiednikiem stringowym, obiekty uzywaja toString().\n');

console.log('=== Operator [] na tablicy z nie-numerycznymi argumentami ===');
const letters = ['a', 'b', 'c'];

console.log('letters[1]:', letters[1]);
console.log("letters['1'] (string jako indeks):", letters['1']);

letters['two'] = 'dwa';
letters[{ toString: () => 'json-key' }] = 'obiekt';

console.log('Klucze tablicy:', Object.keys(letters));
console.log('Dlugosc tablicy:', letters.length);
console.log('letters.two (wlasciwosc):', letters.two);
console.log('letters["json-key"] (po obiekcie):', letters['json-key']);
console.log('Dodatkowe wlasciwosci nie zmieniaja pola length.\n');

console.log('=== Modyfikacja length w tablicy ===');
letters.length = 2;
console.log('Po skroceniu do length = 2:', letters, 'length =', letters.length);

letters.length = 5;
console.log('Po wydluzeniu do length = 5:', letters, 'length =', letters.length);
console.log('Zwiekszenie length dodaje puste elementy (holes), zmniejszenie ucina elementy.\n');
