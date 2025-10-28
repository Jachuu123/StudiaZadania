const account = {
  owner: 'Ala',
  balance: 0,
  deposit(amount) {
    this.balance += amount;
    return this.balance;
  },
  get summary() {
    return `${this.owner}: ${this.balance} PLN`;
  },
  set summary(text) {
    const [ownerPart, balancePart] = text.split(':');
    if (ownerPart) {
      this.owner = ownerPart.trim();
    }
    if (balancePart) {
      this.balance = Number(balancePart.trim());
    }
  },
};

console.log('Poczatkowy stan:', account.summary);
account.deposit(150);
console.log('Po wplacie 150:', account.summary);
account.summary = 'Ola: 200';
console.log('Setter summary aktualizuje pola:', account.summary);

account.currency = 'PLN';
account.withdraw = function withdraw(amount) {
  this.balance -= amount;
  return this.balance;
};
Object.defineProperty(account, 'status', {
  enumerable: true,
  get() {
    return this.balance >= 0 ? 'plus' : 'minus';
  },
  set(value) {
    throw new Error(`Status jest wyliczany; nie mozna ustawic go na ${value}`);
  },
});

account.withdraw(250);
console.log('Po dodaniu nowych skladnikow:', {
  balance: account.balance,
  currency: account.currency,
  status: account.status,
});

Object.defineProperty(account, 'limit', {
  value: 1000,
  writable: false,
  enumerable: true,
});
Object.defineProperty(account, 'log', {
  value: [],
  writable: true,
});
account.log.push({ type: 'withdraw', amount: 250 });

console.log('Przyklad dodania pola i metody przez Object.defineProperty:', {
  limit: account.limit,
  log: account.log,
});

console.log('\nUwagi:');
console.log('- Pole i metoda moga byc tworzone zwyklym przypisaniem lub przez Object.defineProperty (obie formy dzialaja).');
console.log('- Wlasciwosc z getterem/setterem musi byc dodana przez Object.defineProperty (lub w definicji obiektu); samo przypisanie nie utworzy akcesorow.');
