function writeGmshFileWithResults(nodes, elements, displacements, strains, stresses)
    filename = 'model_with_results.msh';
    fid = fopen(filename, 'w');
   
    fprintf(fid, '$MeshFormat\n');
    fprintf(fid, '2.2 0 8\n');
    fprintf(fid, '$EndMeshFormat\n');
    
    % 写入节点数据
    fprintf(fid, '$Nodes\n');
    fprintf(fid, '%d\n', size(nodes, 1));  % 节点数
    for i = 1:size(nodes, 1)
        fprintf(fid, '%d %f %f %f\n', i, nodes(i, 1), nodes(i, 2), 0);  % 节点编号 (x, y, z)
    end
    fprintf(fid, '$EndNodes\n');
    
    % 写入单元数据
    fprintf(fid, '$Elements\n');
    fprintf(fid, '%d\n', size(elements, 1));  % 单元数
    for i = 1:size(elements, 1)
        fprintf(fid, '%d 3 2 0 0 %d %d %d %d\n', i, elements(i, :));  % 单元类型：四节点单元
    end
    fprintf(fid, '$EndElements\n');
    
    % 写入位移数据
    fprintf(fid, '$NodeData\n');
    fprintf(fid, '1\n');  % 数据ID
    fprintf(fid, 'Displacement\n');  % 数据标签
    fprintf(fid, '%d\n', size(nodes, 1));  % 节点数
    for i = 1:size(nodes, 1)
        % 将位移数据以节点编号的形式写入，假设是 (u_x, u_y) 位移
        fprintf(fid, '%d %f %f\n', i, displacements(i, 1), displacements(i, 2));
    end
    fprintf(fid, '$EndNodeData\n');
    
    % 写入应变数据
    fprintf(fid, '$ElementData\n');
    fprintf(fid, '1\n');  % 数据ID
    fprintf(fid, 'Strain\n');  % 数据标签
    fprintf(fid, '%d\n', size(elements, 1));  % 单元数
    for i = 1:size(elements, 1)
        % 将应变数据以单元编号的形式写入
        fprintf(fid, '%d %f %f %f\n', i, strains(i, 1), strains(i, 2), strains(i, 3));
    end
    fprintf(fid, '$EndElementData\n');
    
    % 写入应力数据
    fprintf(fid, '$ElementData\n');
    fprintf(fid, '2\n');  % 数据ID
    fprintf(fid, 'Stress\n');  % 数据标签
    fprintf(fid, '%d\n', size(elements, 1));  % 单元数
    for i = 1:size(elements, 1)
        % 将应力数据以单元编号的形式写入
        fprintf(fid, '%d %f %f %f\n', i, stresses(i, 1), stresses(i, 2), stresses(i, 3));
    end
    fprintf(fid, '$EndElementData\n');
    
    fclose(fid);
end
