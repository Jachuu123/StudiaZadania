import matplotlib.pyplot as plt

values = []

# Generowanie wszystkich kombinacji bitów i znaków
for sign in [1, -1]:              # znak liczby
    for exp_sign in [1, -1]:      # znak wykładnika
        for c in [0, 1]:          # wartość wykładnika (0 lub 1)
            for bits in range(16):  # cztery bity mantysy
                mantissa = 0.5  # bo 0.1(2) = 0.5
                # dodajemy kolejne bity mantysy: e_-2, e_-3, e_-4, e_-5
                for i, b in enumerate(f"{bits:04b}", start=2):
                    mantissa += int(b) * 2 ** (-i)
                # obliczamy wartość liczby
                x = sign * mantissa * (2 ** (exp_sign * c))
                values.append(x)

# Sortowanie i usunięcie duplikatów
unique_values = sorted(set(values))
A, B = min(unique_values), max(unique_values)

# Wypisanie podstawowych informacji
print(f"Liczba wszystkich wartości: {len(values)}")
print(f"Liczba unikatowych wartości: {len(unique_values)}")
print(f"Przedział: [{A}, {B}]")

# Rysowanie wykresu rozmieszczenia liczb
plt.figure(figsize=(10, 2.5))
plt.scatter(unique_values, [0]*len(unique_values), s=12, color="blue")
plt.title("Rozkład liczb")
plt.xlabel("Wartość liczby")
plt.yticks([])  # ukrywamy oś Y, bo nas nie interesuje
plt.axvline(A, color="red", linestyle="--", label=f"A = {A}")
plt.axvline(B, color="green", linestyle="--", label=f"B = {B}")
plt.legend()
plt.grid(axis="x", linestyle="--", alpha=0.5)
plt.tight_layout()
plt.show()
