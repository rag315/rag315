%% Eng Design Opt Hw 3:
%% Problem 1
% Created by Rebecca Garcia
%% Graphing Variables
x = -10:.5:10;
y = -10:.5:10;
x = x';
y = y';
%% Initializing matrices
m = length(x);
f = zeros(m); g = zeros(m);
%% Constants
x0 = 1;
y0 = 1;
a = 1; b = 1; c = 1;
%% Objective Function loop
for i = 1:m
    for j = 1:m
    f(i,j) = .5*((x(i)-x0)^2+(y(j)-y0)^2 ); % Obj Function
    g(i,j) = x(i) + y(j) + 1;       % Constraint loop
        if g(i,j) > 0
            g(i,j) = NaN;
        end 
        
    end
end
%% Plot
figure (1)
hold on
contourf(x,y,f)
contour(x,y,g,'c')
plot(-.5,-.5,'y.','MarkerSize',20)
colorbar
hold off
