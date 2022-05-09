%% EDO Homework 6: Problem 2
% by Rebecca Garcia rag315
clc, format short
%% Constants
n = 1e6;   % iteration count
j = sqrt(-1);   % imaginary number
hstart = 1e-30; hstop =10^0; % Range of h
QExact = [-11.3741496598639	-4.35374149659864];    % Results from Problem 1 & Homework 5
%% Matrix Initialization
error = zeros(n,2); qdx = zeros(n,2);
hplot = zeros(n,1); 
% %% Direct Method
% QExact(1,1) = qdx(1) + qdz*zdx1;
% QExact(1,2) = qdx(2) + qdz*zdx2;
%% Loop
% Setting up Iteration
dh = (hstop - hstart)/n;
for i = 1:n    
h = hstart + (i-1)*dh;
% Complex Step Method
x1 = 0.5 + j*h; x2 = 0.75 + j*h;        % x
% Finding q
A = [1 0 0;-x1 2*(x1+x2) -x2;0 -x2 x2];
b = [0;x1+x2;x2];
z = A\b;
z1 = z(1); z2 = z(2); z3=z(3);
q = 1/(x1*x2) + (z2-z1)/x1 + (z3-z2)/x2;
%% Derivatives
qdx = [-1/(x2*x1^2)-(z2-z1)/(x1^2), -1/(x1*x2^2)-(z3-z2)/(x2^2)];          % Derivative of q wrt x
%% Error Calculation
error(i,:) = abs(qdx-QExact/QExact);
hplot(i,:) = h;
end
%% Plots
figure (1)
hold on, grid on
title('Problem 2: Error Plot')
xlabel('log(h)');ylabel('log(e)');
xlim([hstart hstop]);
loglog(hplot,error(:,1),'--b')
loglog(hplot,error(:,2),'--r')
