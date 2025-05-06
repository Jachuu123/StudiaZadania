#include "wyrazenia.hpp"
#include <algorithm>

namespace obliczenia {

std::vector<std::pair<std::string,int>> zmienna::baza_;
int& zmienna::ref(const std::string& n){
    auto it=std::find_if(baza_.begin(),baza_.end(),[&](auto& p){return p.first==n;});
    if(it==baza_.end()) throw std::logic_error("Nieznana zmienna "+n);
    return it->second;
}
void zmienna::dodaj(const std::string& n,int w){
    if(istnieje(n)) throw std::logic_error("Zmienna istnieje: "+n);
    baza_.push_back({n,w});
}
void zmienna::usun(const std::string& n){
    auto it=std::remove_if(baza_.begin(),baza_.end(),[&](auto&p){return p.first==n;});
    if(it==baza_.end()) throw std::logic_error("Nie ma zmiennej "+n);
    baza_.erase(it,baza_.end());
}
void zmienna::ustaw(const std::string& n,int w){ ref(n)=w; }
bool zmienna::istnieje(const std::string& n){
    return std::any_of(baza_.begin(),baza_.end(),[&](auto&p){return p.first==n;});
}

operator1::operator1(std::unique_ptr<wyrazenie> a){
    if(!a) throw std::invalid_argument("operator1 nullptr");
    arg_=std::move(a);
}
int minus_u::oblicz() const { return -arg_->oblicz(); }
std::string minus_u::zapis() const {
    return "-" + (arg_->priorytet()<priorytet()?"("+arg_->zapis()+")":arg_->zapis());
}

operator2::operator2(std::unique_ptr<wyrazenie> l,std::unique_ptr<wyrazenie> r,int p,std::string s,bool ra)
    : left_(std::move(l)), right_(std::move(r)), pri_(p), sym_(std::move(s)), right_assoc_(ra) {
    if(!left_||!right_) throw std::invalid_argument("operator2 nullptr");
}
std::string operator2::zapis() const {
    auto wrap=[&](const std::unique_ptr<wyrazenie>& w,bool right){
        if(w->priorytet()<pri_ || (w->priorytet()==pri_ && (right_assoc_? !right : right)))
            return "("+w->zapis()+")";
        return w->zapis();
    };
    return wrap(left_,false)+sym_+wrap(right_,true);
}

} // namespace obliczenia
