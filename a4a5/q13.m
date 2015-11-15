clear
xi = [0,0;
      0,1;
      0,0.2;];
nx = size(xi,1);
col=hsv(3);
pale1 = [229/255;1;204/255];
pale2 = [1;229/255;204/255];
markers = {'s','v','*','h'};
pl = [1;2;inf];
%p = 2;
np = size(pl,1);
%%
close all
figure
hold on
for ip = 1 : np
    p = pl(ip);
    cvx_begin quiet
        variable x(1,2);
        variable y(nx,1);
        minimize (norm(y, p))
        subject to
            for i = 1 : nx
                norm(x - xi(i,:)) <= y(i);
            end
    cvx_end

    plot(xi(:,1),xi(:,2),'oblack', 'MarkerSize', 15)
    xp(ip) = plot(x(1),x(2),'color',col(ip,:), ...
        'marker',markers{mod(ip,numel(markers))}, 'MarkerSize', 15)
    set(xp(ip), {'DisplayName'},{int2str(p)} )
    for i = 1 : nx
        plot([xi(i,1),x(1)],[xi(i,2),x(2)],'--','color',pale1)
    end
    for i = 1 : nx
        plot([x(1),x(1)],[x(2),xi(i,2)],'--','color',pale2)
        plot([x(1),xi(i,1)],[xi(i,2),xi(i,2)],'--','color',pale2)
    end
    axis([-0.1 1.1 -0.1 1.1])
end
axis equal
legend(xp)
set(gcf, 'PaperPosition', [0 0 5 5]);
set(gcf, 'PaperSize', [5 5]);
saveas(gcf, 'fac4', 'pdf');