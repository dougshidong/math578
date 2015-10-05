#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

def fx(x): 
    3*x[0]**2-y[0]**2

dfdx = lambda x: -np.sin(x) - 1 

maxit = 10
tol = 1e-10
x = [-1]

for i in range(maxit):
    x0 = x[i]
    x1 = x0 - fx(x0) / dfdx(x0)
    if(abs(x0-x1) < tol):
        break
    x.append(x1)

xexact = np.pi/4

print x

print xexact

xdat = np.linspace(0,1,50)

cosplt  = plt.plot(xdat, np.cos(xdat), label = 'm(x) = cos(x)')
xplt    = plt.plot(xdat, xdat, label = 'n(x) = x')
xcosplt = plt.plot(xdat, fx(xdat), label = 'g(x) = cos(x) - x')
plt.legend()
xnewtplot = plt.plot(x, fx(x), '-o')

plt.xlim(0.5,1.5)
plt.ylim(-1,1)

plt.show()
