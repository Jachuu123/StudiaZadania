#ifndef PIKSEL_H
#define PIKSEL_H

class piksel {
protected:
    int x;
    int y;

    // Statyczne pola -> rozdzielczość ekranu
    static const int SCREEN_WIDTH = 1280;
    static const int SCREEN_HEIGHT = 720;

public:
    piksel();
    piksel(int xx, int yy);

    int getX() const;
    int getY() const;
    void setX(int xx);
    void setY(int yy);

    // Odległości od brzegów
    int distanceLeft() const;
    int distanceRight() const;
    int distanceTop() const;
    int distanceBottom() const;

    // Metody statyczne do odległości między pikselami
    static double distance(const piksel* p1, const piksel* p2);
    static double distance(const piksel &p1, const piksel &p2);
};

#endif
