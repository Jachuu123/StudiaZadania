#ifndef PIKSELKOLOROWY_H
#define PIKSELKOLOROWY_H

#include "piksel.h"
#include "kolor.h"

class pikselkolorowy : public piksel, private kolor {
public:
    pikselkolorowy();
    pikselkolorowy(int xx, int yy, unsigned short rr, unsigned short gg, unsigned short bb);

    // Przemieszczanie piksela
    void move(int dx, int dy);

    // Udostępniamy publicznie metody dziedziczone z 'kolor' (opcjonalnie)
    using kolor::getR;
    using kolor::getG;
    using kolor::getB;
    using kolor::setR;
    using kolor::setG;
    using kolor::setB;
    using kolor::lighten;
    using kolor::darken;
};

#endif
