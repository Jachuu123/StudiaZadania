#include <iostream>
#include <iomanip>
#include <array>
#include <stdexcept>
#include <cctype>
#include <chrono>
#include <string>

class exception_samotnika : public std::logic_error {
    public:
        using std::logic_error::logic_error;
    };
    
    class invalid_command : public exception_samotnika {
    public:
        using exception_samotnika::exception_samotnika;
    };
    
    class invalid_move : public exception_samotnika {
    public:
        using exception_samotnika::exception_samotnika;
    };
    
    class quit_game : public exception_samotnika {
    public:
        quit_game() : exception_samotnika("Użytkownik zakończył grę") {}
    };