#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include "complex.h"
#include <iostream>
#include <initializer_list>
#include <stdexcept>
#include <algorithm>

namespace calc {

using math::complex;

class polynomial {
    int n;       // stopień wielomianu
    complex *a;  // wskaźnik na tablicę współczynników (a[i] dla i=0…n)
public:
    // Konstruktor bezargumentowy
    polynomial();
    // Konstruktor z listą inicjalizującą (np. {a0, a1, ..., a_n})
    polynomial(std::initializer_list<complex> list);
    // Konstruktor kopiujący
    polynomial(const polynomial &p);
    // Konstruktor przenoszący
    polynomial(polynomial &&p) noexcept;
    
    // Operator przypisania kopiujący
    polynomial& operator=(const polynomial &p);
    // Operator przypisania przenoszący
    polynomial& operator=(polynomial &&p) noexcept;
    
    // Destruktor
    ~polynomial();
    
    // Operator indeksowania – dostęp do współczynnika dla modyfikacji i odczytu
    complex& operator[](int i);
    const complex& operator[](int i) const;
    
    // Dostęp do stopnia wielomianu
    int degree() const;
    
    // Operator wywołania – oblicza wartość wielomianu dla danego x (metoda Hornera)
    complex operator()(const complex &x) const;
    
    // Deklaracje funkcji zaprzyjaźnionych (operatory arytmetyczne i strumieniowe)
    friend polynomial operator+(const polynomial &p1, const polynomial &p2);
    friend polynomial operator-(const polynomial &p1, const polynomial &p2);
    friend polynomial operator*(const polynomial &p, const complex &c);
    friend polynomial operator*(const polynomial &p1, const polynomial &p2);
    friend std::ostream& operator<<(std::ostream &os, const polynomial &p);
    friend std::istream& operator>>(std::istream &is, polynomial &p);
};

// Deklaracje funkcji zaprzyjaźnionych (umożliwiających korzystanie z operacji spoza klasy)
polynomial operator+(const polynomial &p1, const polynomial &p2);
polynomial operator-(const polynomial &p1, const polynomial &p2);
polynomial operator*(const polynomial &p, const complex &c);
polynomial operator*(const polynomial &p1, const polynomial &p2);
std::ostream& operator<<(std::ostream &os, const polynomial &p);
std::istream& operator>>(std::istream &is, polynomial &p);

} // namespace calc

#endif // POLYNOMIAL_H
