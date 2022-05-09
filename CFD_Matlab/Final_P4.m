%% CFD Final Problem 4
% rag315
syms u H rho P E Z Q F z1 z2 z3 gamma
%P = (gamma-1)*(E - .5*(rho*u^2));
H = (E+P)/rho;
z1 = sqrt(rho); z2 = sqrt(rho)*u; z3 = sqrt(rho)*H;
Z = [z1 z2 z3]';
Q = [z1^2 z1*z2 z1*z3 - P]';
F = [z1*z2 z2^2+P z2*z3]';

dFdQ = [(z1*z2/z1^2) (z1*z2)/(z1*z2) (z1*z2/(z1*z3 - P));
        (z2^2+P)/(z1^2) (z2^2+P)/(z1*z2) (z2^2+P)/(z1*z3 - P);
        (z2*z3)/(z1^2) (z2*z3)/(z1*z2) (z2*z3)/(z1*z3 - P)]
    
Bbar = [2*sqrt(rho) 0 0;
        u*sqrt(rho) sqrt(rho) 0;
        H*sqrt(rho) 0 sqrt(rho)];
Bbarinv = inv(Bbar)

Cbar = [u*sqrt(rho) sqrt(rho) 0;
        0 2*u*sqrt(rho) 0;
        0 H*sqrt(rho) u*sqrt(rho)];  
    
product = Cbar*Bbarinv
