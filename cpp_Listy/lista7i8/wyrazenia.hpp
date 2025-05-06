#ifndef OBLICZENIA_WYRAZENIA_HPP
#define OBLICZENIA_WYRAZENIA_HPP

#include <string>
#include <memory>
#include <vector>
#include <utility>
#include <stdexcept>
#include <cmath>

namespace obliczenia {

class wyrazenie {
protected:
    wyrazenie() = default; 
public:
    virtual int oblicz() const = 0;
    virtual std::string zapis() const = 0;
    virtual int priorytet() const = 0;
    virtual ~wyrazenie() = default;
    wyrazenie(const wyrazenie&) = delete;
    wyrazenie& operator=(const wyrazenie&) = delete;
    wyrazenie(wyrazenie&&) = delete;
    wyrazenie& operator=(wyrazenie&&) = delete;
};

class liczba final : public wyrazenie {
    int wart_;
public:
    explicit liczba(int w) : wart_(w) {}
    int oblicz() const override { return wart_; }
    std::string zapis() const override { return std::to_string(wart_); }
    int priorytet() const override { return 6; }
};

class stala : public wyrazenie {
protected:
    int wart_{}; std::string nazwa_;
public:
    int oblicz() const override { return wart_; }
    std::string zapis() const override { return nazwa_; }
    int priorytet() const override { return 6; }
};
class zero  final : public stala { public: zero () { wart_=0; nazwa_="0"; } };
class jeden final : public stala { public: jeden() { wart_=1; nazwa_="1"; } };

class zmienna final : public wyrazenie {
    std::string nazwa_;
    static std::vector<std::pair<std::string,int>> baza_;
    static int& ref(const std::string& n);
public:
    explicit zmienna(std::string n) : nazwa_(std::move(n)) {}
    int oblicz() const override { return ref(nazwa_); }
    std::string zapis() const override { return nazwa_; }
    int priorytet() const override { return 6; }
    static void dodaj(const std::string&, int =0);
    static void usun(const std::string&);
    static void ustaw(const std::string&, int);
    static bool istnieje(const std::string&);
};

class operator1 : public wyrazenie {
protected:
    std::unique_ptr<wyrazenie> arg_;
public:
    explicit operator1(std::unique_ptr<wyrazenie> a);
};
class minus_u final : public operator1 {
public:
    using operator1::operator1;
    int oblicz() const override;
    std::string zapis() const override;
    int priorytet() const override { return 5; }
};

class operator2 : public wyrazenie {
protected:
    std::unique_ptr<wyrazenie> left_, right_;
    const int pri_; const std::string sym_; const bool right_assoc_;
    operator2(std::unique_ptr<wyrazenie>, std::unique_ptr<wyrazenie>, int, std::string, bool=false);
public:
    std::string zapis() const override;
    int priorytet() const override { return pri_; }
};
#define BINOP(name,sym,prio,expr) \
class name final : public operator2 { \ 
public: \ 
    name(std::unique_ptr<wyrazenie> l, std::unique_ptr<wyrazenie> r) \ 
        : operator2(std::move(l), std::move(r), prio, sym, (sym=="^")) {} \ 
    int oblicz() const override { return expr; } \ 
};

BINOP(dodawanie,  "+", 3, left_->oblicz()+right_->oblicz())
BINOP(odejmowanie,"-", 3, left_->oblicz()-right_->oblicz())
BINOP(mnozenie,   "*", 4, left_->oblicz()*right_->oblicz())
BINOP(dzielenie,  "/", 4, ([](int a,int b){if(!b)throw std::domain_error("/0");return a/b;})(left_->oblicz(),right_->oblicz()))
BINOP(modulo,     "%", 4, ([](int a,int b){if(!b)throw std::domain_error("%0");return a%b;})(left_->oblicz(),right_->oblicz()))
BINOP(potega,     "^", 5, static_cast<int>(std::pow(left_->oblicz(),right_->oblicz())))
BINOP(mniejsze,   "<", 2, left_->oblicz()< right_->oblicz())
BINOP(mniejsze_rowne,"<=",2,left_->oblicz()<=right_->oblicz())
BINOP(rowne,      "==",2, left_->oblicz()==right_->oblicz())
BINOP(rozne,      "!=",2, left_->oblicz()!=right_->oblicz())

#undef BINOP

} // namespace obliczenia
#endif