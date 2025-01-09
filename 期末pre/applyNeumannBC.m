function F = applyNeumannBC(F, neumannNodes, neumannValues)
    % neumannNodes: 外力作用的节点
    % neumannValues: 对应外力的大小

    for i = 1:size(neumannNodes, 1)
        node = neumannNodes(i, 1); % 节点编号
        force = neumannValues(i);  % 外力值

        row = 2*node - 1;  % 计算节点的 x 方向自由度行号
        F(row) = F(row) + force;  % 加上外力

        row = 2*node;  % 计算节点的 y 方向自由度行号
        F(row) = F(row) + force;  % 加上外力
    end
end
