%% Q10 Plots
close all;
% Plot X-trajectory
figure
tarr = 0:h:tf;
plot(tarr, x(1,:,1),'-o', ...
     tarr, x(1,:,2), '-s', ...
     tarr, x(1,:,3), '-v', ...
     matt1,matx1(:,1),'-*')
legend('Forward Euler', 'Backward Euler','Crank-Nicolson','ode45', 'Location','northwest')
title('ODE1 X-Trajectory')
xlabel('t')
ylabel('x(t)')
set(gcf, 'PaperPosition', [0 0 7 4]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [7 4]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'XTraj2', 'pdf') %Save figure
% Plot Y-trajectory
figure
plot(tarr, x(2,:,1),'-o', ...
     tarr, x(2,:,2), '-s', ...
     tarr, x(2,:,3), '-v', ...
     matt1,matx1(:,2),'-*')
legend('Forward Euler', 'Backward Euler','Crank-Nicolson','ode45', 'Location','northwest')
title('ODE1 Y-Trajectory')
xlabel('t')
ylabel('y(t)')
set(gcf, 'PaperPosition', [0 0 7 4]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [7 4]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'YTraj2', 'pdf') %Save figure
% Plot R
figure
ran=1:it/2;
plot(tarr(ran), (x(1,ran,1).^2 + x(2,ran,1).^2).^5, '-o', ...
     tarr(ran), (x(1,ran,2).^2 + x(2,ran,2).^2).^5, '-s', ...
     tarr(ran), (x(1,ran,3).^2 + x(2,ran,3).^2).^5, '-v', ...
     matt1(ran),(matx1(ran,1).^2 + matx1(ran,2).^2).^0.5,'-*');
legend('Forward Euler', 'Backward Euler','Crank-Nicolson','ode45', 'Location','northwest')
title('ODE1 Distance Amplitude')
xlabel('t')
ylabel('r(t)')
set(gcf, 'PaperPosition', [0 0 7 4]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [7 4]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'R2', 'pdf') %Save figure