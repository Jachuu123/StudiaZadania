#include <iostream>
#include <cmath>
#include "complex.h"
#include "polynomial.h"

using namespace std;
using namespace math;
using namespace calc;

void testComplex() {
    cout << "Testowanie operacji na liczbach zespolonych:" << endl;
    complex a(3, 4);
    complex b(1, -2);
    cout << "a = " << a << endl;
    cout << "b = " << b << endl;
    cout << "a + b = " << a + b << endl;
    cout << "a - b = " << a - b << endl;
    cout << "a * b = " << a * b << endl;
    try {
        cout << "a / b = " << a / b << endl;
    } catch (const exception &e) {
        cout << "Wyjątek przy dzieleniu: " << e.what() << endl;
    }
    cout << "Sprzężenie liczby a: " << a.conjugated() << endl << endl;
}

void testPolynomial() {
    cout << "Testowanie operacji na wielomianach:" << endl;
    // Przykładowy wielomian p(x) = 1 + (2+3i)*x + (0-1i)*x^2
    polynomial p = { complex(1,0), complex(2,3), complex(0,-1) };
    cout << "Wielomian p(x) = " << p << endl;
    
    // Obliczanie wartości wielomianu dla x = (1,1)
    complex x(1, 1);
    cout << "p(" << x << ") = " << p(x) << endl;
    
    // Test dodawania wielomianów
    polynomial q = { complex(0,0), complex(1,1) }; // q(x) = 0 + (1+1i)*x
    cout << "Wielomian q(x) = " << q << endl;
    polynomial sum = p + q;
    cout << "p(x) + q(x) = " << sum << endl;
    
    // Test mnożenia wielomianów
    polynomial prod = p * q;
    cout << "p(x) * q(x) = " << prod << endl << endl;
}

void solveQuadratic() {
    // Rozwiązywanie równania kwadratowego: a*z^2 + b*z + c = 0, gdzie a, b, c ∈ ℂ
    cout << "Rozwiązanie równania kwadratowego a*z^2 + b*z + c = 0:" << endl;
    cout << "Podaj wspólczynnik a (real imaginary): ";
    complex a;
    cin >> a;
    if(a.re() == 0 && a.im() == 0){
        cout << "Współczynnik a nie może być zerowy." << endl;
        return;
    }
    cout << "Podaj wspólczynnik b (real imaginary): ";
    complex b;
    cin >> b;
    cout << "Podaj wspólczynnik c (real imaginary): ";
    complex c;
    cin >> c;
    
    // Delta = b^2 - 4*a*c
    complex delta = b * b - complex(4,0) * a * c;
    
    // Obliczanie pierwiastka delta
    // Używamy wzoru: sqrt(delta) = sqrt((|delta|+Re(delta))/2) + i*sgn(Im(delta))*sqrt((|delta|-Re(delta))/2)
    double modDelta = sqrt(delta.re()*delta.re() + delta.im()*delta.im());
    double realPart = sqrt((modDelta + delta.re())/2);
    double imagPart = sqrt((modDelta - delta.re())/2);
    if(delta.im() < 0)
        imagPart = -imagPart;
    complex sqrtDelta(realPart, imagPart);
    
    complex twoA = complex(2,0) * a;
    complex root1 = (-b + sqrtDelta) / twoA;
    complex root2 = (-b - sqrtDelta) / twoA;
    
    cout << "Pierwiastki równania:" << endl;
    cout << "z1 = " << root1 << endl;
    cout << "z2 = " << root2 << endl;
}

int main(){
    try {
        testComplex();
        testPolynomial();
        solveQuadratic();
    } catch (const exception &ex) {
        cout << "Wyjatek: " << ex.what() << endl;
    }
    return 0;
}
