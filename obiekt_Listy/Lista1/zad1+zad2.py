#ZAD 1

def silnia_imp(n):
    wynik = 1
    for i in range(2, n + 1):
        wynik *= i
    return wynik

def silnia(n): #funkcyjnie
    return 1 if n == 0 else n * silnia(n - 1)

def binom(n, k):
    return silnia(n) // (silnia(k) * silnia(n - k))

def pascal_row(n):
    return [binom(n, k) for k in range(n + 1)]

#ZAD 2

def gcd_imperative(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def print_relatively_prime_imperative(n):
    print(f"Liczby względnie pierwsze z {n} (podejście imperatywne):")
    for i in range(1, n + 1):
        if gcd_imperative(n, i) == 1:
            print(i, end=" ")
    print()

def gcd_functional(a, b):
    return a if b == 0 else gcd_functional(b, a % b)

def get_relatively_prime_functional(n):
    return list(filter(lambda i: gcd_functional(n, i) == 1, range(1, n + 1)))

# WYNIKI
n = 5
wiersz = pascal_row(5)
print(f"{n}-ty wiersz trójkąta Pascala: {wiersz}")

n = 30
print("GCD(30, 7) =", gcd_imperative(30, 7))
print_relatively_prime_imperative(n)

n = 30
print("GCD(30, 7) =", gcd_functional(30, 7))
print(f"Liczby względnie pierwsze z {n} (podejście funkcyjne):", get_relatively_prime_functional(n))