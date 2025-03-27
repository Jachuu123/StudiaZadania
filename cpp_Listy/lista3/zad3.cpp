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

// delegatowy, bezparametrowy i z zadaną pojemnością
Queue::Queue(int capacity = 1) : capacity(capacity), front(0), count(0) {
    points = new Point[capacity];
    //std::cout << "Queue created with capacity " << capacity << std::endl;
}

<<<<<<< HEAD
// Konstruktor delegacyjny
Queue::Queue() : Queue(1) {}
=======
Queue:Queue() 
>>>>>>> cfc99e8 (cpp lista3)

// Konstruktor kopiujący
Queue::Queue(const Queue &q) : Queue(q.capacity) {
    front = q.front;
    count = q.count;
    for (int i = 0; i < count; ++i) {
        points[i] = q.points[i];
    }
}

// Konstruktor przenoszący
Queue::Queue(Queue &&q) noexcept : Queue() {
    std::swap(points, q.points);
    std::swap(capacity, q.capacity);
    std::swap(front, q.front);
    std::swap(count, q.count);
}

// Konstruktor inicjalizujący za pomocą listy punktów
Queue::Queue(std::initializer_list<Point> initList) : Queue(initList.size()) {
    int i = 0;
    for (const auto &p : initList) {
        points[i++] = p;
    }
    count = initList.size();
}

// Destruktor
Queue::~Queue() {
    delete[] points;
    }


// operator kopiowania
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
//operator przenoszenia
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