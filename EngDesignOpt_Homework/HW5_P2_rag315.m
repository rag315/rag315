%% EDO Homework 5
% by Rebecca Garcia rag315
clc, format long
%% Problem 2
% Initial function
xrange = (3*pi)/4:0.01:(7*pi)/4; % range of x for plotting
f0 = feval(xrange);
[value, index] = min(f0);   % finding min of function
%% Problem 2: Second Order Approximation
alpha_2 = [(3*pi)/4;(5*pi)/4;(7*pi)/4];   % Chosen alphas within the range of x
fx_2 = feval(alpha_2);                      % Resulting function values
col1_2 = [1;1;1];
% Second Order Approximation Matrix
Amatrix2 = [col1_2, alpha_2, alpha_2.^2];      % [A]x=b 
a2o = Amatrix2\fx_2;                         % Solving for a0,a1,a2
% Solving for alpha min using derivative of the approximation = 0
alphamin2o = -a2o(2)/(2*a2o(3));
fapprox2o = feval(alphamin2o);              % Solving for approx. min value of f(x) = sin(x)
%% Problem 2: Third Order Approximation
alpha_3 = [(3*pi)/4;pi;(5*pi)/4;(7*pi)/4]; % chosen alphs within the range of x
fx_3 = feval(alpha_3);
col1_3 = [1;1;1;1];
% Third Order Approximation Matrix
Amatrix3 = [col1_3, alpha_3, alpha_3.^2, alpha_3.^3];   % [A]x=b 
a3o = Amatrix3\fx_3;                                    % Solving for a0,a1,a2,a3
% Solving for alpha min using derivative of the approximation = 0
if 4*(a3o(2))^2 - 12*a3o(2)*a3o(4) >= 0
    disp('Requirements met')
else
    disp('error')
end
alphamin3o(1,1) =( -2*a3o(3)) + sqrt(4*a3o(3)^2 - 12*a3o(2)*a3o(4))/(6*a3o(4));
alphamin3o(2,1) =( -2*a3o(3)) - sqrt(4*a3o(3)^2 - 12*a3o(2)*a3o(4))/(6*a3o(4));
amin3o_tru = min(alphamin3o);
fapprox3o = feval(amin3o_tru);              % Solving for approx. min value of f(x) = sin(x)
%% Calculating Error Differences between the 3rd and 2nd Order Approximations from the True Minimum
error2o = alphamin2o - xrange(index); error3o = amin3o_tru - xrange(index);
ferror2o = fapprox2o - value; ferror3o = fapprox3o - value;
% Percentage error differences in minimum f(x) values
px2o = error2o/xrange(index); px3o = error3o/xrange(index);
pf2o = ferror2o/value; pf3o = ferror3o/value;
disp('Percentage Error Difference from true x point')
disp('2nd Order:'); disp(px2o)
disp('3rd Order:'); disp(px3o)
disp('Percentage Error Difference from true minimum f(x)')
disp('2nd Order:'); disp(pf2o)
disp('3rd Order:'); disp(pf3o)
%% Plots
figure (1)
hold on, grid on
title('f(x) = sin(x)'); xlabel('range of x (rad)'); ylabel('f(x)')
plot(xrange,f0); plot(xrange(index),value,'*')
plot(alphamin2o,fapprox2o,'*'); plot(amin3o_tru,fapprox3o,'*')
legend('f(x)','True Minimum','2nd Order Approximated Minimum','3rd Order Approximated Minimum')
hold off

figure (2)
hold on, grid on
title('error differences in alpha values'); plot(0,0,'*')
plot(error2o,ferror2o,'.','MarkerSize',10);plot(error3o,ferror3o,'.','MarkerSize',10)
ylabel('distance from minimum f(x)'),xlabel('distance from minimum x point')
legend('true accuracy','error in 2nd Order Approximation', 'error in 3rd Order Approximation')


%% Functions
function f = feval(x)
    f = sin(x);
end
