%% Eng Design Opt Hw 1
%% Problem 1.25
% Created by Rebecca Garcia
%% Design Variables Max & Min
min1 = 0; max1 = 40;  
tm = min1:1:max1; tm = tm'; n = length(tm);
td = tm;
%% Initializing Arrays 
P_out = zeros(n,1); gm_out = P_out; gd_out = P_out;
%% Maximization Loop
 for i = 1:n
     x = tm(i);
     gm = x/6;
     for j = 1:n
     y = td(j);
     gd = y/5;
     hour = x + y;
     % If statement to prevent overstudying
     if gd > 4.0 || gm > 4.0
         P_out(i,j) = NaN;
         gm_out(i,j) = NaN;
         gd_out(i,j) = NaN;
     end
     % Constraints
     if hour >= 40 || y < 1.25*x
         P_out(i,j) = NaN;
         gm_out(i,j) = NaN;
         gd_out(i,j) = NaN;
     elseif hour <= 40 && y >= 1.25*x
         P = 4*x + 3*y;
         P_out(i,j) = P;
         gm_out(i,j) = gm;
         gd_out(i,j) = gd;
     end
     end
 end
%% Finding Max Values
[Grade,index] = max(P_out(:));
[pnt1,pnt2] = ind2sub(size(P_out),index);
row = tm(pnt2); col = td(pnt1);
%% Plots
figure(1)
hold on
grid on
title('Problem 1.25: Maximum Function Value')
contourf(tm,td,P_out)
plot(row,col,'c.','MarkerSize',20)
xlabel('Design Variable tm');ylabel('Design Variable td');
colorbar
hold off

figure(2)
hold on
grid on
title('Problem 1.25: Optimum Math Grade')
contourf(tm,td,gm_out)
plot(row,col,'c.','MarkerSize',20)
xlabel('Design Variable tm');ylabel('Design Variable td');
colorbar
hold off

figure(3)
hold on
grid on
title('Problem 1.25: Optimum Design Grade')
contourf(tm,td,gd_out)
plot(row,col,'c.','MarkerSize',20)
xlabel('Design Variable tm');ylabel('Design Variable td');
colorbar
hold off

 