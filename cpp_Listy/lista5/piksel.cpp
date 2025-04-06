#include "piksel.h"
#include <stdexcept>
#include <cmath>

piksel::piksel() : x(0), y(0) {}

piksel::piksel(int xx, int yy) {
    if(xx < 0 || xx >= SCREEN_WIDTH || yy < 0 || yy >= SCREEN_HEIGHT) {
        throw std::runtime_error("Piksel poza obszarem ekranu.");
    }
    x = xx;
    y = yy;
}

int piksel::getX() const {
    return x;
}

int piksel::getY() const {
    return y;
}

void piksel::setX(int xx) {
    if(xx < 0 || xx >= SCREEN_WIDTH) {
        throw std::runtime_error("Współrzędna x poza obszarem ekranu.");
    }
    x = xx;
}

void piksel::setY(int yy) {
    if(yy < 0 || yy >= SCREEN_HEIGHT) {
        throw std::runtime_error("Współrzędna y poza obszarem ekranu.");
    }
    y = yy;
}

int piksel::distanceLeft() const {
    return x;
}

int piksel::distanceRight() const {
    return SCREEN_WIDTH - 1 - x;
}

int piksel::distanceTop() const {
    return y;
}

int piksel::distanceBottom() const {
    return SCREEN_HEIGHT - 1 - y;
}

double piksel::distance(const piksel* p1, const piksel* p2) {
    if(!p1 || !p2) {
        throw std::runtime_error("Niepoprawny wskaźnik na piksel.");
    }
    int dx = p1->x - p2->x;
    int dy = p1->y - p2->y;
    return std::sqrt(dx * dx + dy * dy);
}

double piksel::distance(const piksel &p1, const piksel &p2) {
    int dx = p1.x - p2.x;
    int dy = p1.y - p2.y;
    return std::sqrt(dx * dx + dy * dy);
}
