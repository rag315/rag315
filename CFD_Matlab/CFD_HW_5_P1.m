%% CFD HW 5
% Problem # 1
%% Symbolics
% gamma, speed of air, velocity (left & right), lambda negative & positive
syms g c ul ur lambda_l lambda_r u
%% Lambda Matrices
ul = -u; ur = u;
% initialzing left and right matrices
lambda_l = sym(zeros(3));    lambda_r = sym(zeros(3));
% left                  % right
lambda_l(1,1) = ul;     lambda_r(1,1) = ur;
lambda_l(2,2) = ul + c; lambda_r(2,2) = ur + c; 
lambda_l(3,3) = ul - c; lambda_r(3,3) = ur - c;
%% Left eigenvectors
Hl = (c^2)/(g-1) + .5*ul^2;
Pl = [1 1 1;
    ul-c ul ul+c;
    Hl-ul*c .5*ul^2 Hl+ul*c];
Plinv = inv(Pl);
%% Right eigenvectors
Hr = (c^2)/(g-1) + .5*ur^2;
Pr = [1 1 1;
    ur-c ur ur+c;
    Hr-ur*c .5*ur^2 Hr+ur*c];
Prinv = inv(Pr);
%% Calculating A+ 
Aplus = Pl*lambda_l*Plinv;
%% Calculating A-
Aneg = Pr*lambda_r*Prinv;
%% Proof
disp('A+  ');
disp(Aplus);
disp('A-  ');
disp(Aneg);
soln = Aplus*Aneg;
disp('A+*A-');
disp(soln);


