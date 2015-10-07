#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

fx = lambda x: np.cos(x) - x

dfdx = lambda x: -np.sin(x) - 1 

maxit = 20
tol = 2e-15
x = np.empty(maxit)
f = np.empty(maxit)
# Starting Point x0
x[0] = np.pi/4

for i in range(maxit):
    f[i] = fx(x[i])
    if(abs(f[i]) < tol):
        break
    x[i+1] = x[i] - f[i] / dfdx(x[i])


for ii in range(i+1):
    print '%d & %.16f & %.16f \\\\' % (ii, x[ii], abs(f[ii]))


import sys
sys.exit()
start=3*-np.pi
end = 3*np.pi
xdat = np.linspace(start,end,500)

cosplt  = plt.plot(xdat, np.cos(xdat), label = 'm(x) = cos(x)')
xplt    = plt.plot(xdat, xdat, label = 'n(x) = x')
xcosplt = plt.plot(xdat, fx(xdat), label = 'g(x) = cos(x) - x')
plt.legend()
xnewtplot = plt.plot(x, fx(x), '-o')

plt.xlim(start,end)
plt.ylim(start, end)
plt.grid()
plt.show()
