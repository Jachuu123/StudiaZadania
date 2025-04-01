#include "wielom.h"
#include <iostream>
#include <stdexcept>
#include <initializer_list>
#include <algorithm>
using namespace std;

void wielom::allocate(int degree) {
    n = degree;
    a = new double[n + 1];
}

// Konstruktor jednomianu
wielom::wielom(int st, double wsp) {
    if (st < 0)
        throw invalid_argument("Stopień wielomianu nie może być ujemny.");
    allocate(st);

    for (int i = 0; i < st; i++) {
        a[i] = 0.0;
    }
    if (st > 0 && wsp == 0.0)
        throw invalid_argument("Współczynnik przy najwyższej potędze nie może być 0.");
    a[st] = wsp;
}

// Konstruktor z tablicą współczynników
wielom::wielom(int st, const double wsp[]) {
    if (st < 0)
        throw invalid_argument("Stopień wielomianu nie może być ujemny.");
    allocate(st);
    for (int i = 0; i <= st; i++) {
        a[i] = wsp[i];
    }
    if (st > 0 && a[st] == 0.0)
        throw invalid_argument("Współczynnik przy najwyższej potędze nie może być 0.");
}

// Konstruktor z listą inicjalizującą {}
wielom::wielom(initializer_list<double> wsp) {
    int size = wsp.size();
    if (size == 0)
        throw invalid_argument("Lista współczynników nie może być pusta.");
    allocate(size - 1);
    int i = 0;
    for (double val : wsp) {
        a[i++] = val;
    }
    if (n > 0 && a[n] == 0.0)
        throw invalid_argument("Współczynnik przy najwyższej potędze nie może być 0.");
}

// Konstruktor kopiujący
wielom::wielom(const wielom &w) {
    allocate(w.n);
    for (int i = 0; i <= n; i++) {
        a[i] = w.a[i];
    }
}

// Konstruktor przenoszący
wielom::wielom(wielom &&w) {
    n = w.n;
    a = w.a;
    w.a = nullptr;
    w.n = 0;
}

// Operator przypisania kopiujący
wielom& wielom::operator=(const wielom &w) {
    if (this != &w) {
        delete[] a;
        allocate(w.n);
        for (int i = 0; i <= n; i++) {
            a[i] = w.a[i];
        }
    }
    return *this;
}

// Operator przypisania przenoszący
wielom& wielom::operator=(wielom &&w) {
    if (this != &w) {
        delete[] a;
        n = w.n;
        a = w.a;
        w.a = nullptr;
        w.n = 0;
    }
    return *this;
}

// Destruktor
wielom::~wielom() {
    delete[] a;
}

// Operator indeksowania do odczytu
double wielom::operator[](int i) const {
    if (i < 0 || i > n)
        throw out_of_range("Indeks spoza zakresu.");
    return a[i];
}

// Operator indeksowania do zapisu
double& wielom::operator[](int i) {
    if (i < 0 || i > n)
        throw out_of_range("Indeks spoza zakresu.");
    if (i == n && n > 0 && a[i] == 0.0)
        throw invalid_argument("Współczynnik przy najwyższej potędze nie może być 0.");
    return a[i];
}

// Operator wywołania – (schemat Hornera)
double wielom::operator()(double x) const {
    double result = a[n];
    for (int i = n - 1; i >= 0; i--) {
        result = result * x + a[i];
    }
    return result;
}

// Operator += (dodawanie wielomianów)
wielom& wielom::operator+=(const wielom &v) {
    int maxDegree = std::max(n, v.n);
    double* newCoeffs = new double[maxDegree + 1]{0.0};

    for (int i = 0; i <= n; i++)
        newCoeffs[i] += a[i];
    for (int i = 0; i <= v.n; i++)
        newCoeffs[i] += v.a[i];

    int newDegree = maxDegree;
    while (newDegree > 0 && newCoeffs[newDegree] == 0.0)
        newDegree--;

    delete[] a;
    n = newDegree;
    a = new double[n + 1];
    for (int i = 0; i <= n; i++)
        a[i] = newCoeffs[i];
    delete[] newCoeffs;
    return *this;
}

