%% EDO Assignment 8: Augmented Langrangian Method
% Rebecca Garcia, rag315
% Modified Dr. Bhatia's Newton Solver
%% Initialization of Matrices
xvals = linspace(-4,6,1000);
yvals = linspace(0,8,1000);
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
[M1,c1] = contour(X,Y,g1,[0, 20],'k'); % Constraint 1
[M2,c2] = contour(X,Y,g2,[0, 20],'k'); % Constraint 2
c1.LineWidth = 2; c2.LineWidth = 2;
xlabel('x1');ylabel('x2')
xlim([-4 6]);ylim([0 8]);
%% Newton Solver
toll      = 1.e-6;
max_iter = 1000;
rmax = 500; delta = (rmax-1)/max_iter;
c = 1:delta:rmax;
%% Initial Points
X = [-5; 5; 1; 1]; % x1 x2 s1 s2
L(1,:) = [1 1];  % initial Lagrangians
r = .2*((fval(X))/(gval1(X)+gval2(X)));
if_continue = 1;
k     = 1; % Iteration Count
plot(X(1), X(2),'.g','MarkerSize',15);   % Setting Initial Point as green circle

while if_continue==1
   
    fprintf("x = (%f,%f)\n", X(1), X(2))
    f  = fgrad(X,L(k,:),r);
    df = fhess(X,L(k,:),r);
    dx = - df\f;
    dx = [dx(1);dx(2);dx(5);dx(6)]; % dx(3) & dx(4) see line 55
    X = X + dx;
    % Increase Step Count
    k = k + 1; 
    L(k,:) = L(k-1,:) + 2*r*alpha(X,L(k-1,:),r); % Update Lambdas
    r = c(k)*r;
    
    f  = fgrad(X,L(k,:),r);

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
    x1 = X(1); x2 = X(2); s1 = X(3); s2 = X(4);
    g1 = -x1^2 + x2 -4 + s1^2;
end
% Constraint 2
function g2 = gval2(X)
    x1 = X(1); x2 = X(2); s1 = X(3); s2 = X(4);
    g2 = -(x1-2)^2 + x2 -3 + s2^2;
end
% Augmented Langrangian Method
function A = AugLangrange(X,L,r)
    % Variables x1, x2, slack variables, langrangians 
    x1 = X(1); x2 = X(2); s1 = X(3); s2 = X(4); L1 = L(1); L2 = L(2);
    a1 = max(gval1(X),-L1/(2*r)); % Alpha 1
    a2 = max(gval2(X),-L2/(2*r)); % Alpha 2
    A = fval(X)+L1*a1 + L2*a2 + r*a1^2+r*a2^2;  % Function
end

function a = alpha(X,L,r)
    L1 = L(1); L2 = L(2);
    a1 = max(gval1(X),-L1/(2*r)); a2 = max(gval2(X),-L2/(2*r));
    a = [a1 a2];
end

% Augmented Langrangian Function Gradients
function grad = fgrad(X,L,r)
    % Variables x1, x2, slack variables, langrangians 
    x1 = X(1); x2 = X(2); s1 = X(3); s2 = X(4); L1 = L(1); L2 = L(2);
    a1 = max(gval1(X),-L1/(2*r)); a2 = max(gval2(X),-L2/(2*r)); % alpha
    
    grad = [2*(x1-1)-2*x1*L1-2*L2*(x1-2)+2*r*gval1(X)*(-2*x1)-4*r*gval2(X)*(x1-2);
            2*(x2-5)+L1+L2+2*r*gval1(X)+2*r*gval2(X);
            a1;
            a2;
            2*L1*s1+2*r*a1*2*s1;
            2*L2*s2+2*r*a2*2*s2];
end
function hess = fhess(X,L,r)
    % Variables x1, x2, slack variables, langrangians 
    x1 = X(1); x2 = X(2); s1 = X(3); s2 = X(4); L1 = L(1); L2 = L(2);
    a1 = max(gval1(X),-L1/(2*r)); a2 = max(gval2(X),-L2/(2*r)); % alpha
% Diagonals
xx = 2*x1 -2*L1 -2*L2 -12*r*x1^2+4*r*x2 - 4*r*(-3*x1^2+8*x1-15+x2+s1^2+4*x1);
yy =2*x2+4*r;
L1L1 = -1/(2*r);
L2L2 = -1/(2*r);
s1s1 = 2*L1+4*r*a1;
s2s2 = 2*L2+4*r*a2;
% Rest of Hessian Matrix
xy = -8*r*x1+8*r;          yx = xy;
xL1 =-2*x1;                L1x = xL1;
xL2 =-2*(x1-2);            L2x = xL2;
xs1 = 2*s1*-4*r*x1;        s1x = xs1;
xs2 = 2*s2*(-4*r*x1+8*r);  s2x = xs1;

yL1 = 1;        L1y = yL1;
ys1 = 4*r*s1;        s1y = ys1;
yL2 = 1;        L2y = yL2;
ys2 = 4*r*s2;        s2y = ys2;

L1s1 = max(2*s1,0);    s1L1 = L1s1;
L1L2 = 0;       L2L1 = L1L2;
L1s2 = 0;       s2L1 = L1s2;

s1L2 = 0;       L2s1 = s1L2;
s1s2 = 0;       s2s1 = s1s2;

L2s2 = max(2*s2,0);    s2L2 = L2s2;


    hess = [xx, xy, xL1, xs1, xL2, xs2; ...
            yx, yy, yL1, ys1, yL2, ys2; ...
            L1x, L1y, L1L1, L1s1, L1L2, L1s2; ...
            s1x, s1y, s1L1, s1s1, s1L2, s1s2; ...
            L2x, L2y, L2L1, L2s1, L2L2, L2s2; ...
            s2x, s2y, s2L1, s2s1, s2L2, s2s2];    
end