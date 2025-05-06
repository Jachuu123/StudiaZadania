#ifndef OBLICZENIA_INSTRUKCJE_HPP
#define OBLICZENIA_INSTRUKCJE_HPP

#include "wyrazenia.hpp"
#include <initializer_list>
#include <vector>
#include <memory>
#include <string>
#include <iostream>

namespace obliczenia {

class instrukcja {
protected:
    instrukcja() = default;  
public:
    virtual void wykonaj() = 0;
    virtual std::string zapis(int w = 0) const = 0;
    virtual ~instrukcja() = default;
    instrukcja(const instrukcja&) = delete;
    instrukcja& operator=(const instrukcja&) = delete;
};
inline std::string indent(int n) { return std::string(n, ' '); }

class deklaracja final : public instrukcja {
    std::string nazwa_;
public:
    explicit deklaracja(std::string n);
    void wykonaj() override {}
    std::string zapis(int w) const override { return indent(w) + "var " + nazwa_ + ";"; }
    ~deklaracja() override;
};

class przypisanie final : public instrukcja {
    zmienna& z_;
    std::unique_ptr<wyrazenie> expr_;
public:
    przypisanie(zmienna& z, std::unique_ptr<wyrazenie> e);
    void wykonaj() override;
    std::string zapis(int w) const override;
};

class czytanie final : public instrukcja {
    zmienna& z_;
public:
    explicit czytanie(zmienna& z) : z_(z) {}
    void wykonaj() override;
    std::string zapis(int w) const override { return indent(w) + "read " + z_.zapis() + ";"; }
};

class pisanie final : public instrukcja {
    std::unique_ptr<wyrazenie> expr_;
public:
    explicit pisanie(std::unique_ptr<wyrazenie> e);
    void wykonaj() override;
    std::string zapis(int w) const override { return indent(w) + "write " + expr_->zapis() + ";"; }
};

class blok final : public instrukcja {
    std::vector<std::unique_ptr<instrukcja>> lista_;
public:
    blok() = default;
    blok(std::initializer_list<instrukcja*> il);
    void dodaj(instrukcja* i) { lista_.emplace_back(i); }
    void wykonaj() override;
    std::string zapis(int w) const override;
};

class if_instr final : public instrukcja {
    std::unique_ptr<wyrazenie> war_;
    std::unique_ptr<instrukcja> t_;
    std::unique_ptr<instrukcja> f_;
public:
    if_instr(std::unique_ptr<wyrazenie>, instrukcja*, instrukcja* = nullptr);
    void wykonaj() override;
    std::string zapis(int w) const override;
};

class while_instr final : public instrukcja {
    std::unique_ptr<wyrazenie> war_;
    std::unique_ptr<instrukcja> body_;
public:
    while_instr(std::unique_ptr<wyrazenie>, instrukcja*);
    void wykonaj() override;
    std::string zapis(int w) const override;
};

class do_while_instr final : public instrukcja {
    std::unique_ptr<instrukcja> body_;
    std::unique_ptr<wyrazenie> war_;
public:
    do_while_instr(instrukcja*, std::unique_ptr<wyrazenie>);
    void wykonaj() override;
    std::string zapis(int w) const override;
};

} // namespace obliczenia
#endif