#ifndef EXCEPTIONS_H
#define EXCEPTIONS_H

#include <stdexcept>
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
    quit_game();
};


#endif // EXCEPTIONS_H