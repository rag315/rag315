%% EDO Assignment 7
% by Rebecca Garcia rag315
clc, format long, clear all
%% Problem 1: DFP Algorithm
% Global variables
global toll  
% Initial Values
x0 = [8,2]; 
dx = 1; a_lo = 0; a_hi = 1;       % For Interval Halving
xmin = -10; xmax = 10;              % Ranges of x1
ymin = -10; ymax = 10;              % Ranges of x2
toll = .0000006; n = 1; nmax = 500; % toll & count
%% Solving for F(x) for all x,y values within range
xrange = xmin:0.05:xmax;
yrange = ymin:0.05:ymax;
[X,Y] = meshgrid(xrange,yrange);
nX = length(xrange);
nY = length(yrange);
Z = zeros(nY,nX);
for i = 1:nY
    for j = 1:nX
        Z(i,j) = minimize(X(i,j),Y(i,j));
    end
end
%% Initializing
% Matrices
x = zeros(nX,2); g = x; J = x; F = zeros(nX,1); l = zeros(1,2);
x(1,:) = x0;
F(1,:) = minimize(x(1,1),x(1,2));
% initial values  
H = [2 1;1 4];  % Hessian
J(1,:) = Gradient(x0);
for i = 2:nX
    % Calculating Derivatives
    B = inv(H); lambda = eig(B);      
    J(i,:) = Gradient(x(i,:));
    % Objective Function Handle
    f = @(x) x(1)^2+2*x(2)^2 +x(1)*x(2);
    % Interval Halving
    [a_min, f_min, history] = inthalve(f, x(i-1,:), dx, a_lo, a_hi, toll, nmax);
    s = -B.*J(i,:);
    ggrad = x(i-1,:)+norm(s) - Gradient(x(i-1,:));
    g = Gradient(ggrad)';
    x(i,:) = x(i-1,:)' + lambda*norm(s);
    
    d(i,:) = x(i,:) - x(i-1,:);
    gamma = 1/(norm(d(i,:)')*norm(s));
    
    z1(i,:) = d(i,:);
    c1(i,:) = 1/((z1(i,:))*g);
    z2(i,:) = B*g;
    c2(i,:) = -1/(z2(i,:)*g);
    
    B = B +c1(i,:).*z1(i,:).*z1(i,:)' +c2(i,:).*z2(i,:).*z2(i,:)';
    
    if abs(norm(d(i,:)-d(i-1,:))) <= toll
        break
    end
    
end
%% Calculating Objective Function
for i = 1:nX
    F(i) = minimize(x(i,1),x(i,2));
end
[point, indices] = min(F);
%% Plots
figure (1)
hold on, grid on
contourf(X,Y,Z,'HandleVisibility','off'); colorbar
plot(x(:,1),x(:,2),'y-*');
plot(x(indices,1),x(indices,2),'r^');
title('Problem 1: DFP Rank 2 Algorithm')
xlabel('x1');ylabel('x2'); 
xlim([xmin xmax]); ylim([ymin ymax]);
legend('iterations','minimum point','location','best')
figure (2)
range = 1:3;
hold on, grid on
plot(range,F(1:3),'-*')
title('Problem 1: Successful Iterations of F(x(i))')
xlabel('iterations');ylabel('F(x(i))');legend('Iterations')
%% Functions
% Gradient Calculation
function J = Gradient(x)
x1 = x(1); x2 = x(2);
J = [2*x1, 4*x2];
end
% Objective Function
function f = minimize(x1,x2)
    f = x1^2 + 2*x2^2 +x1*x2;
end
% Interval Halving Method (using Dr. Bhatia's code)
function [a_min, f_min, history] = inthalve(f, x0, dx, a_lo, a_hi, tol, max_it)

assert(a_lo < a_hi);
assert(isa(f, 'function_handle'));

a_min       = 0.;
f_min       = 0.;
iter        =  0;
n_f         =  0;
if_continue =  1;
sf_vals     = [0., nan; 0., nan; 0., nan];

while if_continue == 1
    
    sf_vals(:, 1)  = a_lo + [0.25;.5;.75] * (a_hi - a_lo);
    
    x1  = x0 + sf_vals(1,1) * dx;
    x2  = x0 + sf_vals(2,1) * dx;
    x3  = x0 + sf_vals(3,1) * dx;

    % evaluate function if not already available
    if (isnan(sf_vals(1, 2)))
        f1            = f(x1);
        sf_vals(1, 2) = f1;
        n_f           = n_f + 1;
    end
    
    % evaluate function if not already available
    if (isnan(sf_vals(2, 2)))
        f2            = f(x2);
        sf_vals(2, 2) = f2;
        n_f           = n_f + 1;
    end

    % evaluate function if not already available
    if (isnan(sf_vals(3, 2)))
        f3            = f(x3);
        sf_vals(3, 2) = f3;
        n_f           = n_f + 1;
    end
    
    
    if ((f2 <= f1) && (f2 <= f3))
                
        % store for history 
        history(iter+1, :) = [sf_vals(2,1), f2];
        
        % lowest value in the middle, so we move limits inwards and reuse 
        % the middle function value
        a_lo  = sf_vals(1,1);
        a_hi  = sf_vals(3,1);

        % these locations will need revaluated
        sf_vals(1, 2) = nan;
        sf_vals(3, 2) = nan;
        
    elseif ((f1 <= f2) && (f1 <= f3))
        
        % store for history 
        history(iter+1, :) = [sf_vals(1,1), f1];

        % lowest function on left side, so we move right limit inwards
        a_hi  = sf_vals(2,1);
        
        % the a=0.25 will be the center of the shortened domain, so 
        % we copy the value to the middle and set others to nan
        % for revaluation
        sf_vals(2, :) = sf_vals(1,:);
        sf_vals(1, 2) = nan;
        sf_vals(3, 2) = nan;
        
    elseif ((f3 <= f2) && (f3 <= f1))

        % store for history 
        history(iter+1, :) = [sf_vals(3,1), f3];

        % lowest function on right side, so we move left limit inwards
        a_lo  = sf_vals(2,1);
        
        % the a=0.75 will be the center of the shortened domain, so 
        % we copy the value to the middle and set others to nan
        % for revaluation
        sf_vals(2, :) = sf_vals(3,:);
        sf_vals(1, 2) = nan;
        sf_vals(3, 2) = nan;
    end
    
    % store minimum value for book-keeping
    iter = iter + 1;
    
    % check for convergence
    if ((a_hi-a_lo) <= tol)
        %fprintf("Stopping due to |da| <= tol\n")
        if_continue = 0;
    elseif ((iter > 1) && (abs(history(iter-1, 2) - history(iter,2)) <= tol))
       % fprintf("Stopping due to |df| <= tol\n")
        if_continue = 0;
    elseif (iter > max_it)
        %fprintf("Stopping due to max_it\n")
        if_continue = 0;
    end
end

fprintf("min a = %f, min f = %f\n", history(iter, 1), history(iter, 2));
fprintf("#f calls = %i\n", n_f);

end