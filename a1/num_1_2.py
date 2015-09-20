#!/usr/bin/env python
import sys

'''
Input 	y
Output 	x
x = sqrt(y)
'''
#Number of Iterations
n = 10
#Initial Guess
xx = 1
#Root
root = 3 

if len(sys.argv) == 2 :
    y=float(sys.argv[1])
else:
    print "Missing an argument"


x_exact = y**(1.0/root)


print "Exact %d root of %f: %.16f" % (root, y, x_exact)


#Absolute Error of Square Root Algorthm
abserr = lambda x : abs(x-x_exact)

#Relative Error of Square Root Algorithm '''
relerr = lambda x : abserr(x)/x_exact


#Heron Step Square Root
heron = lambda x, y : 0.5*(x+y/x)

# Generalized Heron
gheron = lambda x, y, k : 1/float(k)*( (k-1)*x + y/x**(k-1) )


print "\nIter Estimated X       Abs Err    Rel Err"
print "%-4i %0.15f %0.4e %0.4e" % ( 0, xx, abserr(xx), relerr(xx) )
for i in range(1,n+1) :
    xx=gheron(xx,y,root)
    print "%-4i %0.15f %0.4e %0.4e" % ( i, xx, abserr(xx), relerr(xx) )
