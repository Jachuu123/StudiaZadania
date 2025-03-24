#include "zad3.h"
#include <iostream>
#include <stdexcept>

// Implementacja klasy Point

Point::Point() : x(0), y(0) {}

Point::Point(double xVal, double yVal) : x(xVal), y(yVal) {}

double Point::getX() const {
    return x;
}

double Point::getY() const {
    return y;
}

void Point::setX(double xVal) {
    x = xVal;
}

void Point::setY(double yVal) {
    y = yVal;
}

// Implementacja klasy Queue

Queue::Queue(int capacity) : capacity(capacity), front(0), count(0) {
    points = new Point[capacity];
}


//kopiowanie
Queue::Queue(const Queue &q) : capacity(q.capacity), front(q.front), count(q.count) {
    points = new Point[capacity];
    for (int i = 0; i < count; ++i) {
        points[i] = q.points[i];
    }
}

//przenoszenie
Queue::Queue(Queue &&q) noexcept : points(q.points), capacity(q.capacity), front(q.front), count(q.count) {
    q.points = nullptr;
    q.capacity = 0;
    q.front = 0;
    q.count = 0;
}

Queue::Queue(std::initializer_list<Point> initList) : capacity(initList.size()), front(0), count(initList.size()) {
    points = new Point[capacity];
    int i = 0;
    for (const auto &p : initList) {
        points[i++] = p;
    }
}

Queue::~Queue() {
    delete[] points;
}

Queue& Queue::operator=(const Queue &q) {
    if (this != &q) {
        delete[] points;
        capacity = q.capacity;
        front = q.front;
        count = q.count;
        points = new Point[capacity];
        for (int i = 0; i < count; ++i) {
            points[i] = q.points[i];
        }
    }
    return *this;
}

Queue& Queue::operator=(Queue &&q) noexcept {
    if (this != &q) {
        delete[] points;
        points = q.points;
        capacity = q.capacity;
        front = q.front;
        count = q.count;
        q.points = nullptr;
        q.capacity = 0;
        q.front = 0;
        q.count = 0;
    }
    return *this;
}

void Queue::wstaw(const Point &p) {
    if (count == capacity) {
        throw std::overflow_error("Queue is full");
    }
    int end = (front + count) % capacity;
    points[end] = p;
    ++count;
}

Point Queue::usun() {
    if (count == 0) {
        throw std::underflow_error("Queue is empty");
    }
    Point p = points[front];
    front = (front + 1) % capacity;
    --count;
    return p;
}

Point Queue::zprzodu() const {
    if (count == 0) {
        throw std::underflow_error("Queue is empty");
    }
    return points[front];
}

int Queue::dlugosc() const {
    return count;
}