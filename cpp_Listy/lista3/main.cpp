#include "zad3.h"
#include <iostream>
#include <cassert>

void testQueue() {
    try {
        // Test konstruktorów
        Queue q1(3);
        assert(q1.dlugosc() == 0);

        Queue q2;
        assert(q2.dlugosc() == 0);

        Queue q3 = {Point(1, 2), Point(3, 4), Point(5, 6)};
        assert(q3.dlugosc() == 3);
        assert(q3.zprzodu().getX() == 1 && q3.zprzodu().getY() == 2);

        Queue q4(q3);
        assert(q4.dlugosc() == 3);
        assert(q4.zprzodu().getX() == 1 && q4.zprzodu().getY() == 2);

        Queue q5(std::move(q4));
        assert(q5.dlugosc() == 3);
        assert(q5.zprzodu().getX() == 1 && q5.zprzodu().getY() == 2);
        assert(q4.dlugosc() == 0);

        // Test funkcji składowych
        q1.wstaw(Point(1, 2));
        q1.wstaw(Point(3, 4));
        q1.wstaw(Point(5, 6));
        assert(q1.dlugosc() == 3);
        assert(q1.zprzodu().getX() == 1 && q1.zprzodu().getY() == 2);

        Point p = q1.usun();
        assert(p.getX() == 1 && p.getY() == 2);
        assert(q1.dlugosc() == 2);
        assert(q1.zprzodu().getX() == 3 && q1.zprzodu().getY() == 4);

        // Test operatorów przypisania
        q2 = q1;
        assert(q2.dlugosc() == 2);
        assert(q2.zprzodu().getX() == 3 && q2.zprzodu().getY() == 4);

        q5 = std::move(q2);
        assert(q5.dlugosc() == 2);
        assert(q5.zprzodu().getX() == 3 && q5.zprzodu().getY() == 4);
        assert(q2.dlugosc() == 0);

        // Test wyjątków
        try {
            q1.wstaw(Point(7, 8));
        } catch (const std::overflow_error &e) {
            std::cerr << "Exception: " << e.what() << "\n";
        }

        try {
            Queue q6(1);
            q6.usun();
        } catch (const std::underflow_error &e) {
            std::cerr << "Exception: " << e.what() << "\n";
        }

    } catch (const std::exception &e) {
        std::cerr << "Exception: " << e.what() << "\n";
    }
}

int main() {
    testQueue();
    std::cout << "All tests passed!" << std::endl;
    return 0;
}