%% EDO Homework 6: Problem 1
% by Rebecca Garcia rag315
clc, format short
%% Constants
n = 1e6;   % iteration count
x1 = 0.5; x2 = 0.75;    % x0
hstart = 1e-30; hstop =10^0; % Delta x = h
A = [1 0 0;-x1 2*(x1+x2) -x2;0 -x2 x2];
b = [0;x1+x2;x2];
z = A\b;
z1 = z(1); z2 = z(2); z3=z(3);
q = 1/(x1*x2) + (z2-z1)/x1 + (z3-z2)/x2;
%% Matrix Initialization
FwdElr = zeros(n,2); CntrlDff = zeros(n,2); 
errorFwd = zeros(n,2); errorCntrl = zeros(n,2);
hplot = zeros(n,1); 
%% Derivatives
qdx = [-1/(x2*x1^2)-(z2-z1)/(x1^2), -1/(x1*x2^2)-(z3-z2)/(x2^2)];          % Derivative of q wrt x
qddx = [(2/(x2*x1^3))+((2*(z2-z1))/(x1^3)), (2/(x1*x2^3))+((2*(z3-z2))/(x2^3))]; % 2nd Derivative of q wrt x
qdddx = [(-6/x2*x1^4)-(6*(z2-z1)/(x1^4)), (-6/x1*x2^4)-(6*(z3-z2)/(x2^4))];      % 3rd Derivative of q wrt x
qdz = [-1/x1;(1/x1)-(1/x2);1/x2]';                                         % Derivative of q wrt z
zdx1 = [0 (-3*x2)/(2*x1+x2)^2 (-3*x2)/(2*x1+x2)^2]'; % Derivative of z wrt x1
zdx2 = [0 (3*x1)/(2*x1+x2)^2 (3*x1)/(2*x1+x2)^2]';   % Derivative of z wrt x2
Adx1 = [0 0 0;-1 2 0;0 0 0];            % Derivative of matrix A wrt x1
Adx2 = [0 0 0;0 2 -1;0 -1 1];           % Derivative of matrix A wrt x2
bdx1 = [0;1;0];                         % Derivative of b wrt x1
bdx2 = [0;1;1];                         % Derivative of b wrt x2
%% Direct Method
QExact(1,1) = qdx(1) + qdz*zdx1;
QExact(1,2) = qdx(2) + qdz*zdx2;
%% Loop
% Setting up Iteration
dh = (hstop - hstart)/n;
for i = 1:n
    h = hstart + (i-1)*dh;
    % Forward Euler
    FwdElr(i,:) =  (h*qdx+.5*(h^2)*qddx + ((h^3)/6)*qdddx)/h;
    errorFwd(i,:) = abs((FwdElr(i,:)-QExact)/QExact);           % error
    % Central Difference Scheme
    CntrlDff(i,:) = 0.5*(qdx + ((2*h^2)/6)*qdddx);
    errorCntrl(i,:) = abs((CntrlDff(i,:)-QExact)/QExact);       % error
    hplot(i,1) = h;     % keeping track of h used
end
%% Plots
figure (1)
hold on, grid on
title('Problem 1: Error Plot')
xlabel('log(h)');ylabel('log(e)');
xlim([hstart hstop]);
loglog(hplot,errorFwd(:,1),'--b')
loglog(hplot,errorFwd(:,2),'--r')
loglog(hplot,errorCntrl(:,1),':b')
loglog(hplot,errorCntrl(:,2),':r')
legend('Forward x1','Forward x2','Central x1','Central x2')