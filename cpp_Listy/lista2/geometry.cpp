#include "geometry.h"

// ----- Implementacja klasy Point -----
Point::Point() : x(0), y(0) {}

Point::Point(double xVal, double yVal) : x(xVal), y(yVal) {}

double Point::getX() const { return x; }
double Point::getY() const { return y; }

void Point::setX(double xVal) { x = xVal; }
void Point::setY(double yVal) { y = yVal; }

void Point::translate(double dx, double dy) {
    x += dx;
    y += dy;
}

void Point::rotate(double angle, const Point &center) {
    double s = sin(angle);
    double c = cos(angle);

    // Translate point back to origin
    double xNew = x - center.getX();
    double yNew = y - center.getY();

    // Rotate point
    double xRotated = xNew * c - yNew * s;
    double yRotated = xNew * s + yNew * c;

    // Translate point back
    x = xRotated + center.getX();
    y = yRotated + center.getY();
}

void Point::centralSymmetry(const Point &center) {
    x = 2 * center.getX() - x;
    y = 2 * center.getY() - y;
}

void Point::axisSymmetry(const Line &line) {
    double A = line.getA();
    double B = line.getB();
    double C = line.getC();

    double D = A * A + B * B;
    double xNew = (B * B * x - A * B * y - A * C) / D;
    double yNew = (A * A * y - A * B * x - B * C) / D;

    x = 2 * xNew - x;
    y = 2 * yNew - y;
}

double distance(const Point &p1, const Point &p2) {
    return sqrt(pow(p2.getX() - p1.getX(), 2) + pow(p2.getY() - p1.getY(), 2));
}

// ----- Implementacja klasy Vector -----
Vector::Vector() : dx(0), dy(0) {}

Vector::Vector(double dxVal, double dyVal) : dx(dxVal), dy(dyVal) {}

double Vector::getDx() const { return dx; }
double Vector::getDy() const { return dy; }

void Vector::setDx(double dxVal) { dx = dxVal; }
void Vector::setDy(double dyVal) { dy = dyVal; }

// ----- Implementacja klasy Line -----
Line::Line() : A(0), B(0), C(0) {}

Line::Line(double AVal, double BVal, double CVal) : A(AVal), B(BVal), C(CVal) {}

double Line::getA() const { return A; }
double Line::getB() const { return B; }
double Line::getC() const { return C; }

void Line::setA(double AVal) { A = AVal; }
void Line::setB(double BVal) { B = BVal; }
void Line::setC(double CVal) { C = CVal; }

// ----- Implementacja klasy Circle -----
Circle::Circle() : center(Point()), radius(0) {}

Circle::Circle(const Point &c, double r) : center(c), radius(r) {}

Point Circle::getCenter() const { return center; }
double Circle::getRadius() const { return radius; }

void Circle::setCenter(const Point &c) { center = c; }
void Circle::setRadius(double r) { radius = r; }

void Circle::translate(double dx, double dy) {
    center.translate(dx, dy);
}

void Circle::rotate(double angle, const Point &centerOfRotation) {
    center.rotate(angle, centerOfRotation);
}

void Circle::centralSymmetry(const Point &centerOfSym) {
    center.centralSymmetry(centerOfSym);
}

void Circle::axisSymmetry(const Line &line) {
    center.axisSymmetry(line);
}

double Circle::circumference() const {
    return 2 * M_PI * radius;
}

double Circle::area() const {
    return M_PI * radius * radius;
}

bool Circle::contains(const Point &p) const {
    return distance(center, p) <= radius;
}

bool circleInside(const Circle &c1, const Circle &c2) {
    double dist = distance(c1.getCenter(), c2.getCenter());
    return dist + c1.getRadius() <= c2.getRadius();
}

bool circlesAreDisjoint(const Circle &c1, const Circle &c2) {
    double dist = distance(c1.getCenter(), c2.getCenter());
    return dist >= c1.getRadius() + c2.getRadius();
}