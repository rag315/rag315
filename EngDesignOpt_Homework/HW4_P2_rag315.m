%% Problem 2
% By Rebecca Garcia 10/5/2020
% Based off of Dr. Manav Bhatia's code 'newton_ineq_min_2d.m'
%% Problem Statement
% Minimizing the function f(x,y) = (x-1)^2 + (y-5)^2
% S.T.  -x^2 + y - 4 <= 0       (g1)
%       -(x-2)^2 + y -3 <= 0    (g2)
% Where x = x1 and y = x2
% --------------------------------------------
% Adding Slack & Lagrange Multipliers
% f(x,y,l1,s1,l2,s2) = (x-1)^2 + (y-5)^2 + l1*(-x^2+y-4+s1^2) + l2*(-(x-2)^2+y-3+s2^2)
% S.T.  -x^2 + y - 4 + s1^2 == 0        (g1)
%       -(x-2)^2 + y -3 + s2^2 == 0     (g2)
% ------------------------------------------
% x1, x2 are the original variables
% x3 is the Lagrange multiplier for g1
% x4 is the slack variable for g1
% x5 is the Lagrange multiplier for g2
% x6 is the slack variable for g2
clc, clear all, format shortg
%% Initializing Variables
xvals = linspace(-4,6,10); % domain
yvals = linspace(0,8,10);  % domain
[X,Y] = meshgrid(xvals,yvals);
Z     = zeros(size(X));
g1    = zeros(size(X));
g2    = zeros(size(X));
m     = size(Z,1);
n     = size(Z,2);

%% Contour of Original Functions 
for i=1:m
    for j=1:n
        Z(i,j)  = (X(i,j) - 1)^2 + (Y(i,j) - 5)^2;
        g1(i,j) = -(X(i,j))^2 + Y(i,j) - 4;
        g2(i,j) = -(X(i,j) - 3)^2 + Y(i,j) - 3;
    end
end
contourf(X,Y,g1,[0, 20])
grid on
hold on
[C,h] = contour(X, Y, Z,  [.1, .8, 2, 5, 10],'k');
clabel(C,h,'LabelSpacing',250,'Color','k','FontWeight','bold')
xlabel('x')
ylabel('y')

%% Newton's Method
tol      = 1.e-6;
max_iter = 10;
% Selecting Start Variables
x1 = [-4; 0; 1; 1; 1; 1 ];
% x1, x2 are the original variables
% x3 is the Lagrange multiplier for g1
% x4 is the slack variable for g1
% x5 is the Lagrange multiplier for g2
% x6 is the slack variable for g2

if_continue = 1;
counter     = 0;
plot(x1(1), x1(2),'*');

while if_continue==1
   
    fprintf("x = (%f,%f), L1=%f, s1=%f, L2=%f, s2=%f\n", x1(1), x1(2), x1(3), x1(4), x1(5), x1(6));
    f  = fgrad(x1);
    df = fhess(x1);
    dx = - df\f;
    x1 = x1 + dx;
    counter = counter + 1;
    
    f  = fgrad(x1);

    plot(x1(1), x1(2),'*');
    hold on
    
    if sqrt(dx'*dx) <= tol
        fprintf("|| dx || <= tol\n")
        if_continue = 0;
    end
    
    if sqrt(f'*f) <= tol
        fprintf("|| f || <= tol\n")
        if_continue = 0;
    end
    
    if counter > max_iter 
        fprintf("max iters reached. Quitting.\n")
        if_continue = 0;
    end
end
fprintf("x = (%f,%f), L1=%f, s1=%f, L2=%f, s2=%f\n", x1(1), x1(2), x1(3), x1(4), x1(5), x1(6));
fprintf("f=%f\n", fval(x1));
e = eig(fhess(x1));
fprintf("Eigenvalues of Hess at x: ( %f, %f, %f, %f, %f, %f)\n", e(1), e(2), e(3), e(4), e(5), e(6)) ;

hold off


function g = g1val(x)
% Inequality g1
%g1(x) = -x^2 + y - 4 + s1^2 == 0 
    g = -x(1)^2 + x(2) - 4 + x(4)^2;
end
function g = g2val(x)
% Inequality g2
%g2(x) =  -(x-2)^2 + y -3 + s2^2 == 0
    g = -(x(1)-2)^2 + x(2) -3 + x(6)^2;
end
function f = fval(x)
% Objective Function
    f = (x(1) - 1)^2 + (x(2) - 5)^2 + x(3) * g1val(x) + x(5) * g2val(x);
end
function grad = fgrad(x)
% Jacobian Function
    grad = [2*(x(1)-1)-2*x(3)*x(1)-2*x(5)*x(1)+4*x(5);  ...
            2*(x(2)-5)+x(3)+x(5);  ...
            -x(1)^2+x(2)-4+x(4)^2; ...
            -(x(1)-2)^2+x(2)-3+x(6)^2;...
            2*x(3)*x(4);...
            2*x(5)*x(6)];
end
function hess = fhess(X)
% Hessian Function
x=X(1); 
y=X(2); 
L1=X(3); 
s1=X(4); 
L2=X(5); 
s2=X(6);
% Diagonals
xx = 2*x-2*L1-2*s1;
yy =2*y+L1;
L1L1 = 0;
L2L2 = 0;
s1s1 = 2*L1;
s2s2 =2*L2;
% Rest of Hessian Matrix
xy = 0;         yx = xy;
xL1 =-2*x;      L1x = xL1;
xL2 =-2*x+4;    L2x = xL2;
xs1 = 0;        s1x = xs1;
xs2 = 0;        s2x = xs1;

yL1 = 1;        L1y = yL1;
ys1 = 0;        s1y = ys1;
yL2 = 1;        L2y = yL2;
ys2 = 0;        s2y = ys2;

L1s1 = 2*s1;    s1L1 = L1s1;
L1L2 = 0;       L2L1 = L1L2;
L1s2 = 0;       s2L1 = L1s2;

s1L2 = 0;       L2s1 = s1L2;
s1s2 = 0;       s2s1 = s1s2;

L2s2 = 2*s2;    s2L2 = L2s2;


    hess = [xx, xy, xL1, xs1, xL2, xs2; ...
            yx, yy, yL1, ys1, yL2, ys2; ...
            L1x, L1y, L1L1, L1s1, L1L2, L1s2; ...
            s1x, s1y, s1L1, s1s1, s1L2, s1s2; ...
            L2x, L2y, L2L1, L2s1, L2L2, L2s2; ...
            s2x, s2y, s2L1, s2s1, s2L2, s2s2];
end
