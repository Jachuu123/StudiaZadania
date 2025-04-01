#include "zad3.h"
#include <iostream>
#include <cassert>

void testQueue() {
    // Test konstruktorów
    Queue q1(3);
    assert(q1.dlugosc() == 0);

    Queue q3 = {Point(1, 2), Point(3, 4), Point(5, 6)};
    assert(q3.dlugosc() == 3);
    assert(q3.zprzodu().getX() == 1 && q3.zprzodu().getY() == 2);

    // Test konstruktor kopiujący
    Queue q4(q3);
    assert(q4.dlugosc() == 3);
    assert(q4.zprzodu().getX() == 1 && q4.zprzodu().getY() == 2);

    // Test konstruktor przenoszący
    Queue q5(std::move(q4));
    assert(q5.dlugosc() == 3);
    assert(q5.zprzodu().getX() == 1 && q5.zprzodu().getY() == 2);
    assert(q4.dlugosc() == 0); // q4 jest teraz pusty

    // Test operator przypisania kopiujący
    q1.wstaw(Point(7, 8));
    Queue q2 = q1;
    assert(q2.dlugosc() == 1);
    assert(q2.zprzodu().getX() == 7 && q2.zprzodu().getY() == 8);

    // Wstawiamy element do q1, sprawdzamy czy q2 się nie zmienił
    q1.wstaw(Point(9, 10));
    assert(q1.dlugosc() == 2);
    assert(q1.zprzodu().getX() == 7 && q1.zprzodu().getY() == 8);
    assert(q2.dlugosc() == 1); // q2 nie powinien być zmieniony
    assert(q2.zprzodu().getX() == 7 && q2.zprzodu().getY() == 8);

    // Test operator przypisania przenoszący
    q2 = std::move(q5);
    assert(q2.dlugosc() == 3);
    assert(q2.zprzodu().getX() == 1 && q2.zprzodu().getY() == 2);
    assert(q5.dlugosc() == 0); // q5 jest teraz pusty co znaczy, że zamieniliśmy q2 z q5 więc wiemy że działa
}

int main() {
    testQueue();
    std::cout << "All tests passed!" << std::endl;
    return 0;
}