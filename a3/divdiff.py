#!/usr/bin/env python
import numpy as np

data = np.array([[0,1,2,3],[3,5,-1,2]], dtype = np.float64)

n = data.shape[1]
x = 0.05

coeff = data[1,:]

for k in range(n-1):
    coeff[k+1:n] = (coeff[k+1:n] - coeff[k:n-1]) / (data[0,k+1:n] - data[0,0:n-k-1])
                           
print 'Coefficients:'        
print coeff

for ni in range (2,n+1):
    fx = 0
    for k in range(ni):
        fx += np.prod(x - data[0,0:k]) * coeff[k]
    print 'Degree %d Interpolation of %f is %f' % (ni-1,x, fx)
