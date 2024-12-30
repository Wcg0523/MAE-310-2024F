% 精确解
exact_solution = @(x, y) x .* (1 - x) .* y .* (1 - y);
exact_solution_x = @(x, y) (1 - 2 * x) .* y .* (1 - y);
exact_solution_y = @(x, y) x .* (1 - x) .* (1 - 2 * y);

kappa = 1.0; 
f = @(x, y) 2.0 * kappa * x .* (1 - x) + 2.0 * kappa * y .* (1 - y);
