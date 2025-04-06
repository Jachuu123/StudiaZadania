#include "pikselkol.h"
#include <stdexcept>

pikselkolorowy::pikselkolorowy()
    : piksel(), kolor()
{
    // Domyślny piksel (0,0) z kolorem (0,0,0)
}

pikselkolorowy::pikselkolorowy(int xx, int yy, unsigned short rr, unsigned short gg, unsigned short bb)
    : piksel(xx, yy), kolor(rr, gg, bb)
{
}

void pikselkolorowy::move(int dx, int dy) {
    int newX = x + dx;
    int newY = y + dy;
    if(newX < 0 || newX >= SCREEN_WIDTH ||
       newY < 0 || newY >= SCREEN_HEIGHT) 
    {
        throw std::runtime_error("Próba przesunięcia piksela poza ekran.");
    }
    x = newX;
    y = newY;
}
