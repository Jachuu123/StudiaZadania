import numpy as np

def f(x):
    return (1.0 - np.cos(5.0 * x)) / (x * x)

print(" i  x=10^{-i}         f_single           f_double")

for i in range(11, 21):
    x = 10.0**(-i)

    # single (float32)
    x_s = np.float32(x)
    f_single = np.float32((np.float32(1.0) - np.cos(np.float32(5.0) * x_s)) / (x_s * x_s))

    # double (float64)
    x_d = np.float64(x)
    f_double = np.float64(f(x_d))

    print(f"{i:2d}  1e-{i:<2d}   {float(f_single): .12g}   {float(f_double): .12g}")
