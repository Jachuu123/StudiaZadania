#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <stdexcept>
#include <cmath>

// Forward declarations
class Line;
class Point;
class Vector;
class Circle;

// ----- Klasa Point -----
class Point
{
private:
    double x;
    double y;

public:
    // Konstruktory
    Point();
    Point(double xVal, double yVal);

    // Gettery
    double getX() const;
    double getY() const;

    // Settery
    void setX(double xVal);
    void setY(double yVal);

    // Przekształcenia izometryczne:
    // 1) Translacja (przesunięcie o wektor dx, dy)
    void translate(double dx, double dy);

    // 2) Obrót wokół zadanego punktu o kąt w radianach
    void rotate(double angle, const Point &center);

    // 3) Symetria środkowa względem punktu
    void centralSymmetry(const Point &center);

    // 4) Symetria osiowa względem prostej (Line)
    void axisSymmetry(const Line &line);
};

// Funkcja globalna do liczenia odległości między dwoma punktami
double distance(const Point &p1, const Point &p2);

// ----- Klasa Vector -----
class Vector
{
private:
    double dx;
    double dy;

public:
    // Konstruktory
    Vector();
    Vector(double dxVal, double dyVal);

    // Gettery
    double getDx() const;
    double getDy() const;

    // Settery
    void setDx(double dxVal);
    void setDy(double dyVal);
};

// ----- Klasa Line -----
class Line
{
private:
    double A;
    double B;
    double C;

public:
    // Konstruktory
    Line();               // bezargumentowy
    Line(double AVal, double BVal, double CVal);

    // Gettery
    double getA() const;
    double getB() const;
    double getC() const;

    // Settery
    void setA(double AVal);
    void setB(double BVal);
    void setC(double CVal);
};

// ----- Klasa Circle -----
class Circle
{
private:
    Point center;
    double radius;

public:
    // Konstruktory
    Circle();
    Circle(const Point &c, double r);

    // Gettery
    Point getCenter() const;
    double getRadius() const;

    // Settery
    void setCenter(const Point &c);
    void setRadius(double r);

    // Przekształcenia izometryczne (zachowują kształt i rozmiar):
    // 1) Translacja
    void translate(double dx, double dy);

    // 2) Obrót wokół zadanego punktu o kąt (w radianach)
    void rotate(double angle, const Point &centerOfRotation);

    // 3) Symetria środkowa względem punktu
    void centralSymmetry(const Point &centerOfSym);

    // 4) Symetria osiowa względem prostej (Line)
    void axisSymmetry(const Line &line);

    // Funkcje obliczeniowe
    double circumference() const; // obwód
    double area() const;         // pole powierzchni

    // Funkcja sprawdzająca, czy punkt należy do koła
    bool contains(const Point &p) const;
};

// Funkcje globalne do pracy z kołami:
// 1) Sprawdza, czy kolo c1 zawiera się w c2
bool circleInside(const Circle &c1, const Circle &c2);

// 2) Sprawdza, czy koła c1 i c2 są rozłączne
bool circlesAreDisjoint(const Circle &c1, const Circle &c2);

#endif // GEOMETRY_H