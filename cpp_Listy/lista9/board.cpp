#include <iostream>
#include <iomanip>
#include <array>
#include <stdexcept>
#include <cctype>
#include <chrono>
#include <string>
#include "exceptions.cpp"

class Board {
    public:
        enum Cell : char { INVALID = ' ', EMPTY = '.', PEG = 'O' };
        static constexpr int N = 7;
    
        Board() {
            for (auto &row : cells) row.fill(INVALID);
            auto set_valid = [&](int r, int c) { cells[r][c] = PEG; };
    
            for (int r = 2; r <= 4; ++r)
                for (int c = 0; c < N; ++c)
                    set_valid(r, c);
            for (int r = 0; r < N; ++r)
                for (int c = 2; c <= 4; ++c)
                    set_valid(r, c);
            cells[3][3] = EMPTY;
        }
    
        bool is_valid_pos(int r, int c) const {
            return r >= 0 && r < N && c >= 0 && c < N && cells[r][c] != INVALID;
        }
    
        bool can_move(int r, int c, char dir) const {
            int dr = 0, dc = 0;
            switch (std::toupper(dir)) {
                case 'L': dc = -1; break;
                case 'R': dc = +1; break;
                case 'U': dr = -1; break;
                case 'D': dr = +1; break;
                default: throw invalid_command("Nieznany kierunek ruchu");
            }
            int r_mid = r + dr, c_mid = c + dc;
            int r_dst = r + 2 * dr, c_dst = c + 2 * dc;
            if (!is_valid_pos(r_dst, c_dst)) return false;
            return cells[r][c] == PEG && cells[r_mid][c_mid] == PEG && cells[r_dst][c_dst] == EMPTY;
        }
    
        void move(int r, int c, char dir) {
            if (!can_move(r, c, dir))
                throw invalid_move("Nieprawidłowy ruch");
    
            int dr = 0, dc = 0;
            switch (std::toupper(dir)) {
                case 'L': dc = -1; break;
                case 'R': dc = +1; break;
                case 'U': dr = -1; break;
                case 'D': dr = +1; break;
            }
            int r_mid = r + dr, c_mid = c + dc;
            int r_dst = r + 2 * dr, c_dst = c + 2 * dc;
    
            cells[r][c] = EMPTY;
            cells[r_mid][c_mid] = EMPTY;
            cells[r_dst][c_dst] = PEG;
        }
    
        int peg_count() const {
            int cnt = 0;
            for (const auto &row : cells)
                for (Cell c : row)
                    if (c == PEG) ++cnt;
            return cnt;
        }
    
        bool has_moves() const {
            static const std::array<char, 4> dirs{ 'L', 'R', 'U', 'D' };
            for (int r = 0; r < N; ++r)
                for (int c = 0; c < N; ++c)
                    if (cells[r][c] == PEG)
                        for (char d : dirs)
                            if (can_move(r, c, d)) return true;
            return false;
        }
    
        void print(std::ostream &os = std::cout) const {
            os << "    A B C D E F G\n";
            for (int r = 0; r < N; ++r) {
                os << ' ' << (r + 1) << "  ";
                for (int c = 0; c < N; ++c) {
                    os << static_cast<char>(cells[r][c]) << ' ';
                }
                os << '\n';
            }
        }
    
        Cell centre() const { return cells[3][3]; }
    
    private:
        std::array<std::array<Cell, N>, N> cells;
    };

struct Command {
    int row;
    int col;
    char dir;
};

Command parse_command(const std::string &input) {
    if (input.empty())
        throw invalid_command("Puste polecenie");

    if (input.size() == 1 && (input[0] == 'Q' || input[0] == 'q'))
        throw quit_game();

    if (input.size() < 3 || input.size() > 4)
        throw invalid_command("Polecenie powinno mieć formę <kol><wiersz><kierunek>");

    char col_char = std::toupper(input[0]);
    char row_char1 = input[1];
    char row_char2 = (input.size() == 4 ? input[2] : '\0');
    char dir_char = std::toupper(input.back());

    if (col_char < 'A' || col_char > 'G')
        throw invalid_command("Kolumna poza zakresem A‑G");

    int col = col_char - 'A';
    int row = 0;
    if (std::isdigit(row_char1)) {
        row = row_char1 - '1';
        if (row_char2) {
            if (!std::isdigit(row_char2))
                throw invalid_command("Niepoprawny numer wiersza");
            row = (row + 1) * 10 + (row_char2 - '1');
        }
    } else {
        throw invalid_command("Oczekiwano cyfry w wierszu");
    }

    if (row < 0 || row >= Board::N)
        throw invalid_command("Wiersz poza zakresem 1‑7");

    if (dir_char != 'L' && dir_char != 'R' && dir_char != 'U' && dir_char != 'D')
        throw invalid_command("Nieznany kierunek – użyj L/R/U/D");

    return { row, col, dir_char };
}