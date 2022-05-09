%% Eng Design Opt Hw 1:
%% Problem 1.2
% Created by Rebecca Garcia
%% Constants
E = 30e6; % Youngs Modulus
rho = .283; % Density
h = 100;    % height (in)
Aref = 1; %Ref cross sectional area
P = 10000; % Applied Load
sig0 = 20000; % Max Allowable Stress
%% Design Variable Max & Min
min1 = .1; min2 = .1;
max1 = 2.0; max2 = 2.5;
n = 100; delta1 = max1/n; delta2 = max2/n;
%% Initializing Indexes
x1 = min1:delta1:max1; x1 = x1';x1(96,1) = x1(96,1) - .005; x1(97,1) = max1;
x2 = min2:delta2:max2; x2 = x2'; m = length(x2);
%% Initializing Arrays
f1_out = zeros(m);f2_out = zeros(m);f3_out = zeros(m); 
sig1_out = zeros(m); sig2_out = zeros(m);
%% Objective Functions
for i = 1:m
   x = x1(i); 
   for j = 1:m
        y = x2(j);
        
        sig1 = (P*(x+1)*sqrt(1+x^2))/(2*sqrt(2)*x*y*Aref);
        sig2 = (P*(x-1)*sqrt(1+x^2))/(2*sqrt(2)*x*y*Aref);
        
        if sig1 >= sig0 || sig2 >= sig0
            sig1_out(i,j) = NaN; sig2_out(i,j) = NaN;
            f1_out(i,j) = NaN;
            f2_out(i,j) = NaN;
            f3_out(i,j) = NaN;
            
        elseif sig1 <= sig0 && sig2 <= sig0
            f1 = 2*rho*h*y*sqrt((x^2)*Aref+1);
            f2 = (P*h*((1+x^2)^1.5)*sqrt(1+x^4))/(2*sqrt(2)*E*(x^2)*y*Aref);
            f3 = f1 + f2;
            sig1_out(i,j) = sig1; sig2_out(i,j) = sig2;
            f1_out(i,j) = f1; f2_out(i,j) = f2; f3_out(i,j) = f3;           
        end
                
   end
end
%% Finding Minimum Values
% f1
[~,index] = min(f1_out(:));
[pnt1,pnt2] = ind2sub(size(f1_out),index);
row_f1 = x1(pnt2); col_f1 = x2(pnt1);
% f2
[~,index] = min(f2_out(:));
[pnt1,pnt2] = ind2sub(size(f2_out),index);
row_f2 = x1(pnt2); col_f2 = x2(pnt1);
% f3
[~,index] = min(f3_out(:));
[pnt1,pnt2] = ind2sub(size(f3_out),index);
row_f3 = x1(pnt2); col_f3 = x2(pnt1);
%% Plots
figure(1)
hold on
grid on
title('Part a: f1 as the objetive');
contourf(x1,x2,f1_out)
plot(row_f1,col_f1,'c.','MarkerSize',20)
xlabel('Design Variable X1');ylabel('Design Variable X2');
xlim([.1 2]); ylim([.1 2.5]);
colorbar
hold off

figure(2)
hold on
grid on
title('Part b: f2 as the objetive');
contourf(x1,x2,f2_out)
plot(row_f2,col_f2,'c.','MarkerSize',20)
xlabel('Design Variable X1');ylabel('Design Variable X2');
xlim([.1 2]); ylim([.1 2.5]);
colorbar
hold off

figure(3)
hold on
grid on
title('Part c: f1 + f2 as the objetive');
contourf(x1,x2,f3_out)
plot(row_f3,col_f3,'c.','MarkerSize',20)
xlabel('Design Variable X1');ylabel('Design Variable X2');
xlim([.1 2]); ylim([.1 2.5]);
colorbar
hold off




