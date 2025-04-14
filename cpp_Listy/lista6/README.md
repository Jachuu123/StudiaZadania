g++ -c -fPIC complex.cpp -o complex.o
g++ -shared -o libcomplex.so complex.o


g++ -c -fPIC polynomial.cpp -o polynomial.o
g++ -shared -o libpolynomial.so polynomial.o

g++ main.cpp -L. -lcomplex -lpolynomial -o test_program

export LD_LIBRARY_PATH=.
./test_program

ldd test_program
