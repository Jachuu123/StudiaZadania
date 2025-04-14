#include "complex.h"
#include <cmath>

namespace math {

complex operator+(const complex &x, const complex &y) {
    return complex(x.re() + y.re(), x.im() + y.im());
}

complex operator-(const complex &x, const complex &y) {
    return complex(x.re() - y.re(), x.im() - y.im());
}

complex operator*(const complex &x, const complex &y) {
    return complex(x.re() * y.re() - x.im() * y.im(), x.re() * y.im() + x.im() * y.re());
}

complex operator/(const complex &x, const complex &y) {
    double denominator = y.re()*y.re() + y.im()*y.im();
    if (denominator == 0)
        throw std::runtime_error("Dzielenie przez zero w operacji na liczbach zespolonych");
    return complex((x.re()*y.re() + x.im()*y.im()) / denominator, 
                   (x.im()*y.re() - x.re()*y.im()) / denominator);
}

std::ostream& operator<<(std::ostream &os, const complex &c) {
    os << "(" << c.re() << (c.im() >= 0 ? "+" : "") << c.im() << "i)";
    return os;
}

std::istream& operator>>(std::istream &is, complex &c) {
    // Przyjmujemy, że użytkownik podaje dwie liczby: część rzeczywistą i urojoną.
    double a, b;
    is >> a >> b;
    c = complex(a, b);
    return is;
}

// Implementacja operatora unarnego minus
complex operator-(const complex &x) {
    return complex(-x.re(), -x.im());
}

} // namespace math
