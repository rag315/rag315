%% Discrete-time Signal Convolution
n = 0:20;
for i = 1:21
x1(i) = unit(n(i)); 
v1(i) = 2^n(i)*unit(n(i));
end
y1 = conv(x1,v1);

for i = 1:21
x2(i) = (0.5)^n(i)*unit(n(i)); 
v2(i) = 2^n(i)*unit(n(i));
end
y2 = conv(x2,v2);



figure(1);
subplot(3,1,1);
stem(0:20, x1,'filled'); 
%axis([0 20 0 1]); 
xlabel('n'); ylabel('x(n)')
subplot(3,1,2);
stem(0:20, v1,'filled'); %axis([0 20 0 1e6]); 
xlabel('n'); ylabel('v(n)')
subplot(3,1,3);
stem(n,y1(1:length(n)),'filled'); 
xlabel('n'); ylabel('y(n)=x(n)*v(n)')

figure(2);
subplot(3,1,1);
stem(0:20, x2,'filled'); 
%axis([0 20 0 1]); 
xlabel('n'); ylabel('x(n)')
subplot(3,1,2);
stem(0:20, v2,'filled'); %axis([0 20 0 1e6]); 
xlabel('n'); ylabel('v(n)')
subplot(3,1,3);
stem(n,y2(1:length(n)),'filled'); 
xlabel('n'); ylabel('y(n)=x(n)*v(n)')

function [out] = unit(t)
if t >= 0 
    out = 1;
else
    out = 0;
end
end