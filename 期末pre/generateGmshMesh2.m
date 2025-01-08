function generateGmshMesh2(geometryType, meshType)
    % geometryType: 'rectangle' 矩形
    % meshType: 'Quad' 或 'Triangle'，表示使用四边形或三角形网格
    % 创建 .geo 文件
    if strcmp(geometryType, 'rectangle')
        Lx = 10; % 矩形的长度
        Ly = 5;  % 矩形的宽度
        meshSize = 1; % 网格尺寸

        % 写入 Gmsh 的 .geo 文件
        geoFilename = 'rectangle.geo';
        fid = fopen(geoFilename, 'w');
        fprintf(fid, 'Lx = %f;\n', Lx);
        fprintf(fid, 'Ly = %f;\n', Ly);
        fprintf(fid, 'meshSize = %f;\n', meshSize);
        fprintf(fid, 'Point(1) = {0, 0, 0, meshSize};\n');
        fprintf(fid, 'Point(2) = {Lx, 0, 0, meshSize};\n');
        fprintf(fid, 'Point(3) = {Lx, Ly, 0, meshSize};\n');
        fprintf(fid, 'Point(4) = {0, Ly, 0, meshSize};\n');
        fprintf(fid, 'Line(1) = {1, 2};\n');
        fprintf(fid, 'Line(2) = {2, 3};\n');
        fprintf(fid, 'Line(3) = {3, 4};\n');
        fprintf(fid, 'Line(4) = {4, 1};\n');
        fprintf(fid, 'Line Loop(5) = {1, 2, 3, 4};\n');
        fprintf(fid, 'Plane Surface(6) = {5};\n');

        % 根据网格类型选择网格生成方式
        if strcmp(meshType, 'Quad')
            fprintf(fid, 'Transfinite Surface {6} = 10, 5;  // 四边形网格，指定网格分辨率\n');
            fprintf(fid, 'Recombine Surface {6};  // 强制转换为四边形网格\n');
        elseif strcmp(meshType, 'Triangle')
            % 三角形网格
        end
        
        % 设置网格为二维
        fprintf(fid, 'Mesh 2;\n');
        
        fclose(fid);
        % 调用 Gmsh 生成网格
        system(['gmsh ' geoFilename ' -2']);
        disp('网格已成功生成。');
    else
        disp('未实现此几何形状');
    end
end
