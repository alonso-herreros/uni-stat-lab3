%% Undesired friend requests
disp('== 2. Exponential RVs with time ==');


N = 10000; % number of simuXlations

disp("a) Waiting time to login, less than 3 seconds");
% X = Waiting time to login, in seconds
% density funciton f(x) = {1/5 * e^(-1/5 * x)  if x >= 0
%                         {     0              otherwise
% X is clearly an exponential random variable with lambdaX = 1/5
% F(x) = integral from 0 to x of (f(t) dt) = integral from 0 to x of (1/5 * e^(-1/5 * x) if x >=0, 0 otherwise) dx =
%      = (-e^(-1/5 * x)) evaluated from 0 to x = (-e^(-1/5 * x)) - (-e^(-1/5 * 0)) = 1 - e^(-1/5 * x)
% We already knew this: F(x) = 1 - e^(-1/5 * x)
lambdaX = 1/5; % 1/seconds
muX = 1/lambdaX; % seconds

% Theoretical calculation
disp("Theoretical calculation:")
disp(" Mean = " + muX);
disp(" P(X < 3) = F(3) = " + (1 - exp(-lambdaX * 3)));

% Again, we have a built-in function to do exactly what we need
x = exprnd(muX, N, 1); % Generate N samples of X ~ Exp(lambdaX)
disp("By built-in function:")
disp(" Mean (should be close to 5) = " + mean(x));
disp(" P(X < 3) = " + sum(x < 3)/N);

% Now, we will do it manually
% We will use the inverse transform method
% F(x) = U <=> 1 - e^(-1/5 * x) = U <=> e^(-1/5 * x) = 1 - U <=> -1/5 * x = ln(1 - U) <=> x = -5 * ln(1 - U)
% So, we can generate X ~ Exp(1/5) by generating U ~ U(0, 1) and then X = -5 * ln(1 - U)
u = rand(N, 1); % Generate N samples of U ~ U(0, 1)
x_custom = -5 * log(1 - u); % Generate N samples of X ~ Exp(1/5)
disp("By manual simulation:")
disp(" Mean (should be close to 5) = " + mean(x_custom));
disp(" P(X < 3) = " + sum(x_custom < 3)/N);
disp(" ")

disp("b) Duration of connection, between half an hour and three quarters of an hour");
% Y = Duration of connection, in hours
% density funciton f(y) = {3 * e^(-3 * y)  if y >= 0
%                         {     0          otherwise
% Y is just an exponential random variable with lambdaX = 3
% F(y) = 1 - e^(-3 * y)
lambdaY = 3; % 1/hours
muY = 1/lambdaY; % hours

% Theoretical calculation
disp("Theoretical calculation:")
disp(" Mean = " + muY);
disp(" P(1/2 < Y < 3/4) = F(3/4) - F(1/2) = " + (1 - exp(-lambdaY * 3/4) - (1 - exp(-lambdaY * 1/2))));

% Using the built-in function
y = exprnd(muY, N, 1); % Generate N samples of Y ~ Exp(lambdaY)
disp("By built-in function:")
disp(" Mean (should be close to 1/3) = " + mean(y));
disp(" P(1/2 < Y < 3/4) = " + sum(y > 1/2 & y < 3/4)/N);

% Using the inverse transform method
% F(y) = U <=> 1 - e^(-3 * y) = U <=> e^(-3 * y) = 1 - U <=> -3 * y = ln(1 - U) <=> y = -1/3 * ln(1 - U)
u = rand(N, 1); % Generate N samples of U ~ U(0, 1)
y_custom = -1/3 * log(1 - u); % Generate N samples of Y ~ Exp(3)
disp("By manual simulation:")
disp(" Mean (should be close to 1/3) = " + mean(y_custom));
disp(" P(1/2 < Y < 3/4) = " + sum(y_custom > 1/2 & y_custom < 3/4)/N);
disp(" ")


