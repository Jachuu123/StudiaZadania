from decimal import Decimal, getcontext

# Duża precyzja, by ładnie sformatować wyniki
getcontext().prec = 60

# Najmniejszy odstęp między kolejnymi liczbami przy największych double
# 2^(1023 - 52) = 2^971
odstep = Decimal(2) ** 971

# Średnia odległość Ziemia–Słońce (w kilometrach)
AU = Decimal('1.5e8')

stosunek = AU / odstep

print("Najmniejszy odstęp (2^971):", f"{odstep:.5E}", "km")
print("1 AU (Ziemia–Słońce):      ", f"{AU:.5E}", "km")
print("Stosunek (AU / odstęp):    ", f"{stosunek:.5E}")
