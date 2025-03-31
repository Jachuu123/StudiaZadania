#include <iostream>
#include "wielom.h"

using namespace std;

int main() {
    try {
        wielom w1;  // (1*x^0)
        cout << "w1: " << w1 << endl;

        wielom w2(2, 3.0); // 3*x^2
        cout << "w2: " << w2 << endl;

        double coeffs[] = {1.0, -2.0, 3.0}; // 3*x^2 - 2*x + 1
        wielom w3(2, coeffs);
        cout << "w3: " << w3 << endl;

        wielom w4 = {1.0, 0.0, 4.0}; // 4*x^2 + 0*x + 1
        cout << "w4: " << w4 << endl;

        // Test operatora indeksowania
        cout << "w3[1] = " << w3[1] << endl;
        w3[1] = -5.0;
        cout << "Po zmianie w3: " << w3 << endl;

        //schemat Hornera
        double x = 2.0;
        cout << "w3(" << x << ") = " << w3(x) << endl;

        // Test operatorów arytmetycznych
        wielom sum = w2 + w3;
        cout << "w2 + w3: " << sum << endl;

        wielom diff = w3 - w2;
        cout << "w3 - w2: " << diff << endl;

        wielom prod = w3 * w4;
        cout << "w3 * w4: " << prod << endl;

        wielom scaled = w3 * 2.0;
        cout << "w3 * 2.0: " << scaled << endl;

        // Test operatorów przypisania arytmetycznego
        w3 += w2;
        cout << "w3 += w2: " << w3 << endl;

        w3 -= w2;
        cout << "w3 -= w2: " << w3 << endl;

        w3 *= 3.0;
        cout << "w3 *= 3.0: " << w3 << endl;

        // Test wczytywania wielomianu ze standardowego wejścia
        cout << "\nPodaj wielomian (najpierw stopień, potem kolejne współczynniki): ";
        wielom w_input;
        cin >> w_input;
        cout << "Wczytany wielomian: " << w_input << endl;
    }
    catch (const std::exception &e) {
        std::cerr << "Blad: " << e.what() << std::endl;
    }
    return 0;
}