// Operator -= (odejmowanie wielomianów)
wielom& wielom::operator-=(const wielom &v) {
    int maxDegree = std::max(n, v.n);
    double* newCoeffs = new double[maxDegree + 1]{0.0};

    for (int i = 0; i <= n; i++)
        newCoeffs[i] += a[i];
    for (int i = 0; i <= v.n; i++)
        newCoeffs[i] -= v.a[i];

    int newDegree = maxDegree;
    while (newDegree > 0 && newCoeffs[newDegree] == 0.0)
        newDegree--;

    delete[] a;
    n = newDegree;
    a = new double[n + 1];
    for (int i = 0; i <= n; i++)
        a[i] = newCoeffs[i];
    delete[] newCoeffs;
    return *this;
}

// Operator *= (mnożenie przez wielomian)
wielom& wielom::operator*=(const wielom &v) {
    int newDegree = n + v.n;
    double* newCoeffs = new double[newDegree + 1]{0.0};

    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= v.n; j++) {
            newCoeffs[i + j] += a[i] * v.a[j];
        }
    }
    if (newDegree > 0 && newCoeffs[newDegree] == 0.0) {
        delete[] newCoeffs;
        throw std::invalid_argument("Wynik mnożenia nie jest wielomianem właściwym (najwyższy współczynnik jest 0).");
    }
    delete[] a;
    n = newDegree;
    a = newCoeffs;
    return *this;
}

// Operator *= (mnożenie przez stałą)
wielom& wielom::operator*=(double c) {
    for (int i = 0; i <= n; i++) {
        a[i] *= c;
    }
    if (n > 0 && a[n] == 0.0)
        throw std::invalid_argument("Współczynnik przy najwyższej potędze nie może być 0 po mnożeniu.");
    return *this;
}

// Operator >> (wczytywanie wielomianu)
std::istream& operator>>(std::istream &we, wielom &w) {
    int stop;
    we >> stop;
    if (stop < 0) {
        we.setstate(std::ios::failbit);
        return we;
    }
    double* newCoeffs = new double[stop + 1];
    for (int i = 0; i <= stop; i++) {
        we >> newCoeffs[i];
    }
    if (stop > 0 && newCoeffs[stop] == 0.0) {
        delete[] newCoeffs;
        we.setstate(std::ios::failbit);
        throw std::invalid_argument("Współczynnik przy najwyższej potędze nie może być 0.");
    }
    delete[] w.a;
    w.n = stop;
    w.a = newCoeffs;
    return we;
}

// Operator << (wypisywanie wielomianu)
std::ostream& operator<<(std::ostream &wy, const wielom &w) {
    for (int i = w.n; i >= 0; i--) {
        if (i == w.n) {
            wy << w.a[i] << "x^" << i;
        } else {
            if (w.a[i] >= 0)
                wy << " + " << w.a[i];
            else
                wy << " - " << -w.a[i];
            if (i > 0)
                wy << "x^" << i;
        }
    }
    return wy;
}

// Operator + (dodawanie wielomianów)
wielom operator+(const wielom &u, const wielom &v) {
    wielom result = u;
    result += v;
    return result;
}

// Operator - (odejmowanie wielomianów)
wielom operator-(const wielom &u, const wielom &v) {
    wielom result = u;
    result -= v;
    return result;
}

// Operator * (mnożenie wielomianów)
wielom operator*(const wielom &u, const wielom &v) {
    int newDegree = u.n + v.n;
    double* newCoeffs = new double[newDegree + 1]{0.0};

    for (int i = 0; i <= u.n; i++) {
        for (int j = 0; j <= v.n; j++) {
            newCoeffs[i + j] += u.a[i] * v.a[j];
        }
    }
    if (newDegree > 0 && newCoeffs[newDegree] == 0.0) {
        delete[] newCoeffs;
        throw std::invalid_argument("Wynik mnożenia nie jest wielomianem właściwym (najwyższy współczynnik jest 0).");
    }
    wielom result(0, 0.0); // pomocniczy
    delete[] result.a;
    result.n = newDegree;
    result.a = newCoeffs;
    return result;
}

// Operator * (mnożenie przez stałą, wersja: wielomian * stała)
wielom operator*(const wielom &w, double c) {
    wielom result = w;
    result *= c;
    return result;
}

// Operator * (mnożenie przez stałą, wersja: stała * wielomian)
wielom operator*(double c, const wielom &w) {
    return w * c;
}
