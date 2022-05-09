%% Engineering Design Optimization Midterm 1
% By Rebecca Garcia rag315 10/2/2020
%% Problem 1
% Identify the minima of the following functions in the specified domains
%% Part A
n_a = 100;         % Number of iterations
delta = pi/n_a;    % Iterate by 
xa = 0:delta:pi;   % Creating domain vector
fa = sin(xa);     % function
% Finding Minimum Values
[point,index] = min(fa(:));
row_a = xa(index); col_a = point;
% Plot
figure (1)
grid on, hold on
plot(xa,fa);
plot(row_a,col_a,'c.','MarkerSize',20)
plot(pi,col_a,'c.','MarkerSize',20)
title('problem 1, part a'); xlabel('x in rad'); ylabel('f(x)');
%% Part B
% Assuming that the domain of 0 to 100 is in radians
xb_out = zeros(100,1); fb_out = zeros(100,1);
for i = 1:101
    xb = i;
    fb = xb*sin(xb);
    xb_out(i,1) = xb;
    fb_out(i,1) = fb;
end
% Finding Minimum Values
[point,index] = min(fb_out(:));
row_b = xb_out(index); col_b = point;
% Plot
figure (2)
grid on, hold on
plot(row_b,col_b,'c.','MarkerSize',20)
plot(xb_out,fb_out)
title('problem 1, part b'); xlabel('x in rad'); ylabel('f(x)');
%% Part C
xc_out = zeros(500,1); fc_out = zeros(500,1);
for i = 1:501
    xc = i;
    fc = xc*sin(xc);
    xc_out(i,1) = xc;
    fc_out(i,1) = fc;
end
% Plot
figure (3)
grid on, hold on
plot(xc_out,fc_out)
title('problem 1, part c'); xlabel('x in rad'); ylabel('f(x)');