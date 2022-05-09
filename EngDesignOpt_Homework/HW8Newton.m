%% EDO Assignment 8: Exterior Penalty Method
% Rebecca Garcia, rag315
% Modified Dr. Bhatia's 2d Newton Solver
%% Initialization of Matrices
xvals = linspace(-4,6,1000);
yvals = linspace(0,8,1000);
[X,Y] = meshgrid(xvals,yvals);
Z     = zeros(size(X));
g1    = zeros(size(X));
g2    = zeros(size(X));
m     = size(Z,1);
n     = size(Z,2);
%% Storing Numerical Solution for Plotting
for i=1:m
    for j=1:n
        Z(i,j) =  fval([X(i,j), Y(i,j), 0, 0]);
        g1(i,j) = gval1([X(i,j), Y(i,j), 0, 0]);
        g2(i,j) = gval2([X(i,j), Y(i,j), 0, 0]);
    end
end

%% Plots
figure(1)
hold on, grid on
contourf(X,Y,Z); colorbar % Numerical Solution to Objective Function
[M1,c1] = contour(X,Y,g1,[0, 20],'k'); % Constraint 1
[M2,c2] = contour(X,Y,g2,[0, 20],'k'); % Constraint 2
c1.LineWidth = 2; c2.LineWidth = 2;
xlabel('x1');ylabel('x2')
xlim([-4 6]);ylim([0 8]);
%% Newton Solver
toll      = 1.e-6;
max_iter = 1000;
cstop = 20; delta = (cstop-1)/max_iter;
c = 1:delta:10;
%% Initial Points
X = [3; 3];
r = .2*((fval(X))/(gval1(X)+gval2(X)));
if_continue = 1;
k     = 1; % Iteration Count
plot(X(1), X(2),'.g','MarkerSize',15);   % Setting Initial Point as green circle

while if_continue==1
   
    fprintf("x = (%f,%f)\n", X(1), X(2))
    f  = fgrad(X,r);
    df = fhess(X,r);
    dx = - df\f;
    X = X + dx;
    % Increase Step Count
    k = k + 1;  
    r = c(k)*r;
    
    f  = fgrad(X,r);

    plot(X(1), X(2),'*','MarkerSize',8);
    hold on
    % Toll Check
    if sqrt(dx'*dx) <= toll
        fprintf("|| dx || <= tol\n")
        if_continue = 0;
    end
    
    if sqrt(f'*f) <= toll
        fprintf("|| f || <= tol\n")
        if_continue = 0;
    end
    
    if k > max_iter 
        fprintf("max iters reached. Quitting.\n")
        if_continue = 0;
    end
    
end
plot(X(1), X(2),'.r','MarkerSize',15);   % Setting final point to a red marker
fprintf("Final Iteration Count: = (%f)\n", k)
fprintf("Final sol: x = (%f,%f)\n", X(1), X(2))
fprintf("f=%f\n", fval(X))
e = eig(fhess(X,r));
fprintf("Eigenvalues of Hess at x: ( %f, %f)\n", e(1), e(2)) 
title('Exterior Penalty Method: (-4, 0)')
hold off

%% Functions
% Objective
function f = fval(X)
    x1 = X(1); x2 = X(2);
    f = (x1-2)^2 + (x2-5)^2;
end
% Constraint 1
function g1 = gval1(X)
    x1 = X(1); x2 = X(2);
    g1 = -x1^2 + x2 -4;
end
% Constraint 2
function g2 = gval2(X)
    x1 = X(1); x2 = X(2);
    g2 = -(x1-2)^2 + x2 -3;
end
% Exterior Penalty Method
function f = ExPenalty(X,r)
    f = fval(X)+r*(gval1(X))^2 +r*(gval2(X))^2;
end
% Exterior Penalty Function Gradients
function grad = fgrad(X,r)
    x1 = X(1); x2 = X(2);
    grad = [2*(x1-1)+4*x1*r*(-x1^2+x2-4)+4*(x1-2)*(-(x1-2)^2+x2-3);
            2*(x2-5)+2*r*(-x1^2+x2-4)+2*r*(-(x1-2)^2+x2-3)];
end
function hess = fhess(X,r)
    x1 = X(1); x2 = X(2);
    hess = [r*(4*(x2-4)-12*x1^2)-12*x1^2+48*x1+4*x2-58, 4*r*x1+4*x1-8;
            4*r*x1+4*x1-8, 4*r+2];
end