import numpy as np

def kappa_rel_poly(x):
    return abs( x*(2*x-3) / (x*x - 3*x - 70) )

def kappa_rel_sin(x):
    return abs( 11*x * (np.cos(11*x)/np.sin(11*x)) )

punkty_a = [ -7.001, -7.0001, 9.999, 9.9999, 0.0, 1.5 ]
punkty_b = [ -np.pi/11+1e-6, -1e-6, 0.0+1e-6, np.pi/22, np.pi/11-1e-6 ]

print("L3.4(a):")
for x in punkty_a:
    print(f"x={x: .7f}  kappa≈ {kappa_rel_poly(x):.3e}")

print("\nL3.4(b):")
for x in punkty_b:
    print(f"x={x: .7f}  kappa≈ {kappa_rel_sin(x):.3e}")
