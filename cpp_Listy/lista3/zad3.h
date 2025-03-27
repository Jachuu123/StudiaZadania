#ifndef ZAD_3_H
#define ZAD_3_H

#include <initializer_list>

class Point {
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
};

class Queue {
private:
    Point *points;
    int size;
    int capacity;
    int front;
    int count;

public:
    // Konstruktory
    Queue();
<<<<<<< HEAD
    explicit Queue(int capacity);
=======
    Queue(int capacity = 1);
>>>>>>> cfc99e8 (cpp lista3)
    Queue(const Queue &q);
    Queue(Queue &&q) noexcept;
    Queue(std::initializer_list<Point> initList);

    // Destruktor
    ~Queue();

    // Operatory przypisania
    Queue& operator=(const Queue &q);
    Queue& operator=(Queue &&q) noexcept;

    // Funkcje składowe
    void wstaw(const Point &p);
    Point usun();
    Point zprzodu() const;
    int dlugosc() const;
};

#endif // ZAD_3_H