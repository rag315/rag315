%% EDO Homework 5
% by Rebecca Garcia rag315
clc, format long
%% Problem 1
% Initial Values
x0 = (3*pi)/4; min = 0; max = 3.141592653589793;
dx = -1;
% toll
tol = .006; n = 1; nmax = 500;
while (max-min) >= tol
    % Tracking successful iterations
    count.min(n,1) = min; count.max(n,1) = max; 
    % Proceedure
    lambda.a = min + 0.25*(max-min);
    lambda.b = min + 0.50*(max-min);
    lambda.c = min + 0.75*(max-min);
    
    x.a(n,1) = x0 + lambda.a*dx;
    x.b(n,1) = x0 + lambda.b*dx;
    x.c(n,1) = x0 + lambda.c*dx;
    
    f.a(n,1) = feval(x.a(n,1));
    f.b(n,1) = feval(x.b(n,1));
    f.c(n,1) = feval(x.c(n,1));

    % Seaching for new lambda Values
    disp('Iteration: ');disp(n)
    
    if f.a(n) < f.b(n) && f.a(n) < f.c(n)
        max = lambda.a;
    disp('new max = lambda.a');disp(lambda.a')
    disp('old min: ');disp(min)
    
    elseif f.b(n) < f.a(n) && f.b(n) < f.c(n)
        min = lambda.a; max = lambda.c;
    disp('new max = lambda.c');disp(lambda.c') 
    disp('new min = lambda.a');disp(lambda.a')
    
    elseif f.c(n) < f.b(n) && f.c(n) < f.a(n)
        min = lambda.b;
    disp('new min = lambda.b');disp(lambda.b')    
    disp('old max');disp(max)
    end
    
    % Iteration Check
    n = n +1;
    if n > nmax 
        disp('max iterations reached')
        break
    end
    
end
%% Solving for f(x)
count.range = zeros(n-1,100); 
for i = 1:n-1
     dum.min = count.min(i,1); dum.max = count.max(i,1);
     delta = abs(dum.min - dum.max)/100;
     for j = 1:100
         count.range(i,j) = dum.min + j*delta;
         count.f(i,j) = feval(count.range(i,j));
     end
end
%% Figures
%
figure(1)
title('Problem 1: Successful Iterations')
for i = 1:n-1
hold on, grid on
scatter(x.a(i,1),f.a(i,1),'r','filled');
scatter(x.b(i,1),f.b(i,1),'b','filled');
scatter(x.c(i,1),f.c(i,1),'g','filled');
end
legend('f1','f2','f3')
xlabel('x (rad)');ylabel('f(x)')
hold off

colors = [0.83 0.14 0.14
          1.00 0.54 0.00
          0.47 0.25 0.80
          0.25 0.80 0.54
          0.17,1.00,0.75
          1.00,0.29,0.55
          1.00,0.65,0.82
          1.00,0.49,0.10
          1.00,0.49,0.10
          0.80,1.00,0.85
          0.95,1.00,0.27
          0.61,0.86,1.00
          1.00,0.84,0.32
          ];    
figure (2), hold on      
title('Problem 1: Part b')
ylim([0 1]);xlim([0 pi]);
plot(count.range(1,:),count.f(1,:),'k');    % Original Function
for i = 2:n-1
hold on, grid on
    plot(count.range(i,:),count.f(i,:),'-','Color',colors(i,:));% Iterations
    plot(count.min(i,1),count.f(i,1),'*','MarkerSize',10,'Color',colors(i,:),'HandleVisibility','off');
    plot(count.max(i,1),count.f(i,100),'*','MarkerSize',10,'Color',colors(i,:),'HandleVisibility','off');
end
legend('1','2','3','4','5','6','7','8','9','10','11','12','13','Location','eastoutside');
xlabel('x (rad)');ylabel('f(x)')
hold off

%% Functions
function f = feval(x)
    f = sin(x);
end