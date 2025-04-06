#include "kolortrans.h"
#include <stdexcept> // std::runtime_error

kolortransparentny::kolortransparentny()
    : kolor(), alpha(0)
{
    // Domyślnie kolor (0,0,0), alpha=0
}

kolortransparentny::kolortransparentny(unsigned short rr, unsigned short gg, unsigned short bb, unsigned short aa)
    : kolor(rr, gg, bb)
{
    if (aa > 255) {
        throw std::runtime_error("Nieprawidłowy zakres przezroczystości [0..255].");
    }
    alpha = aa;
}

unsigned short kolortransparentny::getAlpha() const {
    return alpha;
}

void kolortransparentny::setAlpha(unsigned short aa) {
    if (aa > 255) {
        throw std::runtime_error("Nieprawidłowy zakres przezroczystości [0..255].");
    }
    alpha = aa;
}
