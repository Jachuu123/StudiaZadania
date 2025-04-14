#include "polynomial.h"
#include "complex.h"
#include <iostream>
#include <stdexcept>
#include <algorithm>
#include <cmath>

namespace calc {

// Konstruktor bezargumentowy – tworzy wielomian stopnia 0 o współczynniku 0
polynomial::polynomial() : n(0), a(new complex[1]{complex(0,0)}) {}

// Konstruktor z listą inicjalizującą
polynomial::polynomial(std::initializer_list<complex> list)
    : n(static_cast<int>(list.size()) - 1), a(new complex[list.size()]) {
    int i = 0;
    for (auto it = list.begin(); it != list.end(); ++it, ++i)
        a[i] = *it;
}

// Konstruktor kopiujący
polynomial::polynomial(const polynomial &p) : n(p.n), a(new complex[p.n + 1]) {
    for (int i = 0; i <= n; i++){
        a[i] = p.a[i];
    }
}

// Konstruktor przenoszący
polynomial::polynomial(polynomial &&p) noexcept : n(p.n), a(p.a) {
    p.a = nullptr;
    p.n = 0;
}

// Operator przypisania kopiujący
polynomial& polynomial::operator=(const polynomial &p) {
    if (this != &p) {
        delete [] a;
        n = p.n;
        a = new complex[n + 1];
        for (int i = 0; i <= n; i++){
            a[i] = p.a[i];
        }
    }
    return *this;
}

// Operator przypisania przenoszący
polynomial& polynomial::operator=(polynomial &&p) noexcept {
    if (this != &p) {
        delete [] a;
        n = p.n;
        a = p.a;
        p.a = nullptr;
        p.n = 0;
    }
    return *this;
}

// Destruktor – zwalnia pamięć
polynomial::~polynomial() {
    delete [] a;
}

// Operator indeksowania do modyfikacji
complex& polynomial::operator[](int i) {
    if(i < 0 || i > n)
        throw std::out_of_range("Indeks spoza zakresu");
    return a[i];
}

// Operator indeksowania do odczytu
const complex& polynomial::operator[](int i) const {
    if(i < 0 || i > n)
        throw std::out_of_range("Indeks spoza zakresu");
    return a[i];
}

// Dostęp do stopnia wielomianu
int polynomial::degree() const {
    return n;
}

// Operator wywołania – oblicza wartość wielomianu metodą Hornera
complex polynomial::operator()(const complex &x) const {
    complex result = a[n];
    for (int i = n - 1; i >= 0; i--) {
        result = result * x + a[i];
    }
    return result;
}

// Operator dodawania wielomianów
polynomial operator+(const polynomial &p1, const polynomial &p2) {
    int max_deg = std::max(p1.degree(), p2.degree());
    int min_deg = std::min(p1.degree(), p2.degree());
    polynomial result;
    delete [] result.a;
    result.n = max_deg;
    result.a = new complex[max_deg + 1];
    for (int i = 0; i <= max_deg; i++){
        result.a[i] = complex(0,0);
    }
    for (int i = 0; i <= min_deg; i++){
        result.a[i] = p1[i] + p2[i];
    }
    if(p1.degree() > p2.degree()){
        for(int i = min_deg + 1; i <= max_deg; i++){
            result.a[i] = p1[i];
        }
    } else {
        for(int i = min_deg + 1; i <= max_deg; i++){
            result.a[i] = p2[i];
        }
    }
    return result;
}

// Operator odejmowania wielomianów
polynomial operator-(const polynomial &p1, const polynomial &p2) {
    int max_deg = std::max(p1.degree(), p2.degree());
    int min_deg = std::min(p1.degree(), p2.degree());
    polynomial result;
    delete [] result.a;
    result.n = max_deg;
    result.a = new complex[max_deg + 1];
    for (int i = 0; i <= max_deg; i++){
        result.a[i] = complex(0,0);
    }
    for (int i = 0; i <= min_deg; i++){
        result.a[i] = p1[i] - p2[i];
    }
    if(p1.degree() > p2.degree()){
        for(int i = min_deg + 1; i <= max_deg; i++){
            result.a[i] = p1[i];
        }
    } else {
        for(int i = min_deg + 1; i <= max_deg; i++){
            result.a[i] = complex(0,0) - p2[i];
        }
    }
    return result;
}

// Operator mnożenia wielomianu przez stałą zespoloną
polynomial operator*(const polynomial &p, const complex &c) {
    polynomial result(p);
    for (int i = 0; i <= p.degree(); i++){
        result[i] = result[i] * c;
    }
    return result;
}

// Operator mnożenia dwóch wielomianów
polynomial operator*(const polynomial &p1, const polynomial &p2) {
    int deg1 = p1.degree();
    int deg2 = p2.degree();
    int new_deg = deg1 + deg2;
    polynomial result;
    delete [] result.a;
    result.n = new_deg;
    result.a = new complex[new_deg + 1];
    for (int i = 0; i <= new_deg; i++){
        result.a[i] = complex(0,0);
    }
    for (int i = 0; i <= deg1; i++){
        for (int j = 0; j <= deg2; j++){
            result.a[i + j] = result.a[i + j] + (p1[i] * p2[j]);
        }
    }
    return result;
}

// Operator wypisywania wielomianu
std::ostream& operator<<(std::ostream &os, const polynomial &p) {
    for (int i = 0; i <= p.degree(); i++){
        os << p[i];
        if(i > 0)
            os << "*x^" << i;
        if(i != p.degree())
            os << " + ";
    }
    return os;
}

// Operator wczytywania wielomianu
std::istream& operator>>(std::istream &is, polynomial &p) {
    int deg;
    is >> deg;
    if(deg < 0)
        throw std::runtime_error("Stopień wielomianu nie może być ujemny");
    delete [] p.a;
    p.n = deg;
    p.a = new complex[deg + 1];
    for (int i = 0; i <= deg; i++){
        is >> p.a[i];
    }
    return is;
}

} // namespace calc
