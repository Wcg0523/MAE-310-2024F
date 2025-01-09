function [K, F] = applyDirichletBC(K, F, bcNodes, bcValues)
    % bcNodes: 边界节点（节点编号，2列，分别为自由度）
    % bcValues: 对应自由度的位移值（1列）

    for i = 1:size(bcNodes, 1)
        node = bcNodes(i, 1); % 节点编号
        dof = bcNodes(i, 2);  % 自由度（1代表x方向，2代表y方向）
        value = bcValues(i);  % 位移值

        row = 2*node - 1 + dof;  % 计算自由度的行号
        K(row, :) = 0;
        K(:, row) = 0;
        K(row, row) = 1;  % 将该自由度的刚度设为 1
        
        F(row) = value;  % 将负载向量更新为指定的位移值
    end
end
