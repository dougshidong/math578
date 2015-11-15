clear;
load('discrim.mat');
U=[];V=[];
for i = 1 : size(Y,1)
    if(Y(i,3)==0)
        U = [U, Y(i,1:2)'];
    else
        V = [V, Y(i,1:2)'];
    end
end

m = size(U,1);
n = size(V,1);

cvx_begin quiet
    variable c(2);
    variable b;
    variable del;
    maximize del
    subject to
        for i = 1 : m
            c' * U - b >= del;
        end
        for i = 1 : n
            c' * V - b <= -del;
        end
cvx_end

c
b
del

close all
hold on
plot(U(1,:),U(2,:),'or')
plot(V(1,:),V(2,:),'ob')
x1 = [0:0.01:1];
y1 = (-c(1) * x1 + b) / c(2);
plot(x1,y1)
set(gcf, 'PaperPosition', [0 0 5 5]);
set(gcf, 'PaperSize', [5 5]);
saveas(gcf, 'ld1', 'pdf');