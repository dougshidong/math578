#!/usr/bin/env python
import numpy as np

def fun(x): 
    y = np.array([
        3 * x[0]**2 - x[1]**2,
        3 * x[0] * x[1]**2 - x[0]**3 - 1,
    ])
    return y                        

def Jac(x):
    J  = np.empty((2,2))
    J[0][0] = 6 * x[0]
    J[0][1] = -2 * x[1]
    J[1][0] = 3 * x[1]**2 - 3 * x[0]**2
    J[1][1] = 6 * x[0] * x[1]
    return J


maxit = 10
tol = 1e-6
x = np.zeros(shape=(maxit,2), dtype=np.float64)
err = np.zeros(maxit, dtype=np.float64)
x[0] = [1.,1.]
print('x0:\n', x[0] )
for i in range(maxit):

    fx = fun(x[i,:])

    err[i] = np.linalg.norm(fx,2)
    if(err[i] < tol):
        break

    J = Jac(x[i,:])

    J = np.linalg.inv(J)
    
    x[i+1,:] = x[i,:] - np.dot(J, fx)


for ii in range(i+1):
    print '%d & %.6f & %.6f \\\\' % (ii, x[ii,0], err[ii])
    print '   & %.6f &       \\\\' % (x[ii,1])
