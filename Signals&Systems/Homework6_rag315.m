%% Signals and Systems HW #5
%%Problem 1
% Amplitude and Phase
O = -pi:.1:pi;
for i = 1:length(O)
    o = O(i);
    Ampa(i,1) = 1/(sqrt(1-1.6*cos(o)+.64));
    Pha(i,1) = -atan((.8*sin(o))/(1-.8*cos(o)));

    Ampb(i,1) = 1/(sqrt(1+1.6*cos(o)+.64));
    Phb(i,1) = atan((.8*sin(o))/(1-.8*cos(o)));
end

figure(1)

subplot(2,1,1);
title('Problem 1 a')
plot(O,Ampa)
xlabel('Omega');ylabel('|X(Omega)|')
subplot(2,1,2)'
plot(O,Pha)
xlabel('Omega');ylabel('<X(Omega)')

figure(2)
subplot(2,1,1);
title('Problem 1 b')
plot(O,Ampb)
xlabel('Omega');ylabel('|X(Omega)|')
subplot(2,1,2)'
plot(O,Phb)
xlabel('Omega');ylabel('<X(Omega)')


x = [2,0,1,4];
y = [3,1,1,3];

xo = fft(x,7);
yo = fft(y,7);

z = ifft(xo.*yo);
zz = conv(x,y);

disp('ifft')
disp(z)

disp('conv')
disp(zz)
