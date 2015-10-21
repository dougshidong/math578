#!/usr/bin/env python
import numpy as np

def fx(x):
    return np.log(x)*x

n = 3 
data = np.linspace(1.0,2.0, num = n)

inte = 0
for i in range(n-1):
    inte += (data[i+1]-data[i]) / 2 * (fx(data[i+1]) + fx(data[i]) )
print inte

