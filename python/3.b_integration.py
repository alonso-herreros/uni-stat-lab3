from sympy import *

x, lam = symbols('x λ')

print(integrate(x * ((1 - exp(-lam * x))**3).diff(x), (x, 0, oo)).subs(lam, 35))
