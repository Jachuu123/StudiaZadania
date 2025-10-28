const base = ![] + [];
console.log('![] daje', ![], 'a ![] + [] krazy w string:', base);

const part1 = base[+[]];
console.log('Czesc 1 (![]+[])[+[]] ->', part1, '(+[] to 0, znak podrzuca litere o indeksie 0)');

const part2 = base[+!+[]];
console.log('Czesc 2 (![]+[])[+!+[]] ->', part2, '(!+[] to true, +true to 1)');

const comboBase = [![]] + [][[]];
console.log('[![]] to', [![]], '; [][[]] to', [][[]], '; razem:', comboBase);

const comboIndex = +!+[] + [+[ ]];
console.log('Wyrazenie indeksu trzeciej sekcji:', comboIndex, '(typ:', typeof comboIndex, ')');

const part3 = comboBase[comboIndex];
console.log('Czesc 3 ([![]]+[][[]])[+!+[]+[+[ ]]] ->', part3, '(wejscie na pozycje', Number(comboIndex), ')');

const part4 = base[!+[] + !+[]];
console.log('Czesc 4 (![]+[])[!+[]+!+[]] ->', part4, '(!+[] konwertuje na 1; 1+1 daje indeks 2)');

const result = part1 + part2 + part3 + part4;
console.log('Ostatecznie wynik to:', result);

console.log( (![]+[])[+[]]    +    (![]+[])[+!+[]]    +    ([![]]+[][[]])[+!+[]+[+[]]]    +    (![]+[])[!+[]+!+[]] );

/*
Kolejne przeksztalcenia operatorow:
- ![]            => false (tablica jest truthy, negacja daje false)
- ![] + []       => "false" (false konwertuje sie do napisu i laczy z "" z pustej tablicy)
- [![]] + [][[]] => "falseundefined"; [![]] to ["false"], [][[]] to undefined, oba sa konwertowane do stringow
- +[]            => 0 (unarny plus zmienia [] na liczbe)
- +!+[]          => 1 (wewnetrzne +[] daje 0, !0 -> true, +true -> 1)
- [+[ ]]         => "0" (+[ [ ] ] = 0, a potem tablica z jednym elementem 0 konwertuje sie do "0")
- !+[] + !+[]    => 1 + 1 = 2 (kazde !+[] daje 1)
- ([![]] + [][[]])[10] wybiera litere "i" z "falseundefined" (indeks "10" zostaje potraktowany jako liczba)
Konkatenacja czesci f + a + i + l daje napis "fail".
*/