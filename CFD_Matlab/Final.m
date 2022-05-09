%% CFD Take home final
% By Rebecca Garcia rag315
j = sqrt(-1);        % imaginary
B = 0:.001:pi;       % Beta
B = B';              
% Initializing Matrices
v = zeros(length(B),1); zeta = zeros(length(B),1);
k = 1;  % counter
for i = 1:length(B)
v(i,:) = (2/3) - cos(B(i))-1;   % Maximum allowable value for v
z = 1 - .5*v(i,:)*(3-4*cos(B(i,:))+cos(2*B(i,:))+2*j*sin(B(i,:))*(2-cos(B(i,:))));
% Tracking Stable Values
if abs(z) <= 1
    zeta(i,:) = abs(z);
    range(k,:) = [B(i,:)/pi v(i,:) abs(z)]; % Normalizing B to pi
    k = k+1;    
elseif abs(z) > 1
    zeta(i,:) = NaN;
end


end
%% Plot
figure(3)
hold on, grid on
title('Maximum Value of v for each B')
xlabel('B/pi (rad)');ylabel('v')
plot(B/pi,v)
plot(range(:,1),range(:,2),'.')
legend('all possible','stable values')