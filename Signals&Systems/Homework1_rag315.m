%% Signals and Systems Homework 1
% By Rebecca Garcia, rag315
%% Problem 1
T = -1:.1:5; % seconds 

for i = 1:length(T)  
    t = T(i);
x.a(i,1) = 10*exp(-3*t)*unit(t);
x.b(i,1) = 3*exp(-t)*cos(2*t)*unit(t);
x.c(i,1) = exp(-t)*unit(t) + exp(-t)*(exp(2*t-4)-1)*unit(t-2)-exp(t-4)*unit(t-4);
x.d(i,1) = cos(t)*(unit(t+pi/2)-2*unit(t-pi))+cos(t)*unit(t-(3*pi)/2);

end
%% Problem 3
N = -5:1:15;
for i = 1:length(N)
    n = N(i);
   x3.a(i,1) = (.8^n)*unit(n);
   x3.b(i,1) = (.8^-n)*unit(n);
   x3.c(i,1) = (.9^n)*(sin((pi*n)/4)+cos((pi*n)/3));
   x3.d(i,1) = (2^n)*unit(n);
end


figure(1)
plot(T,x.a)
title('Problem 1: Continous-time function a')
xlabel('Time (s)');ylabel('x(t)')
figure(2)
plot(T,x.b)
title('Problem 1: Continous-time function b')
xlabel('Time (s)');ylabel('x(t)')
figure(3)
plot(T,x.c)
title('Problem 1: Continous-time function c')
xlabel('Time (s)');ylabel('x(t)')
figure(4)
plot(T,x.d)
title('Problem 1: Continous-time function d')
xlabel('Time (s)');ylabel('x(t)')



figure(5)
stem(N,x3.a)
title('Problem 3: Discrete-time function a')
xlabel('n');ylabel('x(n)')
figure(6)
stem(N,x3.b)
title('Problem 3: Discrete-time function b')
xlabel('n');ylabel('x(n)')
figure(7)
stem(N,x3.c)
title('Problem 3: Discrete-time function c')
xlabel('n');ylabel('x(n)')
figure(8)
stem(N,x3.d)
title('Problem 3: Discrete-time function d')
xlabel('n');ylabel('x(n)')



function [out] = unit(t)
if t >= 0 
    out = 1;
else
    out = 0;
end
end