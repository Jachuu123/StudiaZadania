#include <iostream>
#include "geometry.h"

int main() {
    // Tworzenie punktów
    Point p1(1.0, 2.0);
    Point p2(4.0, 6.0);

    // Obliczanie odległości między punktami
    std::cout << "Odległość między p1 a p2: " << distance(p1, p2) << std::endl;

    // Tworzenie wektora
    Vector v(3.0, 4.0);
    std::cout << "Wektor v: (" << v.getDx() << ", " << v.getDy() << ")" << std::endl;

    // Tworzenie linii
    Line line(1.0, -1.0, 0.0);
    std::cout << "Linia: " << line.getA() << "x + " << line.getB() << "y + " << line.getC() << " = 0" << std::endl;

    // Tworzenie koła
    Circle circle(p1, 5.0);
    std::cout << "Koło: środek (" << circle.getCenter().getX() << ", " << circle.getCenter().getY() << "), promień " << circle.getRadius() << std::endl;

    // Sprawdzanie, czy punkt należy do koła
    std::cout << "Czy p2 należy do koła? " << (circle.contains(p2) ? "Tak" : "Nie") << std::endl;

    // Translacja koła
    circle.translate(2.0, 3.0);
    std::cout << "Po translacji: środek (" << circle.getCenter().getX() << ", " << circle.getCenter().getY() << ")" << std::endl;

    // Obrót punktu wokół innego punktu
    p1.rotate(M_PI / 4, p2);
    std::cout << "Po obrocie p1 wokół p2: (" << p1.getX() << ", " << p1.getY() << ")" << std::endl;

    // Symetria środkowa punktu względem innego punktu
    p1.centralSymmetry(p2);
    std::cout << "Po symetrii środkowej p1 względem p2: (" << p1.getX() << ", " << p1.getY() << ")" << std::endl;

    // Symetria osiowa punktu względem linii
    p1.axisSymmetry(line);
    std::cout << "Po symetrii osiowej p1 względem linii: (" << p1.getX() << ", " << p1.getY() << ")" << std::endl;

    // Symetria osiowa koła względem linii
    circle.axisSymmetry(line);
    std::cout << "Po symetrii osiowej koła względem linii: środek (" << circle.getCenter().getX() << ", " << circle.getCenter().getY() << ")" << std::endl;

    // Obliczanie obwodu i pola powierzchni koła
    std::cout << "Obwód koła: " << circle.circumference() << std::endl;
    std::cout << "Pole powierzchni koła: " << circle.area() << std::endl;

    // Tworzenie drugiego koła
    Circle circle2(p2, 3.0);

    // Sprawdzanie, czy koło circle2 zawiera się w circle
    std::cout << "Czy circle2 zawiera się w circle? " << (circleInside(circle2, circle) ? "Tak" : "Nie") << std::endl;

    // Sprawdzanie, czy koła circle i circle2 są rozłączne
    std::cout << "Czy koła circle i circle2 są rozłączne? " << (circlesAreDisjoint(circle, circle2) ? "Tak" : "Nie") << std::endl;

    return 0;
}