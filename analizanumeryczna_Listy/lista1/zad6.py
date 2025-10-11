import numpy as np

def przyblizenie_pi(liczba_wyrazow: int) -> float:
    suma = np.float64(0)
    for k in range(liczba_wyrazow + 1):
        znak = (-1.0) ** k
        wyraz = znak / np.float64(2 * k + 1)
        suma += wyraz
    return float(4.0 * suma)


def eksperyment():
    liczby_wyrazow = [1_000, 10_000, 100_000, 1_000_000, 1_999_999]

    print("    N          π (float64)            błąd względem math.pi")
    print("-" * 65)

    for N in liczby_wyrazow:
        pi_przybl = przyblizenie_pi(N)
        blad = abs(pi_przybl - np.pi)
        print(f"{N:8d}     {pi_przybl: .10f}          {blad:.3e}")


eksperyment()


"""
Komentarz:
-----------
Szereg Leibniza: π = 4 * Σ (-1)^k / (2k+1)

Z kryterium Leibniza wynika, że błąd po N wyrazach jest mniejszy niż
4 / (2N + 3). Aby uzyskać dokładność 10⁻⁶, trzeba zsumować około 2 miliony wyrazów.

Eksperyment to potwierdza:
- Dla małych N wynik oscyluje wokół 3.14, z dużym błędem.
- Dla N ≈ 2 000 000 błąd spada do ~10⁻⁶, zgodnie z teorią.

Wniosek:
Szereg Leibniza zbiega bardzo wolno - potrzeba milionów wyrazów, by
uzyskać kilka miejsc po przecinku dokładności.
"""