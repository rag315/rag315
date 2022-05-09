format longg
B = 7.3*10^(15);
Eg = 1.12;
k = 8.62*10^(-5);
T = [-55, 0, 20, 75, 125];
T = T + 273.15;
for i = 1:length(T)
    ni(i) = B*T(i)^(3/2)*exp((-Eg)/(2*k*T(i)));
end
disp(ni)
fraction = (5*10^22)./ni;
disp(fraction)