import numpy as np

def A_kwadraty(a, b):
    return (a*a) - (b*b)

def A_roznica_suma(a, b):
    return (a-b)*(a+b)

def blad_wzgledny(przybl, dokladny):
    if dokladny == 0:
        return abs(przybl)
    return abs((przybl - dokladny)/dokladny)

przyklady = [
    (1.0, 0.99999999, "a≈b (mała różnica)"),
    (1e8, 1e8-1,      "duże, prawie równe"),
    (1.0, -1.0+1e-8,  "a≈-b (mała suma)"),
    (1e154, 1e154-1,  "ryzyko przepełnienia w kwadratach"),
]

for a,b,opis in przyklady:
    w = A_kwadraty(a,b)
    v = A_roznica_suma(a,b)
    dokl = (a*a - b*b)  # w float64 to „nasza prawda” porównawcza
    ew = blad_wzgledny(w, dokl)
    ev = blad_wzgledny(v, dokl)
    print(f"\n{opis}: a={a}, b={b}")
    print(f"  kwadraty:        A={w:.16e},  błąd={ew:.3e}")
    print(f"  różnica×suma:    A={v:.16e},  błąd={ev:.3e}")
