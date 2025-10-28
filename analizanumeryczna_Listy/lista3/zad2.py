import numpy as np

def pierwiastki_kwadratowe_naiwne(a, b, c):
    D2 = b*b - 4*a*c
    D = np.sqrt(max(D2, 0.0))  # realnie, bez zespolonych
    return ((-b - D)/(2*a), (-b + D)/(2*a))

def pierwiastki_kwadratowe_stabilne(a, b, c):
    s = max(abs(a), abs(b), abs(c))
    if s == 0:
        return (0.0, 0.0)
    A, B, C = a/s, b/s, c/s

    # Δ z tolerancją na zaokrąglenia (gdy jest minimalnie ujemne)
    D2 = B*B - 4*A*C
    tol = 64*np.finfo(float).eps * (B*B + 4*abs(A*C))
    if D2 < 0 and abs(D2) <= tol:
        D2 = 0.0
    if D2 < 0:
        raise ValueError("Δ < 0 (dla tej wersji oczekujemy pierwiastków rzeczywistych)")

    D = np.sqrt(D2)

    znak = np.sign(B) if B != 0 else 1.0
    q = -0.5*(B + znak*D)
    if q == 0.0:                 # dokładnie podwójny pierwiastek
        x = (-B)/(2*A)
        return (x, x)

    x1 = q/A
    x2 = C/q
    return (x1, x2)

def wypisz(a,b,c,opis):
    xn = pierwiastki_kwadratowe_naiwne(a,b,c)
    xs = pierwiastki_kwadratowe_stabilne(a,b,c)
    print(f"\n{opis}:")
    print(f"  szkolnie:  x1={xn[0]:.16e}, x2={xn[1]:.16e}")
    print(f"  stabilnie: x1={xs[0]:.16e}, x2={xs[1]:.16e}")


wypisz(1.0,  1e8,  1.0,           "duże b, małe c")
wypisz(1.0, -1e8,  1.0,           "duże ujemne b")
wypisz(1e-12, 1.0, 1e-12,         "różne skale")
wypisz(1.0,   2.0, 1.0 - 1e-14,   "prawie podwójny pierwiastek")

"""
(A) duże b, małe c
a=1, b=10⁸, c=1

x₂ = (-b + √(b² - 4ac)) / 2
→ (-10⁸ + √(10¹⁶ - 4)) / 2

√(10¹⁶ - 4) ≈ 10⁸ - 2·10⁻⁸
→ licznik = -10⁸ + (10⁸ - 2·10⁻⁸) = -2·10⁻⁸

W pamięci komputera poprawka 2·10⁻⁸ ginie przy 10⁸ → zaokrągla się do 10⁸
→ -10⁸ + 10⁸ = 0 → x₂ ≈ 0 zamiast -10⁻⁸

→ utrata 8 cyfr znaczących

(B) duże ujemne b
a=1, b=-10⁸, c=1

x₁ = (-b - √(b² - 4ac)) / 2
→ (10⁸ - √(10¹⁶ - 4)) / 2
√(10¹⁶ - 4) ≈ 10⁸ - 2·10⁻⁸
→ licznik = 10⁸ - (10⁸ - 2·10⁻⁸) = 2·10⁻⁸

Po zaokrągleniu √(b² - 4ac) ≈ 10⁸ → 10⁸ - 10⁸ = 0 → x₁ ≈ 0
zamiast +10⁻⁸

→ utrata 8 cyfr

(C) różne skale
a=10⁻¹², b=1, c=10⁻¹²

x₁ = (-1 + √(1 - 4·10⁻²⁴)) / (2·10⁻¹²)
√(1 - 4·10⁻²⁴) ≈ 1 - 2·10⁻²⁴
→ licznik = -1 + (1 - 2·10⁻²⁴) = -2·10⁻²⁴

W arytmetyce zmiennoprzecinkowej różnica -1 + 1 = 0
→ x₁ ≈ 0 zamiast -10⁻¹²

→ utrata 12 cyfr

(D) prawie podwójny pierwiastek
a=1, b=2, c=1 - 10⁻¹⁴

Δ = 4·10⁻¹⁴ → √Δ = 2·10⁻⁷
x₁,₂ = (-2 ± 2·10⁻⁷)/2 = -1 ± 10⁻⁷

Tu różnica (-2 + 2·10⁻⁷) jest mała, ale nadal większa niż precyzja maszyny, więc wynik się broni.
Przy jeszcze mniejszym Δ (np. 10⁻¹⁶) pierwiastki zlałyby się w jeden (kasowanie w √Δ).

→ ryzyko zlania pierwiastków przy bardzo małym Δ

"""