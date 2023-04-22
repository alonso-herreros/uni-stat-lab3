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
x3 = poissrnd(2*lambdaX, N, 1); % Generate N samples of X3 ~ Poisson(2*lambdaX)
disp("By built-in function:")
disp(" Mean (should be close to 14) = " + mean(x3));
disp(" P(X3 > 15) = " + sum(x3 > 15)/N);

% Now, using the step-by step processes defined in the custom function
x3_custom = zeros(N, 1); % Start the vector at it's final size
for i = 1:N % Simulate N times
    % Add the number of requests received by each person
    x3_custom(i) = custom_poisson(lambdaX) + custom_poisson(lambdaX);
end
disp("By custom simulation:");
disp(" Mean (should be close to 14) = " + mean(x3_custom));
disp(" P(X3 > 15) = " + sum(x3_custom > 15)/N);
disp(" ");


disp("b) Probability of 180 or more students out of 250 people getting between 5 and 10 undesired friend requests each");
% Generate N samples of X ~ Poisson(lambdaX) for each of the 250 people
x_matrix = poissrnd(lambdaX, N, 250);
% Create a matrix of booleans, where each element is true if the person received between 5 and 10 undesired friend requests
x_bools = (x_matrix >= 5) & (x_matrix <= 10);
% Turn it into a vector of the number of people who received between 5 and 10 undesired friend requests, one entry per week
y = sum(x_bools, 2);
disp("Let Y = Number of students out of 250 who received between 5 and 10 undesired friend requests each")
disp("Y ~ B(250, P(5 <= X <= 10))")
disp("By built-in function:");
disp(" Mean = " + mean(y));
disp(" P(Y >= 180) = " + sum(y >= 180)/N);

% Using the step-by-step function to simulate the problem step by step.
x_matrix_custom = zeros(N, 250); % Start the vector at it's final size
for i = 1:N % Simulate N times
    for j = 1:250 % For each person, generate a sample of X ~ Poisson(lambdaX)
        x_matrix_custom(i, j) = custom_poisson(lambdaX);
    end
end
% Now, it's the same process as above
x_bools_custom = (x_matrix_custom >= 5) & (x_matrix_custom <= 10);
y_custom = sum(x_bools_custom, 2);
disp("By custom simulation:");
disp(" Mean = " + mean(y_custom));
disp(" P(Y >= 180) = " + sum(y_custom >= 180)/N);
disp(" ");
