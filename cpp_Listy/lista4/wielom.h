#ifndef WIELOM_H
#define WIELOM_H

#include <iostream>
#include <initializer_list>
#include <stdexcept>
#include <algorithm>

class wielom {
private:
    int n;         // stopień wielomianu
    double* a;     // współczynniki: a[i]

    // Funkcja pomocnicza do alokacji tablicy współczynników o zadanym stopniu
    void allocate(int degree);

public:
    // Konstruktor jednomianu (domyślnie tworzy wielomian stały 1, czyli 1*x^0)
    wielom(int st = 0, double wsp = 1.0);

    // Konstruktor z tablicą współczynników
    wielom(int st, const double wsp[]);

    // Konstruktor z listą inicjalizującą
    wielom(std::initializer_list<double> wsp);

    // Konstruktor kopiujący
    wielom(const wielom &w);

    // Konstruktor przenoszący
    wielom(wielom &&w);

    // Operator przypisania kopiujący
    wielom& operator=(const wielom &w);

    // Operator przypisania przenoszący
    wielom& operator=(wielom &&w);

    // Destruktor
    ~wielom();

    // Operator indeksowania do odczytu (dla współczynnika przy x^i)
    double operator[](int i) const;

    // Operator indeksowania do zapisu (dla współczynnika przy x^i)
    double& operator[](int i);

    // Metoda zwracająca stopień wielomianu
    int stopien() const { return n; }

    // Operator wywołania funkcji – oblicza wartość wielomianu w punkcie x (schemat Hornera)
    double operator()(double x) const;

    // Składowe operatory przypisania arytmetycznego
    wielom& operator+=(const wielom &v);
    wielom& operator-=(const wielom &v);
    wielom& operator*=(const wielom &v);
    wielom& operator*=(double c);

    // Operatory strumieniowe – przyjaźń pozwala na bezpośredni dostęp do prywatnych składowych (co kolwiek to nie znaczy)
    friend std::istream& operator>>(std::istream &we, wielom &w);
    friend std::ostream& operator<<(std::ostream &wy, const wielom &w);

    // Funkcje zaprzyjaźnione – operatory arytmetyczne
    friend wielom operator+(const wielom &u, const wielom &v);
    friend wielom operator-(const wielom &u, const wielom &v);
    friend wielom operator*(const wielom &u, const wielom &v);
    friend wielom operator*(const wielom &w, double c);
    friend wielom operator*(double c, const wielom &w);
};

#endif // WIELOM_H
