function [nodes, elements] = read_gmsh(filename)
    % 读取 Gmsh 网格文件，返回节点坐标和元素连接矩阵
    fid = fopen(filename, 'r');
    tline = fgetl(fid);
    
    % 读取节点部分
    while ischar(tline)
        if contains(tline, '$Nodes')
            numNodes = str2double(fgetl(fid)); % 获取节点数量
            nodes = zeros(numNodes, 3);        % 存储节点坐标
            for i = 1:numNodes
                data = str2num(fgetl(fid));    %#ok<ST2NM>
                nodes(i, :) = data(2:4);       % 仅存储 (x, y, z) 坐标
            end
        end
        
        % 读取元素部分
        if contains(tline, '$Elements')
            numElements = str2double(fgetl(fid)); % 获取元素数量
            elements = zeros(numElements, 4);     % 假设为四边形元素
            for i = 1:numElements
                data = str2num(fgetl(fid));       %#ok<ST2NM>
                elements(i, :) = data(end-3:end); % 存储四边形节点编号
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end
