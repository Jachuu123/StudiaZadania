#include <iostream>
#include <iomanip>
#include <array>
#include <stdexcept>
#include <cctype>
#include <chrono>
#include <string>
#include "board.cpp"

int main() {
    using clock = std::chrono::steady_clock;
    auto t0 = clock::now();

    Board board;
    std::cout << "Gra Samotnik – wpisz ruch (np. F4L) lub Q aby się poddać.\n\n";

    while (true) {
        try {
            board.print();
            std::cout << "Ruch: ";
            std::string line; std::getline(std::cin, line);
            Command cmd = parse_command(line);
            board.move(cmd.row, cmd.col, cmd.dir);

            if (board.peg_count() == 1) {
                std::cout << "\nGratulacje! Został tylko jeden pionek – wygrałeś!\n";
                break;
            }
            if (!board.has_moves()) {
                std::cout << "\nBrak możliwych ruchów – przegrałeś.\n";
                break;
            }
        }
        catch (const quit_game &) {
            std::cout << "\nGra przerwana przez użytkownika.\n";
            break;
        }
        catch (const exception_samotnika &e) {
            std::cout << "Błąd: " << e.what() << "\n";
        }
    }

    board.print();
    int pegs = board.peg_count();
    std::cout << "Pozostało pionków: " << pegs << "\n";
    auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(clock::now() - t0);
    std::cout << "Czas gry: " << elapsed.count() << " s\n";
    if (pegs == 1 && board.centre() == Board::PEG)
        std::cout << "Osiągnięty ideał – ostatni pionek w centrum!" << std::endl;
    return 0;
}