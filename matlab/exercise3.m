%% Computational processes
disp('== 3. Computational processes ==');

N = 10000; % number of simuXlations

% T1, T2, T3 = Execution times of each processes in ms, Ti ~ Exp(lambdaT)
lambdaT = 35; % 1/ms
muT = 1/lambdaT; % ms

disp("a) Total computational time");
% Using the built-in function
t_matrix = exprnd(1/lambdaT, N, 3); % Generate N samples of 3 instances T ~ Exp(lambdaX)
t_serial = sum(t_matrix, 2); % Sum the 3 instances to get the total computational time
disp("By built-in function:")
disp(" Mean (should be close to 3/35) = " + mean(t_serial));

% Now, using the inverse transform method
% F(x) = 1 - e^(-lambdaX * x) = U <=> x = -1/lambdaX * ln(1 - U) = -muX * ln(1 - U)
% U ~ U(0, 1) => X ~ Exp(lambdaX)
u_matrix = rand(N, 3); % Generate N samples of 3 instances of U ~ U(0, 1)
t_matrix_custom = -1/lambdaT * log(1 - u_matrix); % Generate N samples of 3 instances of X ~ Exp(35)
t_serial_custom = sum(t_matrix_custom, 2); % This is the same procedure once the values are generated
disp("By manual simulation:")
disp(" Mean (should be close to 3/35) = " + mean(t_serial_custom));
disp(" ")


disp("b) Saved time if the process are run in parallel");

% Theoretical calculation
% T = max(T1, T2, T3) => FT(t) = P(T <= t) = P(max(T1, T2, T3) <= t) = P(T1 <= t ∩ T2 <= t ∩ T3 <= t) = P(T1 <= t) * P(T2 <= t) * P(T3 <= t)
%                              = P(T1 <= t)^3 = Fi(t)^3
% fT(t) = d/dt FT(t)
% Mean = E(T) = integral(0, inf, t * fT(t) dt)
% I used python to solve this integral:
%  from sympy import *
%  t, lam = symbols('t λ')
%  F = 1 - exp(-lam * t)
%  FT = F**3
%  fT = FT.diff(t)
%  Ex_T = integrate(t * fT, (t, 0, oo)).subs(lam, 35)
%  print(Ex_T)

% Output: 11/210
% Which is around 0.05238

% So, the mean saved time is the difference between the mean of the serial execution and the mean of the parallel execution,
% Where the mean of the serial execution is the sum of the means of each process.
improvement_theor = 3*muT - 11/210;
disp("Theoretical calculation:");
disp(" Mean saved time: " + improvement_theor + " ms");

% We have already generated matrices with random samples, so we can just use those values.
% There's not a lot to do "manually", since we just have to take the maximum of each row
t_parallel = max(t_matrix, [], 2); % Get the max of each row
disp("By simulations:")
disp(" Mean(max(T1, T2, T3)) (should be around 11/210)= " + mean(t_parallel));
disp(" Mean saved time: " + (mean(t_serial) - mean(t_parallel)) + " ms");
disp(" ")

disp("c) Serial with λ = 40 vs parallel with λ = 35");
% Let's create the new matrix with lambda = 40
% Using the built-in function, I don't think there's any need to do this manually anymore.
lambdaT_ = 40;
t_matrix_ = exprnd(1/lambdaT_, N, 3); % Generate N samples of 3 instances T ~ Exp(lambdaX)
t_serial_ = sum(t_matrix_, 2); % Sum the 3 instances to get the total computational time
disp("Mean of serial execution with λ = 40 (should be close to 3/40): " + mean(t_serial_));
disp("Mean of parallel execution with λ = 35: " + mean(t_parallel));

