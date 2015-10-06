#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

def fun(x,y): 
    y[0] = 3 * x[0]**2 - x[1]**2
    y[1] = 3 * x[0] * x[1]**2 - x[0]**3 - 1
    return

def Jac(x,J):
    J[0][0] = 6 * x[0]
    J[0][1] = -2 * x[1]
    J[1][0] = 3 * x[1]**2 - 3 * x[0]**2
    J[1][1] = 6 * x[0] * x[1]
    return


maxit = 10
tol = 1e-5
x = np.zeros(shape=(maxit,2))
x[0] = [1.,1.]
x0 = np.empty(2)
x1 = np.empty(2)
fx = np.empty(2)
J  = np.empty((2,2))
for i in range(maxit):
    print('Iteration: ',i+1)
    x0 = x[i]
    print('x0:\n', x0 )
    fun(x0,fx)
    print('fx:\n', fx)
    Jac(x0,J)
    print('J:\n', J )
    J = np.linalg.inv(J)
    print('Jinv:\n', J )
    x1 = x0 - np.dot(J, fx)
    print('x1:\n', x1 )
    if(np.linalg.norm(x0-x1) < tol):
        break
    x[i+1] = x1

print(x)
