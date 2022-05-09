%% Engineering Design Optimization Homework 4
% by Rebecca Garcia rag315 10/5/2020
% Based off of Dr. Manav Bhatia's code 'newton_min_2d.m'
format shortg
%% Problem 1
% Minimizing the Rosenbrock function f(x,y) = 100(y-x^2)^2 + (1-x)^2
% Where x = x1 and y = x2

% Initializing Variables
xvals = linspace(-5,5,10); % Domain
yvals = linspace(-35,35,10); % Domain
[X,Y] = meshgrid(xvals,yvals);
Z     = zeros(size(X));
m     = size(Z,1);
n     = size(Z,2);
%% Initializing Contour Plot
for i=1:m
    for j=1:n
        Z(i,j) = 100*(Y(i,j)-X(i,j)^2)^2 + (1-X(i,j))^2;
    end
end
%% Plot Contour
contourf(X,Y,Z,10)
grid on
hold on
%% Setting Up Newton's Method
tol = 1.e-6;
max = 10;
count = 0;
% Selecting Start Variables
% x = x(1), y = x(2)
x = [0;0];e = 1;
% Solver
while e >= tol

    plot(x(1), x(2),'*');
    fprintf("x = (%f,%f)\n", x(1), x(2));

    f = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2;                       % Function
    df = [-400*(x(2)-x(1)^2) - 2*(1-x(1)); 200*(x(2)-x(1)^2)];  % Residual
    ddf = [-400*(x(2)-3*x(1)^2)+2, -400*x(1); -400*x(1), 200];  % Hessian
    % Calculating New Value
    dx = - ddf\df;
    x = x + dx;
    
    % Tolerance Checks
    e = sqrt(dx'*dx);
    if sqrt(dx'*dx) <= tol
        fprintf("|| dx || <= tol\n")
    end
    if sqrt(df'*df) <= tol
        fprintf("|| f || <= tol\n")
    end    
      
   % Iteration Check     
   count = count + 1;
   if count > max 
       break
   else
       continue
   end
end
fprintf("Final sol: x = (%f,%f)\n", x(1), x(2));
lambda = eig(ddf);
fprintf("Eigenvalues of Hess at x: ( %f, %f)\n", lambda(1), lambda(2)); 

hold off