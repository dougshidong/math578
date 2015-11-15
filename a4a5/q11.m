% Input data
n=10;
m=40;
randn('state',0);
% Generate 40 ponts ui, vi
u = linspace(-1,1,m);
v = 1./(5+40*u.^2) + 0.1*u.^3 + 0.01*randn(1,m);
vexact = 1./(5+40*u.^2) + 0.1*u.^3;
A = vander(u');
A = A(:,m-n+[1:n]);

plist = [1; 1.5; 2; 2.5; 4; 8; inf];

pn = size(plist,1);

xp = zeros(n,pn);
vp = zeros(m,pn);
% Loop over p's
for pi = 1 : pn
    p = plist(pi);
    cvx_begin quiet
        variable x1(n)
        minimize (norm(A*x1 - v', p))
    cvx_end
    xp(:,pi) = x1;
    vp(:,pi) = xp(1,pi);
    for i = 2:n
      vp(:,pi) = vp(:,pi).*u' + x1(i);
    end
    [maxn(pi), maxl] = max(vp(:,pi) - v');
    %maxn(pi) = abs(maxn(pi)/v(maxl));
end
%%
% Plot 
plot(plist, maxn,'-o');
xlabel('p');
ylabel('$\|\hat{v}-v\|_\infty$','Interpreter','latex');
title('Maximum Error of Polynomial vs P-Norm');
set(gcf, 'PaperPosition', [0 0 5 5]);
set(gcf, 'PaperSize', [5 5]);
saveas(gcf, 'q11plot', 'pdf');