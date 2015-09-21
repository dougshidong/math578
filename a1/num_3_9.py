#!/usr/bin/env python
import numpy as np
'''
Forward Substitution for Lower Triangular System LY=F
Input L, F
Output 	Y
'''

n = 3

# Initialize L
L = np.array(range(1,n**2+1))
L.shape = (n,n)
L = np.tril(L)
print "Matrix L :\n", L

# Initialize F
F = 2*np.array(range(1,n+1))
print F

# Solve using NumPy's solver
Y = np.linalg.solve(L,F)

print Y

for i in range (n) :
    for j in range (n-n+1) :
        Y[i]=F[i]/L[i][j]

print Y       
