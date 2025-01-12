H1_error = 0;
for i = 1:length(grad_u_exact)
    % 计算梯度差异并累加
    grad_error = grad_u_exact(i) - grad_u_approx(i);
    H1_error = H1_error + grad_error^2;
end

% 计算最终的 H1 误差
H1_error = sqrt(H1_error);
fprintf('H1 Norm Error: %.4f\n', H1_error);
