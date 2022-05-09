%% EDO Assignment 9
% By Rebecca Garcia rag315
% Plotting inequality function from:
% Jorge De Los Santos (2020). Plotting inequalities 
%(https://www.mathworks.com/matlabcentral/fileexchange/56996-plotting-inequalities-ineqplot)
% MATLAB Central File Exchange. Retrieved November 19, 2020. 

%% Problem 1
R = [0 5]; % Range to be graphed, only positive x-values
g1 = '8*x+y>8';
g2 = '2*x+y>6';
g3 = '1*x+3*y>6';
g4 = 'x+6*y>8';
figure(1)
hold on, grid on
title('Problem 1 Constraints')
ineqplot(g1,R,'r')
ineqplot(g2,R,'p')
ineqplot(g3,R,'c')
ineqplot(g4,R,'m')
plot(2.4,1.2,'*k')
xlabel('x1');ylabel('x2');
legend('g1','g2','g3','g4','optimum point')
hold off
%% Problem 2
R = [0 20]; % Range of values, only positive
g1 = 'x-y>-8';
g2 = '5*x-y>0';
g3 = 'x+y>8';
g4 = '-x+6*y>12';
g5 = 'x<10';
figure(2)
hold on, grid on
title('Problem 2 Constraints')
ineqplot(g1,R,'r')
ineqplot(g2,R,'p')
ineqplot(g3,R,'c')
ineqplot(g4,R,'m')
ineqplot(g5,R,'y')
plot(7.43,15.43,'*k')
legend('g1','g2','g3','g4','g5','optimum point')
xlabel('x1');ylabel('x2');
hold off

%% Function
function h = ineqplot(I,R,c)
% Plotting inequalities, simple and easy.
%
% Input arguments
%            I    -   Inequality as string, i.e.  'x+y>10'
%            R    -   Vector of four components defined by: [xmin, xmax, ymin, ymax], 
%                     if two components are passed: [min, max], the defined region 
%                     will be a square and xmin=ymin=min, xmax=ymax=max.
%            c    -   A three-element RGB vector, or one of the MATLAB 
%                     predefined names, specifying the plot color.
%
% Output arguments
%            h    -   returns the handle of the scattergroup 
%                     object created.
%
% Examples: 
%           >> ineqplot('x.^2+y.^2<10',[-5 5], 'r');
%           >> h = ineqplot('y<x+3',[0 10 -5 5]);
%           >> set(h,'MarkerFaceColor','r'); % Change color
%
% 
% $ Author:   Jorge De Los Santos $
% $ Version:  0.1.0 (initial version) $
%
% Deafault color
if nargin<3, c='b'; end; % blue default
% Length of R vector
if length(R)==4
    xmin = R(1); xmax = R(2);
    ymin = R(3); ymax = R(4);
elseif length(R)==2
    xmin = R(1); xmax = R(2);
    ymin = R(1); ymax = R(2);
end
% hold
set(gca,'NextPlot','add');
% Limits
axis([xmin xmax ymin ymax]);
% Number of points (Change N value for more resolution)
N = 300;
dx=(xmax-xmin)/N; % 
dy=(ymax-ymin)/N;
[x,y]=meshgrid(xmin:dx:xmax, ymin:dy:ymax);
% Eval condition
idx = find(~eval(I)); 
x(idx) = NaN; %#ok
h = plot(x(:),y(:),c,...
    'LineStyle','-',...
    'MarkerSize',1);
end