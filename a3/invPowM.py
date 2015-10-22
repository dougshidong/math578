#!/usr/bin/env python
import numpy as np

def rayleigh(A,x):
    return np.dot(x, np.dot(A,x))

def powerIt(A,x):
    y = np.dot(A,x)
    return y / np.linalg.norm(y,2)

# Matrix A
A = np.array([[-4, 14, 0],
               [-5, 13, 0],
               [-1, 0 , 0]])

# Convergence Information
tol = 1e-14
n = 50
eValResi  = 1
eVecResi  = 1
atkinResi = 1

# Inverse Power Method Options
useInv = 0 # Toggle on or off
if(useInv == 1):
    mu = 3.5
    B = A - np.identity(3) * mu
    Binv = np.linalg.solve(B,np.identity(3))

# Atkin Divided Difference to Speed Up Eigenvalue Convergence
useAtkin = 0 # Toggle on or off
if(useAtkin == 1):
    at = np.empty(n)
    xn0= np.empty(3)
    xn1= np.empty(3)
    xn2= np.empty(3)

# Data Initialization
# Eigenvectors
x = np.empty((n,3))
x[0] = np.array([1,1,1])
# Eigenvalues
ra  = np.empty(n)
ra[0] = rayleigh(A,x[0])

if(useAtkin ==1):
    for i in range(n-1):
        xn0 = x[i]

        xn1 = powerIt(A,xn0)
        
        del1x = xn1-xn0
        if(max(abs(del1x)) < tol):
            break
        
        xn2 = powerIt(A,xn1)
        del2x = xn0-2*xn1+xn2
        
        x[i+1] = xn0 - del1x**2/del2x

    else:
        print 'Did not converge'
else:
    for i in range(n-1):
        if(useInv == 1):
            x[i+1] = powerIt(Binv,x[i])
        else:
            x[i+1] = powerIt(A,x[i])

        ra[i+1] = rayleigh(A,x[i+1])

        eValResi = abs(ra[i] - ra[i+1])
        if(eValResi < tol):
            break
    else:
        print 'Did not converge'


print 'Took %d iterations' %i
print 'Eigenvalue'
if(useAtkin!=1):
    print ra[i+1]
else:
    print rayleigh(A,x[i])
print 'Eigenvector:'
print x[i-1]
