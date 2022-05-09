%% EDO Assignment 7
% by Rebecca Garcia rag315
clc, format long, clear all
%% Problem 2: Conjugate Gradient
% Global variables
global toll  
% Initial Values
x0 = [5,-5]; b = 100; a = 1;
dx = 1;                         % Initial search direction
toll = .0006; i = 1; nmax = 500; test = 1; % toll & count
%% Solving for F(x) for all x,y values within range
xrange = -5:0.05:5;
yrange = -35:0.05:35;
[X,Y] = meshgrid(xrange,yrange);
nX = length(xrange);
nY = length(yrange);
Z = zeros(nY,nX);
for i = 1:nY
    for j = 1:nX
        Z(i,j) = minimize(X(i,j),Y(i,j),a,b);
    end
end
%% Initializing
% Matrices
x = zeros(nX,2); g = x; J = x; F = zeros(nX,1); Orthogonal = zeros(nX,1); proof = zeros(nX,1);
% Starting Values
x(1,:) = x0;
J(1,:) = Gradient(x0,b,a);
H = Hessian(x(1,:),b);
for i = 1:nX    
 % Calculating Derivatives
    H = Hessian(x(i,:),b);
    J(i,:) = Gradient(x(i,:),b,a);
    % Calculating Conjugate Gradient
    x(i,:) = conjgrad(H,J(i,:),(x(i,:)));
    % Testing for Orthogonal Basis
    proof(i,:) = x(i,:)*H*(x(i,:)');
    if proof(i,:) ~= 0
        Orthogonal(i,:) = 1;    % assumption is true
    elseif proof(i,:) == 0
        Orthogonal(i,:) = 0;    % assumption is false
        disp('i = '),disp(i), disp(' x(i) is not linearly independent')
        break
    end
    
end
%% Calculating Minimization from Conjugate Gradient
for i = 1:length(x(:,1))
    F(i) = minimize(x(i,1),x(i,2),a,b);
end
[minpoint,index] = min(F);
%% Plots
figure (1)
hold on
contourf(X,Y,Z,'HandleVisibility','off');colorbar
plot(x(:,1),x(:,2),'-*');
plot(x(index,1),x(index,2),'^');
title('Problem 2: Conjugate Gradient Method')
xlabel('x1');ylabel('x2'); 
legend('iterations','minimum point','location','best')
xlim([-5 5]);ylim([-35 35])
figure (2)
range = 1:4;
hold on, grid on
plot(range,F(1:4),'-*')
title('Problem 2: Successful Iterations of F(x(i))')
xlabel('iterations');ylabel('F(x(i))');legend('Iterations')
%% Functions
% Conjugate Gradient Function
function [x] = conjgrad(A, J, x0)
global toll
r =  J';         % 1st Residual
p = r;           % 1st Search Direction
normr = r' * r;

    for j = 1:length(J)
        Ap = A * p;
        alpha = normr / (p' * Ap);
        x = x0' + alpha * p;  % new x
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
% Hessian Calculation
function H = Hessian(x,b)
x1 = x(1); x2 = x(2);
H = [12*b*x1^2-2*(2*b*x2-1) -4*b*x1; -4*b*x1 2*b];
end
% Gradient Calculation
function J = Gradient(x,b,a)
x1 = x(1); x2 = x(2);
J = [4*b*x1^3-4*x1, b*x2-.5-2*a];
end
% Rosenbrock Function
function f = minimize(x1,x2,a,b)
    f = b*x2^2 - 2*b*x2*x1^2 + b*x1^4 + a^2 -2*a*x1 +x1^2;
end