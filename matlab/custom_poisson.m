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