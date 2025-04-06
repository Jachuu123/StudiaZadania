#ifndef COLORNAZWANY_H
#define COLORNAZWANY_H

#include "kolor.h"
#include <string>

class kolornazwany : virtual public kolor {
protected:
    std::string nazwa;

public:
    kolornazwany();
    kolornazwany(unsigned short rr, unsigned short gg, unsigned short bb, const std::string &n);

    const std::string& getNazwa() const;
    void setNazwa(const std::string &n);

private:
    bool sprawdzNazwe(const std::string &n);
};

#endif
