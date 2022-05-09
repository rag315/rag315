%% CFD Homework 2 Graphical Solution
% Written by Rebecca Garcia 9/17/2020
% Though beta is from 0 to pi, this simulation was ran from 0 to 2pi to
% produce periodic waves
clc; format long
%% Constants
Pi = 3.14159265; % length of trailing decimals chosen for increased accuracy 
i = sqrt(-1);
n = 1000; % Index Count
Delta = (2*Pi)/n;   % Incrimental values
%% Initializing Matrices
betaOut = zeros(n+1,2); nu = zeros(n+1,2); Amp = zeros(2*n+2,1); PhaseOut = zeros(n+1,1); index = (0:1:1000)';
%% Main Loop
% beta is inrimented from 0 to 2pi in 1001 incriments, starting at
% t = 0; The index incriments can be thought of as a unit of time
for j = 1:1:(n+1)
    
s = j-1; % treating s like a time index for phase

phase = exp(2*Pi*i*s/n);
beta = (j-1)*Delta;
% Creating Nu Ranges
nuPos = +real(sqrt(1/cos(2*beta))); % top nu
nuNeg = -real(sqrt(1/cos(2*beta))); % bottom nu

%% Export Matrices for Plotting
PhaseOut(j,:) = real(phase); % Only real values are taken to speed up plotting
betaOut(j,:) = [beta beta*180/pi];    
nu(j,:) = [nuPos nuNeg];
end 
%% Building Ranges of nu & betas for Amplification Calculations
Range(1:(n+1),1) = nu(:,1);Range(1:(n+1),2) = betaOut(:,1); 
Range((n+2):(2*n+2),1) = nu(:,2); Range((n+2):(2*n+2),2) =  betaOut(:,1);
maxindex = length(Range);
% Amplification Factor Calculation Loop
for j = 1:maxindex
    nurange = Range(j,1);
    beta = Range(j,2);
    Amp(j,1) = abs(1/(1+ nurange*(cos(beta) + i*sin(beta)-1))); % Amplification for all Nu & beta Ranges
    
end
Range(:,2) = Range(:,2)*180/pi; % converting beta back into deg
%% Command Window Output
limit = max(max(Amp(:)));
disp('Maximum Amplification: ');disp(limit);
if limit > 1
    disp('Method is Unstable')
elseif limit < 1
    disp('Method is Stable')
elseif limit == 1
    disp('Method is Conditionally Stable')
end
%% Plots
figure(1) 
grid on
hold on
title('nu as a function of beta');
xlabel('beta in deg');ylabel('nu');
plot(betaOut(:,2),nu(:,1))
plot(betaOut(:,2),nu(:,2))
legend('Top nu Range','Bottom nu Range','location','best');
ylim([-20 20]); % y axis limit needed because as beta goes to 45 deg, nu grows exponentially
xlim([0 360]);
hold off

figure(2)
grid on
hold on
title('Amnplification Factor vs beta');
xlabel('beta in deg');ylabel('Amplification');
plot(Range(:,2),Amp(:,1))
xlim([0 360]);
hold off

figure(3)
grid on
hold on
title('Amnplification Factor vs nu');
xlabel('nu');ylabel('Amplification');
plot(Range(:,1),Amp(:,1))
hold off

figure (4)
grid on
hold on
title('Phase vs Beta');
xlabel('Beta (deg)');ylabel('Phase');
plot(betaOut(:,2),PhaseOut)
xlim([0 360]);
hold off