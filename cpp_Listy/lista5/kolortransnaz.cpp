#include "kolortransnaz.h"

kolortransnaz::kolortransnaz()
    : kolor(), kolortransparentny(), kolornazwany()
{
    // Domyślny kolor (0,0,0), alpha=0, nazwa pusta
}

kolortransnaz::kolortransnaz(unsigned short rr, unsigned short gg, unsigned short bb, unsigned short aa, const std::string &n)
    : kolor(rr, gg, bb),               // Bazowa część "kolor"
      kolortransparentny(rr, gg, bb, aa),
      kolornazwany(rr, gg, bb, n)
{
    // Konstruktor parametryczny
}
