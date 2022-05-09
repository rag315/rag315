%% EDO Assignment 7
% by Rebecca Garcia rag315
clc, format long
%% Problem 1: Conjugate Gradient Method
% Global variables
global toll  
% Initial Values
A = [2 1;1 4]; b = [0;0]; x0 = [-4,-8]; 
min = -10; max = 10;            % Ranges of x
dx = 1;                         % Initial search direction
toll = .006; n = 1; nmax = 500; % toll & count
%% Proceedure
[x1,x2] = IntervalHalf(x0(1),x0(2),dx,min,max,n,nmax);
 m = length(x1); conjx = zeros(m,2);
for i = 1:m
    search = [x1(i);x2(i)];
    x = conjgrad(A,b,search);
    conjx(i,1) = x(1); conjx(i,2) = x(2);
end
%% Solving for F(x) for all x,y values within range
xrange = min:0.05:max;
yrange = min:0.05:max;
[X,Y] = meshgrid(xrange,yrange);
nX = length(xrange);
nY = length(yrange);
Z = zeros(nY,nX);
for i = 1:nY
    for j = 1:nX
        Z(i,j) = minimize(X(i,j),Y(i,j));
    end
end
%% Figures
figure (1)
hold on, grid on
title('Problem 1: Objective Function with Minimum Point')
contourf(X,Y,Z,'HandleVisibility','off')
plot(conjx(m,1),conjx(m,2),'*')
plot(x1,x2,'-^')
colorbar()
legend('Minimum Point','Convergence History')
xlabel('x1');ylabel('x2')

figure (2)
hold on, grid on
title('Search Direction Iterations')
plot(x1,x2,'-*','HandleVisibility','off')
xlabel('x1');ylabel('x2')
xlim([-10 10]); ylim([-10 10])

figure (3)
hold on, grid on
title('Resulting Conjugate Gradiants from Search Direction Iterations')
plot(conjx(:,1),conjx(:,2),'-^','HandleVisibility','off')
xlabel('x1');ylabel('x2')
%% Functions
% Interval Halving Method
function [a, b] = IntervalHalf(x1,x2,dx,min,max,n,nmax)
global toll
while (max-min) >= toll
    % Tracking successful iterations
    count.min(n,1) = min; count.max(n,1) = max; 
    % Proceedure
    lambda.a = min + 0.25*(max-min);
    lambda.b = min + 0.50*(max-min);
    lambda.c = min + 0.75*(max-min);
    
    x.a(n,1) = x1 + lambda.a*dx;
    x.a(n,2) = x2 + lambda.a*dx;
    x.b(n,1) = x1 + lambda.b*dx;
    x.b(n,2) = x2 + lambda.b*dx;
    x.c(n,1) = x1 + lambda.c*dx;
    x.c(n,2) = x2 + lambda.c*dx;
    
    f.a(n,:) = minimize(x.a(n,1),x.a(n,2));
    f.b(n,:) = minimize(x.b(n,1),x.b(n,2));
    f.c(n,:) = minimize(x.c(n,1),x.c(n,2));

    % Seaching for new lambda Values
    disp('Iteration: ');disp(n)
    
    if f.a(n) < f.b(n) && f.a(n) < f.c(n)
        max = lambda.a;
    disp('new max = lambda.a');disp(lambda.a')
    disp('old min: ');disp(min)
    
    elseif f.b(n) < f.a(n) && f.b(n) < f.c(n)
        min = lambda.a; max = lambda.c;
    disp('new max = lambda.c');disp(lambda.c') 
    disp('new min = lambda.a');disp(lambda.a')
    
    elseif f.c(n) < f.b(n) && f.c(n) < f.a(n)
        min = lambda.b;
    disp('new min = lambda.b');disp(lambda.b')    
    disp('old max');disp(max)
    end
    % Iteration Check
    n = n +1;
    if n > nmax 
        disp('max iterations reached')
        break
    end   
end
a = count.min; b = count.max;
end
% Conjugate Gradient Function
function x = conjgrad(A, b, x)
global toll
r = b - A * x;   % 1st Residual
p = r;           % 1st Search Direction
normr = r' * r;
    for i = 1:length(b)
        Ap = A * p;
        alpha = normr / (p' * Ap);
        x = x + alpha * p;  % new x
        r = r - alpha * Ap; % new residual
        newnorm = r' * r;
        % Toll Check
        if sqrt(newnorm) < toll
              break
        else
        p = r + (newnorm / normr) * p;
        normr = newnorm;
        end
        
    end
end
% Objective Function
function f = minimize(a,b)
    f = a^2+2*b^2+a*b;
end