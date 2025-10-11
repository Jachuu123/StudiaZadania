import numpy as np

print(" n        y_n (pojedyncza precyzja, float32)         y_n (podwójna precyzja, float64)")


A_single = np.float32(98.0/9.0)
B_single = np.float32(11.0/9.0)

A_double = np.float64(98.0/9.0)
B_double = np.float64(11.0/9.0)


y0_single = np.float32(1.0)
y1_single = np.float32(-1.0/9.0)

y0_double = np.float64(1.0)
y1_double = np.float64(-1.0/9.0)

ciag_single = [y0_single, y1_single]
ciag_double = [y0_double, y1_double]

for _ in range(0, 49):
    nastepny_single = A_single * ciag_single[-1] + B_single * ciag_single[-2]
    nastepny_double = A_double * ciag_double[-1] + B_double * ciag_double[-2]
    ciag_single.append(np.float32(nastepny_single))
    ciag_double.append(np.float64(nastepny_double))

for n in range(2, 51):
    wart_single = ciag_single[n]
    wart_double = ciag_double[n]
    tekst_single = "overflow" if np.isinf(wart_single) else f"{float(wart_single): .18e}"
    print(f"{n:2d}   {tekst_single:>28}   {float(wart_double): .18e}")

#powinno maleć i zmieniać znak co krok a tego nie robi
#yn​=(−(1/9​))^n