#ifndef KOLORTRANSNAZ_H
#define KOLORTRANSNAZ_H

#include "kolortrans.h"
#include "kolornaz.h"
#include <string>

// Dziedziczenie wielobazowe, wirtualne po klasie 'kolor' w obu klasach bazowych
class kolortransnaz 
    : public kolortransparentny, 
      public kolornazwany 
{
public:
    kolortransnaz();
    kolortransnaz(unsigned short rr, unsigned short gg, unsigned short bb, unsigned short aa, const std::string &n);
};

#endif
