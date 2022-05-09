%% EDO Assignment 8: Augmented Langrangian Method
% Rebecca Garcia, rag315
% Modified Dr. Bhatia's Newton Solver
%% Initialization of Matrices
xvals = linspace(-4,6,100);
yvals = linspace(0,8,100);
[X,Y] = meshgrid(xvals,yvals);
Z     = zeros(size(X));
g1    = zeros(size(X));
g2    = zeros(size(X));
m     = size(Z,1);
n     = size(Z,2);
L     = zeros(length(X),2);
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
% [M1,c1] = contour(X,Y,g1,[0, 20],'k'); % Constraint 1
% [M2,c2] = contour(X,Y,g2,[0, 20],'k'); % Constraint 2
% c1.LineWidth = 2; c2.LineWidth = 2;
xlabel('x1');ylabel('x2')
xlim([-4 6]);ylim([0 8]);
%% Newton Solver
toll      = 1.e-6;
max_iter = 1000;
rmax = 500; delta = (rmax-1)/max_iter;
c = 1:delta:rmax;
%% Initial Points
X = [3; 3]; % x1 x2
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
e = eig(fhess(X,L(k,:),r));
fprintf("Eigenvalues of Hess at x: ( %f, %f)\n", e(1), e(2)) 
title('Exterior Penalty Method')
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
    g1 = -log(-1* (-x1^2 + x2 -4));
end
% Constraint 2
function g2 = gval2(X)
    x1 = X(1); x2 = X(2);
    g2 = -log(-1*(-(x1-2)^2 +x2 -3));
end
% Interior Penalty Method
function f = InPenalty(X,r)
    f = fval(X) + r*(gval1(X)+gval2(X));
end

% Interior Penalty Function Gradients
function grad = fgrad(X,r)
    % Variables x1, x2
    x1 = X(1); x2 = X(2);
    grad = [(-2*r*(x1-2))/(x1^2-4*x1+4)^2+(-2*r*x1)/(x1^2-x2+4)^2+2*x1-2;
            (r)/(x1^2-4*x1+4)^2+(r)/(x1^2-x2+4)^2+2*x1-10];
end
function hess = fhess(X,r)
    % Variables x1, x2
    x1 = X(1); x2 = X(2); 
    xx = 2+(2*r*(3*x1^2-12*x1+x2+9))/(x1^2-4*x1-x2+7)^3+(2*r*(3*x1^2+x2-4))/(-x1^2+x2-4)^3;
    yy = 2+(-2*r)/(x1^2-4*x1-x2+7)^3+(-2*r)/(-x1^2+x2-4)^3;
    xy = (-4*r*(x1-2))/(x1^2-4*x1-x2+7)^3+(-4*r*x1)/(-x1^2+x2-4)^3;
    
    hess = [xx xy
            xy yy];
end