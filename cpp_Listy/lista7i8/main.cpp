// ============================================================================
//  main.cpp
// ============================================================================
#include "instrukcje.hpp"
#include <iostream>
using namespace obliczenia;

int main() {
    try {
        /* ───── test wyrażenia 2^(x/3-1) ───── */
        zmienna::dodaj("x", 5);
        auto expr = std::make_unique<potega>(
            std::make_unique<liczba>(2),
            std::make_unique<odejmowanie>(
                std::make_unique<dzielenie>(
                    std::make_unique<zmienna>("x"),
                    std::make_unique<liczba>(3)),
                std::make_unique<liczba>(1)));
        std::cout << "Wyrażenie: " << expr->zapis()
                  << " = " << expr->oblicz() << "\n\n";

        /* ───── program sprawdzający pierwszość liczby n ───── */
        deklaracja var_n("n");
        zmienna    n("n");
        czytanie   read_n(n);

        pisanie write0(std::make_unique<liczba>(0));
        pisanie write1(std::make_unique<liczba>(1));

        /* blok „else” głównego if-a */
        auto else_blk = std::make_unique<blok>();

        /* var p; p = 2; */
        else_blk->dodaj(new deklaracja("p"));
        zmienna p("p");
        else_blk->dodaj(new przypisanie(
            p, std::make_unique<liczba>(2)));

        /* var wyn; */
        else_blk->dodaj(new deklaracja("wyn"));
        zmienna wyn("wyn");

        /* while (p*p <= n) … */
        auto cond_loop = std::make_unique<mniejsze_rowne>(
            std::make_unique<mnozenie>(
                std::make_unique<zmienna>("p"),
                std::make_unique<zmienna>("p")),
            std::make_unique<zmienna>("n"));

        auto loop_body = std::make_unique<blok>();

        /* if (n % p == 0) { wyn = p; p = n; } */
        auto if_factor = std::make_unique<rowne>(
            std::make_unique<modulo>(
                std::make_unique<zmienna>("n"),
                std::make_unique<zmienna>("p")),
            std::make_unique<liczba>(0));

        auto inside = std::make_unique<blok>();
        inside->dodaj(new przypisanie(
            wyn, std::make_unique<zmienna>("p")));
        inside->dodaj(new przypisanie(
            p,   std::make_unique<zmienna>("n")));

        loop_body->dodaj(new if_instr(std::move(if_factor), inside.release()));

        /* p = p + 1; */
        loop_body->dodaj(new przypisanie(
            p, std::make_unique<dodawanie>(
                   std::make_unique<zmienna>("p"),
                   std::make_unique<liczba>(1))));

        else_blk->dodaj(new while_instr(std::move(cond_loop), loop_body.release()));

        /* if (wyn > 0) write 0; else write 1; */
        else_blk->dodaj(new if_instr(
            std::make_unique<mniejsze>(
                std::make_unique<liczba>(0),
                std::make_unique<zmienna>("wyn")),
            &write0, &write1));

        /* if (n < 2) write 0; else { … } */
        auto top_if = new if_instr(
            std::make_unique<mniejsze>(
                std::make_unique<zmienna>("n"),
                std::make_unique<liczba>(2)),
            &write0, else_blk.release());

        /* cały program w jednym bloku */
        blok program{ &var_n, &read_n, top_if };

        std::cout << "Program:\n" << program.zapis(0)

                  << "\n\nPodaj n: ";
        program.wykonaj();
    }
    catch (const std::exception& e) {
        std::cerr << "Błąd: " << e.what() << '\n';
        return 1;
    }
}
