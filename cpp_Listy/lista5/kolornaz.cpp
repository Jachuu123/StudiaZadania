#include "kolornaz.h"
#include <stdexcept>
#include <cctype> // std::isalpha, std::islower

kolornazwany::kolornazwany()
    : kolor(), nazwa("")
{
}

kolornazwany::kolornazwany(unsigned short rr, unsigned short gg, unsigned short bb, const std::string &n)
    : kolor(rr, gg, bb)
{
    if(!sprawdzNazwe(n)) {
        throw std::runtime_error("Nazwa musi być pusta lub zawierać tylko małe litery a-z.");
    }
    nazwa = n;
}

const std::string& kolornazwany::getNazwa() const {
    return nazwa;
}

void kolornazwany::setNazwa(const std::string &n) {
    if(!sprawdzNazwe(n)) {
        throw std::runtime_error("Nazwa musi być pusta lub zawierać tylko małe litery a-z.");
    }
    nazwa = n;
}

bool kolornazwany::sprawdzNazwe(const std::string &n) {
    for(char c : n) {
        if(!std::isalpha(static_cast<unsigned char>(c)) || !std::islower(static_cast<unsigned char>(c))) {
            return false;
        }
    }
    return true;
}
