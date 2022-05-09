%% Signals and Systems HW #4
%%Problem 2 Rectangular Pulse
% Amplitude and Phase
K = [-5:1:5];
for i = 1:length(K)
ck(i,1)=(-1/(K(i)*pi))*sin(K(i)*(pi/2));
ck1(i,1)=(1/j*K(i)*pi)*(6*exp((-4*pi*j*K(i)))-4);
end
cphase = zeros(length(K),1)';





% plot truncated complex Fourier series
% for rectangular pulse train with T = 2

t = -3:6/1000:3;
N = input('Number of harmonics = ');
c0 = 0.5;
w0 = pi/2;
xN = c0*ones(1, length(t)); % dc component
for k = 1:N
    c_k = (-1/(2*j*k*pi))*exp(-pi);
    xN = xN + c_k*exp(j*k*w0*t) ;
end
figure(2)
plot(t,xN); grid on;
title('Rectangle Pulse Signal')
xlabel('t');ylabel('x(t)')


t = -3:6/1000:3;
N1 = input('Number of harmonics = ');
c0 = -3/2;
w0 = pi/2;
xN = c0*ones(1, length(t)); % dc component
for k = 1:N1
    c_k = (1/(j*k*pi))*(6*exp(-4*pi*j*k)-4);
    xN = xN + c_k*exp(j*k*w0*t) ;
end
figure(4)
plot(t,xN); grid on;
title('Triangle Pulse Signal')
xlabel('t');ylabel('x(t)')







% figure(1)
% hold on
% subplot(2,1,1)
% stem(K,ck);
% title('Amplitude Spectra of Rectangular Pulse')
% subplot(2,1,2)
% stem(K,cphase)
% title('Phase Spectra of Rectangular Pulse')
% hold off
% %% Problem 3 Amplitude and Phase Spectra
% figure(3)
% hold on
% subplot(2,1,1)
% stem(K,ck1);
% title('Amplitude Spectra of Triangular Pulse')
% subplot(2,1,2)
% stem(K,cphase)
% title('Phase Spectra of Triangular Pulse')
% hold off