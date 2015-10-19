#!/usr/bin/env python
import numpy as np

n = 11

data1 = np.linspace(0, 1, num = n+1)

x = [1/(2.0*n), 1/2.0]

print 'n = ', n
for case in x:
    w = 1
    for xi in data1:
        w *= (case-xi)
    print 'x = ', case, ' w= ', w
    a = 1.0
    b = 1.7
    print 'e^(an)', abs(np.exp(-a*n))
    print 'e^(bn)', abs(np.exp(-b*n))
