L2_error = 0;
for i = 1:size(elements, 1)
    % 获取当前元素的节点
    element_nodes = elements(i, :);
      % 获取该元素的数值解和解析解
    u_approx_element = u_approx(element_nodes);
    u_exact_element = u_exact(element_nodes);
    
    % 计算该元素的误差平方并累加
    L2_error = L2_error + sum((u_approx_element - u_exact_element).^2);
end

% 最终 L2 范数误差
L2_error = sqrt(L2_error);
fprintf('L2 Norm Error: %.4f\n', L2_error);
