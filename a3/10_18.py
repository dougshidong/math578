#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

start = 3
end   = 21
m     = (end-start)/2
w1 = np.empty(m+1)
w2 = np.empty(m+1)
ea = np.empty(m+1)
eb = np.empty(m+1)

a = 1.0
b = 1.7
for i, n in enumerate(range(start,end+1,2)):
    data1 = np.linspace(0, 1, num = n+1)

    x1 = 1/(2.0*n)
    x2 = 0.5
    w1[i] = 1
    w2[i] = 1
    for xi in data1:
        w1[i] *= (x1-xi)
        w2[i] *= (x2-xi)
    ea[i] = abs(np.exp(-a*n))
    eb[i] = abs(np.exp(-b*n))
    print n
print w1
print ea
print w2
print eb
pp = PdfPages('Figures.pdf')
plt.figure()
w1plt = plt.semilogy(range(start,end+1,2), abs(w1), label = '$\omega = 1/(2n)$')
eaplt = plt.semilogy(range(start,end+1,2), ea, label = '$\omega = 1/2$')
plt.legend()

plt.figure()
w2plt = plt.semilogy(range(start,end+1,2), abs(w2))
ebplt = plt.semilogy(range(start,end+1,2), eb)
plt.show()
