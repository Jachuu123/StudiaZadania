#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <stdexcept>
#include <cmath>

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


    void translate(double dx, double dy);

    void rotate(double angle, const Point &center);

    void centralSymmetry(const Point &center);

    void axisSymmetry(const Line &line);
};


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
    Line();
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

    void translate(double dx, double dy);

    void rotate(double angle, const Point &centerOfRotation);

    void centralSymmetry(const Point &centerOfSym);

    void axisSymmetry(const Line &line);


    double circumference() const;
    double area() const;

    bool contains(const Point &p) const;
};


bool circleInside(const Circle &c1, const Circle &c2);

bool circlesAreDisjoint(const Circle &c1, const Circle &c2);

#endif // GEOMETRY_H