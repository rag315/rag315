%% Eng Design Opt Hw 1
%% Problem 1.5
% Created by Rebecca Garcia
%% Design Variables Max & Min
min1 = 200; min2 = 400; 
max1 = 10000; max2 = 10000; % No maximum allowable limit was specified, so 10,000 was chosen to represent infinity
n = 100; delta1 = max1/n; delta2 = max2/n;
%% Initializing Indexes
x1 = min1:delta1:max1; x1 = x1'; m = length(x1);
x2 = min2:delta2:max2; x2 = x2'; x2(98,1) = 10001; x2(99,1) = 10002;
%% Initialzing Arrays
Inv_Out = zeros(n-1);Obj_out = zeros(n-1);
%% Minimization Loop
% There are three design variables, units produced in week 1,
% units produeced in week 2, and week 1 units sold
% In order to minimize storage cost, the number of week 1 units sold must be maximized.

% Prediction: The units produced in week 1 and week 2 should be the minimum
% amount required to supply the customer. And the number of week 1 units
% sold should be equal to the number of week 1 units produced to minimize
% storage costs.

for i = 1:m
    x = x1(i);      % Design Variable 1
    % The number of units sold can never exceed the number of units
    % produced.
    deltaSold = x/n;
    soldv = 200:deltaSold:x; soldv = soldv'; 
    z = length(soldv);
   for j = 1:m
       y = x2(j);   % Design Variable 2
       for k = 1:z
          sold = soldv(k);  % Design Variable 3
          inv = x - sold;  % Inventory left over after week 1 units are sold
          Cost = 4*x^2 + 4*y^2 + 10*inv;   % Objective Function
          Obj_out(j,i) = Cost;      % Matrix Output of all possible options
       end
   end
end
%% Finding Minimum Values
[Cost,index] = min(Obj_out(:));
[pnt1,pnt2] = ind2sub(size(Obj_out),index);
row = x1(pnt2); col = x2(pnt1);
inv = (Cost - 4*row^2 - 4*col^2)/10;
sold = row - inv;
%% Plots
figure(1)
hold on
grid on
title('Problem 1.5')
contourf(x1,x2,Obj_out)
plot(row,col,'c.','MarkerSize',20)
xlabel('Design Variable X1');ylabel('Design Variable X2');
colorbar
hold off

disp('Number of week 1 units produced: ');disp(row);
disp('Number of week 2 units produced: ');disp(col);
disp('Number of week 1 units sold: ');disp(sold);