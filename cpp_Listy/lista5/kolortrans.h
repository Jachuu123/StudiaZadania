#ifndef KOLORTRANSPARENTNY_H
#define KOLORTRANSPARENTNY_H

#include "kolor.h"

class kolortransparentny : virtual public kolor {
protected:
    unsigned short alpha; // [0..255], 0 = przezroczysty, 255 = pełny kolor

public:
    kolortransparentny();
    kolortransparentny(unsigned short rr, unsigned short gg, unsigned short bb, unsigned short aa);

    unsigned short getAlpha() const;
    void setAlpha(unsigned short aa);
};

#endif
