% 计算梯度误差
grad_error = grad_u_exact - grad_u_approx;

% 计算 H1 规范误差
H1_error = sqrt(sum(grad_error.^2));

fprintf('H1 Norms Error: %.4f\n', H1_error);
