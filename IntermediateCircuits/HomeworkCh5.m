%% ECE 3424: Homework Chapter 5
% By Rebecca Garcia rag315
%% Problem 5.6
Vtn = 0.4; kn = 10*10^-3;
Vgs = [0.4,0.6,0.8,1.0,1.2];
Vds = 0:.001:.05;
for i = 1:length(Vgs)
    for j = 1:length(Vds)
    iD(j,i) = 5E-3*(Vgs(i)-Vtn)*Vds(j);
    end
end
disp('iD for each VGS:')
disp(iD)
figure(1)
plot(Vds,iD)
title('Problem 5.6')
xlabel('VDS (V)');ylabel('ID (A)')
legend('0.4','0.6','0.8','1.0','1.2')

%% Problem 5.27
Vg = 0:.1:2.8;
Vt = .5; k = 2*10^-3;
Id = zeros(length(Vg),1);
for i = 1:length(Vg)
    if Vg(i) <= Vt
        Id(i) = 0;
    elseif (Vg(i) <= 1.5) && (Vg(i) > Vt)
        Id(i) = k*(Vg(i)-1);
    else
        Id(i) = 0.5*k*(Vg(i)-.5)^2;
    end
end
figure (2)
plot(Vg,Id)
xlabel('Vg (V)');ylabel('Id (A)');title('Problem 5.27')