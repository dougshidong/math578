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

pp = PdfPages('f1.pdf')
plt.figure()
w1plt = plt.semilogy(range(start,end+1,2), abs(w1), '-o', label = 'Product')
eaplt = plt.semilogy(range(start,end+1,2), ea, '-s', label = '$e^{-an}$')
plt.title('$\|\omega(1/(2n)\|$')
plt.xlabel('n')
plt.ylabel('$\omega$')
plt.legend()
pp.savefig()
pp.close()

pp = PdfPages('f2.pdf')
plt.figure()
w2plt = plt.semilogy(range(start,end+1,2), abs(w2), '-o', label = 'Product')
ebplt = plt.semilogy(range(start,end+1,2), eb, '-s', label = '$e^{-bn}$')
plt.title('$\|\omega(1/2)\|$')
plt.xlabel('n')
plt.ylabel('$\omega$')
plt.legend()
pp.savefig()
pp.close()
