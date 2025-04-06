#include "kolor.h"
#include <stdexcept>    // std::runtime_error
#include <algorithm>    // std::min, std::max

kolor::kolor() : r(0), g(0), b(0) {}

kolor::kolor(unsigned short rr, unsigned short gg, unsigned short bb) {
    if (rr > 255 || gg > 255 || bb > 255) {
        throw std::runtime_error("Nieprawidłowy zakres koloru [0..255].");
    }
    r = rr;
    g = gg;
    b = bb;
}

unsigned short kolor::getR() const { return r; }
unsigned short kolor::getG() const { return g; }
unsigned short kolor::getB() const { return b; }

void kolor::setR(unsigned short rr) {
    if(rr > 255) {
        throw std::runtime_error("Nieprawidłowy zakres dla R.");
    }
    r = rr;
}
void kolor::setG(unsigned short gg) {
    if(gg > 255) {
        throw std::runtime_error("Nieprawidłowy zakres dla G.");
    }
    g = gg;
}
void kolor::setB(unsigned short bb) {
    if(bb > 255) {
        throw std::runtime_error("Nieprawidłowy zakres dla B.");
    }
    b = bb;
}

void kolor::lighten(unsigned short value) {
    // Zwiększamy, ale "ścina" do 255
    r = static_cast<unsigned short>(std::min(255, r + value));
    g = static_cast<unsigned short>(std::min(255, g + value));
    b = static_cast<unsigned short>(std::min(255, b + value));
}

void kolor::darken(unsigned short value) {
    // Zmniejszamy, ale nie poniżej 0
    r = (r < value) ? 0 : static_cast<unsigned short>(r - value);
    g = (g < value) ? 0 : static_cast<unsigned short>(g - value);
    b = (b < value) ? 0 : static_cast<unsigned short>(b - value);
}

kolor kolor::average(const kolor &k1, const kolor &k2) {
    return kolor(
        static_cast<unsigned short>((k1.r + k2.r) / 2),
        static_cast<unsigned short>((k1.g + k2.g) / 2),
        static_cast<unsigned short>((k1.b + k2.b) / 2)
    );
}
