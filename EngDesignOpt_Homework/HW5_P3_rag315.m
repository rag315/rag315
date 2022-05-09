%% EDO Homework 5: Problem 3
% by Rebecca Garcia rag315
clc, format short
%% Constants
x1 = 0.5; x2 = 0.75;
A = [1 0 0;-x1 2*(x1+x2) -x2;0 -x2 x2];
b = [0;x1+x2;x2];
z = A\b;
z1 = z(1); z2 = z(2); z3=z(3);
q = 1/(x1*x2) + (z2-z1)/x1 + (z3-z2)/x2;
%% Derivatives
qdx = [-1/(x2*x1^2)-(z2-z1)/(x1^2);-1/(x1*x2^2)-(z3-z2)/(x2^2)];    % Derivative of q wrt x
qdz = [-1/x1;(1/x1)-(1/x2);1/x2]';                                 % Derivative of q wrt z
zdx1 = [0 (-3*x2)/(2*x1+x2)^2 (-3*x2)/(2*x1+x2)^2]'; % Derivative of z wrt x1
zdx2 = [0 (3*x1)/(2*x1+x2)^2 (3*x1)/(2*x1+x2)^2]';   % Derivative of z wrt x2
Adx1 = [0 0 0;-1 2 0;0 0 0];            % Derivative of matrix A wrt x1
Adx2 = [0 0 0;0 2 -1;0 -1 1];           % Derivative of matrix A wrt x2
bdx1 = [0;1;0];                         % Derivative of b wrt x1
bdx2 = [0;1;1];                         % Derivative of b wrt x2
%% Direct Method
QDirect1 = qdx(1) + qdz*zdx1;
QDirect2 = qdx(2) + qdz*zdx2;
%% Adjoint Method
lambda = -inv(A')*qdz';
Qdx1 = qdx(1) + lambda'*(Adx1*z-bdx1);
Qdx2 = qdx(2) + lambda'*(Adx2*z-bdx2);
%% Results
disp('Direct Method: '), disp(QDirect1),disp(QDirect2)
disp('Adjoint Method: '), disp(Qdx1),disp(Qdx2)
if QDirect1 == Qdx1 && QDirect2 == Qdx2
    disp('Sensitivity Analysis Verified')
else 
    disp('Error')
end
