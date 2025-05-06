#include "instrukcje.hpp"

namespace obliczenia {

deklaracja::deklaracja(std::string n) : nazwa_(std::move(n)) {
    if (zmienna::istnieje(nazwa_)) throw std::logic_error("Deklaracja powtórzona " + nazwa_);
    zmienna::dodaj(nazwa_);
}
deklaracja::~deklaracja() { zmienna::usun(nazwa_); }

przypisanie::przypisanie(zmienna& z, std::unique_ptr<wyrazenie> e) : z_(z) {
    if (!e) throw std::invalid_argument("przypisanie nullptr");
    expr_ = std::move(e);
}
void przypisanie::wykonaj() { zmienna::ustaw(z_.zapis(), expr_->oblicz()); }
std::string przypisanie::zapis(int w) const { return indent(w) + z_.zapis() + " = " + expr_->zapis() + ";"; }

void czytanie::wykonaj() { int x; std::cin >> x; zmienna::ustaw(z_.zapis(), x); }

pisanie::pisanie(std::unique_ptr<wyrazenie> e) {
    if (!e) throw std::invalid_argument("pisanie nullptr");
    expr_ = std::move(e);
}
void pisanie::wykonaj() { std::cout << expr_->oblicz() << std::endl; }

blok::blok(std::initializer_list<instrukcja*> il) { for (auto p : il) lista_.emplace_back(p); }
void blok::wykonaj() { for (auto& i : lista_) i->wykonaj(); }
std::string blok::zapis(int w) const {
    std::string res = indent(w) + "{\n";
    for (auto& i : lista_) res += i->zapis(w + 2) + "\n";
    res += indent(w) + "}"; return res;
}

if_instr::if_instr(std::unique_ptr<wyrazenie> w, instrukcja* t, instrukcja* f) {
    if (!w || !t) throw std::invalid_argument("if nullptr");
    war_ = std::move(w); t_.reset(t); if (f) f_.reset(f);
}
void if_instr::wykonaj() { if (war_->oblicz() != 0) t_->wykonaj(); else if (f_) f_->wykonaj(); }
std::string if_instr::zapis(int w) const {
    std::string res = indent(w) + "if (" + war_->zapis() + ") " + t_->zapis(w);
    if (f_) res += " else " + f_->zapis(w); return res;
}

while_instr::while_instr(std::unique_ptr<wyrazenie> w, instrukcja* b) {
    if (!w || !b) throw std::invalid_argument("while nullptr");
    war_ = std::move(w); body_.reset(b);
}
void while_instr::wykonaj() { while (war_->oblicz() != 0) body_->wykonaj(); }
std::string while_instr::zapis(int w) const { return indent(w) + "while (" + war_->zapis() + ") " + body_->zapis(w); }

do_while_instr::do_while_instr(instrukcja* b, std::unique_ptr<wyrazenie> w) {
    if (!w || !b) throw std::invalid_argument("do-while nullptr");
    body_.reset(b); war_ = std::move(w);
}
void do_while_instr::wykonaj() { do body_->wykonaj(); while (war_->oblicz() != 0); }
std::string do_while_instr::zapis(int w) const { return indent(w) + "do " + body_->zapis(w) + " while (" + war_->zapis() + ");"; }

} // namespace obliczenia
