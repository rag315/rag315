%% EDO Assignment 7
% by Rebecca Garcia rag315
clc, format long, clear all
%% Problem 1: Conjugate Gradient
% Global variables
global toll  
% Initial Values
x0 = [-4, 8];
lo = -10; hi = 10;               % Ranges of x
toll = .0006; i = 1; nmax = 500; % toll & count
%% Solving for F(x) for all x,y values within range
xrange = lo:0.05:hi;
yrange = lo:0.05:hi;
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
% Starting Values
x(1,:) = x0; Orthogonal(1,1) = 1;
A = [2 1;1 4]; F(1,1) = minimize(x(1,1),x(1,2));
for i = 2:nX    
    % Calculating Conjugate Gradient
    x(i,:) = conjgrad(A,(x(i-1,:)));
    % Testing for Orthogonal Basis
    proof(i,:) = x(i,:)*A*(x(i,:)');
    if proof(i,:) ~= 0
        Orthogonal(i,:) = 1;    % assumption is true
    elseif proof(i,:) == 0
        Orthogonal(i,:) = 0;    % assumption is false
        disp('i = '),disp(i), disp(' x(i) is not linearly independent')
        break
    end
    F(i,1) = minimize(x(i,1),x(i,2));   % Calculating Objective Function
    Delta = norm(x(i,:) - x(i-1,:));
    if Delta <= toll
        break
    elseif Delta >= toll
        continue
    end
       
end
%% Plots
figure (1)
hold on
contourf(X,Y,Z,'HandleVisibility','off');colorbar
plot(x(:,1),x(:,2),'y-*');
plot(x(length(x),1),x(length(x),2),'r^');
title('Problem 1: Conjugate Gradient Method')
xlabel('x1');ylabel('x2'); 
legend('iterations','minimum point','location','best')
figure (2)
range = 1:11;
hold on, grid on
plot(range,F(1:11),'-*')
title('Problem 1: Successful Iterations of F(x(i))')
xlabel('iterations');ylabel('F(x(i))');legend('Iterations')
%% Functions
% Conjugate Gradient Function
function [x] = conjgrad(A, x0)
global toll
r = -A*x0';         % 1st Residual
p = r;              % 1st Search Direction
normr = r' * r;

    for j = 1:length(r)
        Ap = A * p;
        alpha = normr / (p' * Ap);
        x = x0' + alpha * p;  % new x
        r = r - alpha * Ap;   % new residual
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
function f = minimize(x1,x2)
    f = x1^2 + 2*x2^2 +x1*x2;
end