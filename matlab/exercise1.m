%% Undesired friend requests
disp('== 1. Undesired friend requests ==');

% X ~ Poisson(7) : number of undesired friend requests in a week. λX = 7 (requests/week)
% X1 and X2 ~ Poisson(7) : number of undesired friend requests in a week, two independent people. λX1 = λX2 = 7
% X3 = X1 + X2 ~ Poisson(7+7) : number of total undesired friend requests in a week between two people. λX3 = 14
% T ~ Exp(1/7) : time between two undesired friend requests. λT = 1/7 (weeks/request)
% T3 ~ Exp(1/14) : time between undesired friend requests, two people at once. λT3 = 1/14 (weeks/request)

N = 10000; % number of simulations
lambdaX = 7; % requests/week

disp("a) Probability of two people getting more than 15 undesired friend requests");
% There is a built-in function to do exactly what we need
x = poissrnd(2*lambdaX, N, 1); % Generate N samples of X3 ~ Poisson(2*lambdaX)
disp("By built-in function:")
disp(" Mean (should be close to 14) = " + mean(x));
disp(" P(X3 >= 15) = " + sum(x >= 15)/N);

% Now, using the step-by step processes defined in the custom function
x_custom = zeros(N, 1); % Start the vector at it's final size
for i = 1:N % Simulate N times
    x_custom(i) = custom_poisson(lambdaX) + custom_poisson(lambdaX); % Add the number of requests received by each person
end
disp("By custom simulation:");
disp(" Mean (should be close to 14) = " + mean(x_custom));
disp(" P(X3 >= 15) = " + sum(x_custom >= 15)/N);
disp(" ");


disp("b) Probability of 180 or more students out of 250 people getting between 5 and 10 undesired friend requests each");
% Generate N samples of X ~ Poisson(lambdaX) for each of the 250 people
x_matrix = poissrnd(lambdaX, N, 250);
% Create a matrix of booleans, where each element is true if the person received between 5 and 10 undesired friend requests
x_bools = (x_matrix >= 5) & (x_matrix <= 10);
% Turn it into a vector of the number of people who received between 5 and 10 undesired friend requests, one entry per week
y = sum(x_bools, 2);
disp("Let Y = Number of students out of 250 who received between 5 and 10 undesired friend requests each => Y ~ B(250, P(5 <= X <= 10))")
disp("By built-in function:");
disp(" Mean = " + mean(y));
% If we call Y the number of people who received between 5 and 10 undesired friend requests, then Y ~ B(250, P(5 <= X <= 10))
disp(" P(Y >= 180) = " + sum(y >= 180)/N);

% Using the step-by-step function to simulate the problem step by step.
x_matrix_custom = zeros(N, 250); % Start the vector at it's final size
for i = 1:N % Simulate N times
    for j = 1:250 % For each person
        x_matrix_custom(i, j) = custom_poisson(lambdaX); % Generate a sample of X ~ Poisson(lambdaX)
    end
end
% Now, it's the same process as above
x_bools_custom = (x_matrix_custom >= 5) & (x_matrix_custom <= 10);
y_custom = sum(x_bools_custom, 2);
disp("By custom simulation:");
disp(" Mean = " + mean(y_custom));
disp(" P(Y >= 180) = " + sum(y_custom >= 180)/N);
disp(" ");




function [n] = custom_poisson(lambda)
    elapsed = 0; % Time elapsed since the start of the week
    n = -1; % Requests recevied this week. Starting at -1 so on the first loop it becomes 0
    
    while elapsed < 1 
        % Add 1 to the number of requests received this week. At first it becomes 0. If the loop is repeated, it becomes 1, etc.
        n = n + 1;
        % Generate a random time t, according to the distribution of T3 ~ Exp(1/2*lambdaX). This is the time until the next undesired friend request.
        % t = exprnd(1/lambda); <- this is a built-in function that does exactly what we need here, but I'm going to do it manually.
        % X ~ Exp(1/lambda) -> F(x) = 1 - e^(-lambda*x)
        % F(x) = U -> 1 - e^(-lambda*x) = U -> e^(-lambda*x) = 1 - U -> -lambda*x = ln(1 - U) -> x = -ln(1 - U)/lambda
        % So, we generate a random number U ~ U(0, 1) and use it to generate a random time t ~ Exp(1/lambda)
        U = rand();
        t = -log(1 - U)/lambda;
        % Add the time until the next undesired friend request to the elapsed time
        elapsed = elapsed + t;
        % If this time is still before the end of the week, then this request was still received in the same week. The loop will repeat
    end
end