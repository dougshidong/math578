#!/usr/bin/env python
import numpy as np

def rayleigh(A,x):
    return np.dot(x, np.dot(A,x))
    #/ np.dot(x,x)

A = np.array([[-4, 14, 0],
               [-5, 13, 0],
               [-1, 0 , 0]])

tol = 1e-10
n = 1000

useInv = 1
mu = 3.5
Amu = A - np.identity(3) * mu
Ainv = np.linalg.solve(Amu,np.identity(3))

useAtkin = 0
atResi = 1
at = np.empty(n)

x = np.empty((n,3))
x[0] = np.array([1,1,1])

ra  = np.empty(n)
ra[0] = rayleigh(A,x[0])


for i in range(n-1):
    if(useInv == 1):
        y = np.dot(Ainv,x[i])
    else:
        y = np.dot(A, x[i])

    x[i+1] = y / np.linalg.norm(y,2)

    ra[i+1] = rayleigh(A,x[i+1])
    if(useAtkin == 1 and i>1 ):
        an2 = ra[i]
        an1 = ra[i-1]
        an0 = ra[i-2]
        at[i-2] = (an2 * an0 - an1 * an1) / (an2 - 2 * an1 + an0)
        if(i>2):
            atResi = abs(at[i-2] - at[i-3])

    resiValue = abs(ra[i] - ra[i+1])
    resiVector = np.linalg.norm(abs(x[i]-x[i+1]),2)
    if(min(min(resiValue,atResi),resiVector)<tol):
        break
else:
    print 'Did not converge'

print 'Took %d iterations' %i
print 'Eigenvalue'
if(atResi>resiValue):
    print ra[i+1]
else:
    print at[i-3]
print 'Eigenvector:'
print x[i+1]
