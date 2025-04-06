#include <iostream>
#include <exception>
#include "kolor.h"
#include "kolortrans.h"
#include "kolornaz.h"
#include "kolortransnaz.h"
#include "piksel.h"
#include "pikselkol.h"

int main() {
    try {
        // Test klasy kolor
        kolor c1;
        kolor c2(100, 200, 50);
        std::cout << "c1 = (" << c1.getR() << "," << c1.getG() << "," << c1.getB() << ")\n";
        std::cout << "c2 = (" << c2.getR() << "," << c2.getG() << "," << c2.getB() << ")\n";

        c2.lighten(30);
        std::cout << "c2 po lighten(30) = ("
                  << c2.getR() << "," << c2.getG() << "," << c2.getB() << ")\n";

        // Test wyjątków w konstruktorze kolor
        try {
            kolor c3(256, 10, 10); // powinien rzucić wyjątek
        } catch(const std::exception &ex) {
            std::cerr << "Oczekiwany wyjątek: " << ex.what() << "\n";
        }

        // Test klasy kolortransparentny
        kolortransparentny ct1(10, 20, 30, 128);
        std::cout << "ct1 = (" << ct1.getR() << "," << ct1.getG() << "," << ct1.getB()
                  << "), alpha=" << ct1.getAlpha() << "\n";

        // Test klasy kolornazwany
        kolornazwany cn1(20, 30, 40, "zielony");
        std::cout << "cn1 = (" << cn1.getR() << "," << cn1.getG() << "," << cn1.getB()
                  << "), nazwa=\"" << cn1.getNazwa() << "\"\n";

        // Test klasy kolortransnaz
        kolortransnaz ctn1(100, 100, 100, 255, "szary");
        std::cout << "ctn1 = (" << ctn1.getR() << "," << ctn1.getG() << "," << ctn1.getB()
                  << "), alpha=" << ctn1.getAlpha()
                  << ", nazwa=\"" << ctn1.getNazwa() << "\"\n";

        // Test klasy piksel
        piksel p1(100, 200);
        piksel p2(110, 210);
        std::cout << "p1 = (" << p1.getX() << "," << p1.getY() << ")\n";
        std::cout << "p2 = (" << p2.getX() << "," << p2.getY() << ")\n";
        std::cout << "distance(p1, p2) = " << piksel::distance(p1, p2) << "\n";

        // Test klasy pikselkolorowy
        pikselkolorowy pk(50, 50, 100, 100, 100);
        std::cout << "pk = (" << pk.getX() << "," << pk.getY() << "), kolor=("
                  << pk.getR() << "," << pk.getG() << "," << pk.getB() << ")\n";
        pk.move(10, 10);
        std::cout << "pk po move(10, 10) = (" << pk.getX() << "," << pk.getY() << ")\n";
        pk.lighten(20);
        std::cout << "pk po lighten(20) = kolor=("
                  << pk.getR() << "," << pk.getG() << "," << pk.getB() << ")\n";

        // Próba wyjścia poza ekran (oczekiwany wyjątek)
        try {
            pk.move(2000, 2000);
        } catch(const std::exception &ex) {
            std::cerr << "Oczekiwany wyjątek move(): " << ex.what() << "\n";
        }

    } catch(const std::exception &e) {
        std::cerr << "Błąd krytyczny: " << e.what() << "\n";
    }

    return 0;
}
