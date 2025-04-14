#ifndef COMPLEX_H
#define COMPLEX_H

#include <iostream>
#include <stdexcept>

namespace math {

class complex {
    double r, i; // część rzeczywista i urojona
public:
    // Konstruktor z argumentami domyślnymi
    complex(double a = 0, double b = 0) : r(a), i(b) { }

    // Akcesory (gettery)
    double re() const { return r; }
    double im() const { return i; }

    // Mutatory (settery)
    void re(double r_) { r = r_; }
    void im(double i_) { i = i_; }

    // Sprzężenie liczby zespolonej
    complex conjugated() const { return complex(r, -i); }
};

// Definicje operatorów arytmetycznych (operatory binarne)
complex operator+(const complex &x, const complex &y);
complex operator-(const complex &x, const complex &y);
complex operator*(const complex &x, const complex &y);
complex operator/(const complex &x, const complex &y);

// Operator unarny minus – nowa deklaracja
complex operator-(const complex &x);

// Operatory strumieniowe
std::ostream& operator<<(std::ostream &os, const complex &c);
std::istream& operator>>(std::istream &is, complex &c);

} // namespace math

#endif // COMPLEX_H
