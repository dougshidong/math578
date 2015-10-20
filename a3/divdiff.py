#!/usr/bin/env python
import numpy as np

#data = np.array([[0,1,2],[3,5,-1]], dtype = np.float64)

data = np.array([[0,1,3,4,7],[1,3,49,129,813]], dtype = np.float64)

def ddiff(x1, x2,
          y1, y2):
    return (y2 - y1) / (x2 - x1)

n = data.shape[1]
x = 0.05

coeff = data[1,:]

for k in range(n-1):
    print k
    print data[0,:]
    print coeff
    for j, i in enumerate(range(k+1,n-1+1)):
        print i,i-1
        coeff[i] = (coeff[i] - coeff[i-1]) / (data[0,i] - data[0,j])
                           
print 'Coefficients:'        
print coeff
