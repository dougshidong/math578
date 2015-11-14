function main

iode = @odee2;
tf = 8*pi;
it = 800;
h  = tf/it;
x  = zeros(2,it+1,3);
x(1, 1, :) = 1;
x(2, 1, :) = 0;

[matt1,matx1] = ode45(iode, 0:h:tf, [1 0]);

t = 0;
for i = 1 : it
    t = t + h;
    
    xf = x(:, i, 1);
    ff = iode(t, xf);
    x(:, i+1, 1) = feuler(xf, ff , h);
    
    xb = x(:, i, 2);
    fb = iode(t, xb);
    x(:, i+1, 2) = beuler(xb, fb, h, iode,t);
    
    xc = x(:, i, 3);
    fc = iode(t, xc);
    x(:, i+1, 3) = ckn(xc, fc, h, iode,t);
end
% Plot X-trajectory
tarr = 0:h:tf;
plot(tarr, x(2,:,1),'-o', tarr, x(2,:,2), '-s', tarr, x(2,:,3), '-v', matt1,matx1(:,2),'-*')
legend('Forward Euler', 'Backward Euler','Crank-Nicolson','ode45')
legend('Location','northwest')
end

function [fx] = odee1(t,x)
    fx = [-x(2); x(1)];
end

function [fx] = odee2(t,x)
    fx = [-x(2)/rt(x); x(1)/rt(x)];
end

function [r] = rt(x)
    r = sqrt(x(1)^2 + x(2)^2);
end

function [x2] = feuler(x1, fx, h)
    x2 = x1 + h*fx;
end

function [x2] = beuler(x1, fx, h, od, t)
    normm = 1;
    tol = 1e-10;
    y0 = x1 + h * fx;
    while(normm>tol)
        y1 = x1 + h*od(t,y0);
        normm = norm(y1-y0);
        y0 = y1;
    end
    x2 = y1;
end

function [x2] = ckn(x1, fx, h, od, t)
    normm = 1;
    tol = 1e-10;
    y0 = x1 + h * fx;
    while(normm>tol)
        y1 = x1 + h/2 * (fx + od(t,y0));
        normm = norm(y1-y0);
        y0 = y1;
    end
    x2 = y1;
end
