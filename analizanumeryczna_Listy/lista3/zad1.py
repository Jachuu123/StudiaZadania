import math

def f_a_zwykla(x: float) -> float:
    return x**3 + math.sqrt(x**6 + 2025.0)

def f_a_poprawiona(x: float) -> float:
    # stabilizacja (rationalizacja) dla x < 0
    if x >= 0.0:
        return f_a_zwykla(x)
    return 2025.0 / (math.sqrt(x**6 + 2025.0) - x**3)

def arcctg(x: float) -> float:
    # konwencja z treści: arcctg(x) = pi/2 - arctan(x)
    return math.pi/2 - math.atan(x)

def f_b_z_tresci(x: float) -> float:
    # dokładnie: x^{-3} * (pi/2 - x - arcctg(x))
    if x == 0.0:
        return float('nan')  # nieokreślone wprost
    return (math.pi/2 - x - arcctg(x)) / (x**3)

def f_b_poprawiona(x: float, tau: float = 1e-3) -> float:
    # stabilna dla małych |x| (szereg Taylora):
    # (atan x - x)/x^3 = -(1/3) + x^2/5 - x^4/7 + ...
    # a ponieważ (pi/2 - x - arcctg x) = atan x - x, dostajemy ten sam wielomian
    if abs(x) <= tau:
        x2 = x * x
        return -1.0/3.0 + x2/5.0 - (x2 * x2)/7.0
    return f_b_z_tresci(x)

# ===============================
# Formatowanie tabel
# ===============================

W = 19

def fmt(v: float) -> str:
    if isinstance(v, float) and (math.isnan(v) or math.isinf(v)):
        return f"{v}".rjust(W)
    return f"{v:.12e}".rjust(W)

def line(ncol: int) -> str:
    return "+" + "+".join(["-" * W for _ in range(ncol)]) + "+"

def head(*cols) -> str:
    return "|" + "|".join(c.center(W) for c in cols) + "|"

def row(*cols) -> str:
    return "|" + "|".join(fmt(c) for c in cols) + "|"

# ===============================
# Drukowanie tabel
# ===============================

def tabela_a(xs):
    print("\n=== CZĘŚĆ (a):  x^3 + sqrt(x^6 + 2025) ===")
    print(line(3))
    print(head("x", "zwykla_a", "poprawiona_a"))
    print(line(3))
    for x in xs:
        print(row(x, f_a_zwykla(x), f_a_poprawiona(x)))
    print(line(3))

def tabela_b(xs):
    print("\n=== CZĘŚĆ (b):  x^{-3} * (pi/2 - x - arcctg(x)) ===")
    print(line(3))
    print(head("x", "z_tresci_b", "poprawiona_b"))
    print(line(3))
    for x in xs:
        print(row(x, f_b_z_tresci(x), f_b_poprawiona(x)))
    print(line(3))

# ===============================
# Główny program
# ===============================

xs_a = [-1e6, -1e4, -1e2, -10.0, -1.0, 0.0, 1.0, 10.0, 1e2, 1e4, 1e6]
xs_b = [-1e-6, -1e-5, -1e-4, -1e-3, -1e-2, 0.0, 1e-2, 1e-1, 1.0, 10.0]

tabela_a(xs_a)
tabela_b(xs_b)
