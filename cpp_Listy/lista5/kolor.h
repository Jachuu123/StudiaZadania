#ifndef KOLOR_H
#define KOLOR_H

class kolor {
protected:
    unsigned short r;
    unsigned short g;
    unsigned short b;

public:
    // Konstruktory
    kolor();
    kolor(unsigned short rr, unsigned short gg, unsigned short bb);

    // Gettery
    unsigned short getR() const;
    unsigned short getG() const;
    unsigned short getB() const;

    // Settery
    void setR(unsigned short rr);
    void setG(unsigned short gg);
    void setB(unsigned short bb);


    void lighten(unsigned short value = 10);
    void darken(unsigned short value = 10);

    static kolor average(const kolor &k1, const kolor &k2);
};

#endif
