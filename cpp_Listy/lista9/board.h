#ifndef BOARD_H
#define BOARD_H

#include <array>
#include <iostream>
#include "exceptions.h"

class Board {
public:
    enum Cell : char { INVALID = ' ', EMPTY = '.', PEG = 'O' };
    static constexpr int N = 7;

    Board();
    bool is_valid_pos(int r, int c) const;
    bool can_move(int r, int c, char dir) const;
    void move(int r, int c, char dir);
    int peg_count() const;
    bool has_moves() const;
    void print(std::ostream &os = std::cout) const;
    Cell centre() const;

private:
    std::array<std::array<Cell, N>, N> cells;
};

#endif // BOARD_H

