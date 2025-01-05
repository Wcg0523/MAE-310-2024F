function K = build_stiffness_matrix(nodes, elements, E, nu)
    % 使用双线性四边形元素构建平面弹性问题的刚度矩阵
    numNodes = size(nodes, 1);
    K = zeros(2 * numNodes, 2 * numNodes); % 全局刚度矩阵
    
    % 平面应力条件下的材料矩阵
    D = E / (1 - nu^2) * [1, nu, 0;
                          nu, 1, 0;
                          0, 0, (1 - nu) / 2];
    
    % 遍历每个元素，计算局部刚度矩阵并装配到全局矩阵中
    for el = 1:size(elements, 1)
        elementNodes = elements(el, :);   % 当前元素的节点编号
        coords = nodes(elementNodes, 1:2);% 提取节点的 (x, y) 坐标
        
        % 计算形函数梯度和 Jacobian
        [B, detJ] = compute_B_matrix(coords);
        
        % 局部刚度矩阵
        Ke = B' * D * B * detJ;
        
        % 装配到全局刚度矩阵
        dof = reshape([2 * elementNodes - 1; 2 * elementNodes], 1, []);
        K(dof, dof) = K(dof, dof) + Ke;
    end
end

function [B, detJ] = compute_B_matrix(coords)
    % 计算形函数梯度矩阵 B 和 Jacobian 的行列式 detJ
    xi = [-1, 1, 1, -1] / sqrt(3); % 高斯积分点
    eta = [-1, -1, 1, 1] / sqrt(3);
    
    B = zeros(3, 8); % B 矩阵大小为 3x8（平面应力）
    
    % 计算 Jacobian 和形函数梯度
    for i = 1:4
        dN_dxi = 0.25 * [(1 - eta(i)), (1 + eta(i)), (1 + eta(i)), (1 - eta(i))];
        dN_deta = 0.25 * [(1 - xi(i)), (1 - xi(i)), (1 + xi(i)), (1 + xi(i))];
        
        J = [dN_dxi; dN_deta] * coords; % Jacobian 矩阵
        detJ = det(J);                  % Jacobian 的行列式
        
        % 计算形函数对全局坐标的梯度
        dN_dx = J \ [dN_dxi; dN_deta];
        
        % 填充 B 矩阵
        B(1, i * 2 - 1) = dN_dx(1);
        B(2, i * 2) = dN_dx(2);
        B(3, i * 2 - 1:i * 2) = dN_dx;
    end
end
