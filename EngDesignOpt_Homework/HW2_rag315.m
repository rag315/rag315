%% EDO Homework 2
% By Rebecca Garcia rag315
clear all; clc
%% Problem 1
A1 = [-2 -2 6;-2 -2 0;6 0 -2];
Sol1 = eig(A1);
disp('Eigen Values for Problem 1: ');
disp(Sol1);
%% Problem 2
A2 =[-8 4;4 -6];
Sol2 = eig(A2);
disp('Eigen Values for Problem 2: ');
disp(Sol2);
%% Problem 4
% Range of values
xrange = (-1.5:.01:1);
lrange = (-1.5:.01:1.5);
[x,l] = meshgrid(xrange, lrange);
% Min Function x1 = x2 by written soln
f4 = x.^2 + x.^2 +l.*(x + x -1);
% Hessian
H4 = [2 0 1;0 2 1;1 1 0];
%% Plot
figure(1)
surf(x, l,f4,'EdgeColor','none');
hold on
[C4,h4] = contour(x,l,f4); 
plot3(.5,.5,.5,'k*') % Minimum Value
xlabel('Design Variable X1');ylabel('Design Variable X2');zlabel('f(x1,x2)');
colorbar
hold off
%% Problem 5
% Range of values
xrange = (-1:.01:1);
lrange = (-1.5:.01:1.5);
[x,l] = meshgrid(xrange, lrange);
% Min Function x1 = x2 by written soln
f5 = x.^2 + x.^2 +l.*(x.^2 + x.^2 -1);
% % Hessian
% H5 = [0 0 2*x;0 0 2*x;2*x 2*x 0];
%% Plot
figure(2)
surf(x, l,f5,'EdgeColor','none');
hold on
[C,h] = contour(x,l,f5); 
xlabel('Design Variable X1');ylabel('Design Variable X2');zlabel('f(x1,x2)');
colorbar
hold off


