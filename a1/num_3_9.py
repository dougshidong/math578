#!/usr/bin/env python
import numpy as np

def forSub(A,b):
    '''
    Forward Substitution for Lower Triangular System Ax=b
    Input A, b
    Output x
    '''
    n = len(b)
    x = np.empty(n)
    for i in range (n) :
        num = b[i]
        for j in range (i) :
            num -= A[i][j]*x[j]
        x[i] = num / A[i][i]

    return x

n = 5

# Initialize A
A = np.array(range(1,n**2+1), dtype=float)
A.shape = (n,n)
A = np.tril(A)
print "Matrix A: \n\n", A,"\n\n"

# Initialize b
b = 2*np.array(range(1,n+1), dtype=float)

print "Vector b:\n\n", b,"\n\n"

# Solve using NumPy's solver
x_NP = np.linalg.solve(A,b)

print "NumPy Solution Y:\n\n",x_NP,"\n\n"

x = forSub(A,b)

print "My Solution: \n\n", x
