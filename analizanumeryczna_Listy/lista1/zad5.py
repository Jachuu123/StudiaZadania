import numpy as np
import math

A = 2025.0

I0_double = math.log((A + 1.0) / A)           # ln(2026/2025)
I0_single = np.float32(np.log(np.float32((A + 1.0) / A)))

def policz_In_do_20(I0, dtype):
    In = [dtype(I0)]
    wyniki = []
    for n in range(1, 21):
        wart = dtype(1.0 / n) - dtype(2025.0) * In[-1]
        In.append(dtype(wart))     # In[n]
        if n >= 1:
            wyniki.append(dtype(wart))
    return wyniki  # [I1, I2, ..., I20]

lista_double = policz_In_do_20(I0_double, np.float64)
lista_single = policz_In_do_20(I0_single, np.float32)

print(" n          I_n (double, float64)              I_n (single, float32)")
for n in range(1, 21):
    d = float(lista_double[n-1])
    s = float(lista_single[n-1])
    print(f"{n:2d}   {d: .18e}      {s: .18e}")

print("\nNieparzyste: I1, I3, ..., I19 (double):")
for n in range(1, 21, 2):
    print(f"I{n:2d} = {float(lista_double[n-1]): .18e}")

print("\nParzyste: I2, I4, ..., I20 (double):")
for n in range(2, 21, 2):
    print(f"I{n:2d} = {float(lista_double[n-1]): .18e}")

#2025^2≈4,1⋅10^6

#x=(x+2025)-2025  //*x^(n-1)

#x^n=(x ^ (n-1))*(x + 2025) - (2025 * x^(n-1)) // * (1 / (x+2025))

#x^n \ (x+2025) = x^(n-1) - (2025 * (x^(n-1) \ (x+2025)) // całkujemy obustronie ∫0->1 i otrzymujemy że nasze oryginalne równanie to
# ∫ (x^n \ (x+2025)) =  ∫ x^(n-1) - 2025 * ∫((x^(n-1) \ (x+2025))

# prawa strona odejmowania to z definicji - 2025 * I_n-1 a lewa to całka [(x^n)\n​]0->1 = 1/n
# więc mamy I_n = 1/n - 2025 * I_n-1

#I_0 = ∫(1/(x+2025)) = [ln(x+2025)]0->1 = ln(2026/2025)