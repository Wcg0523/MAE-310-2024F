clear; clc; 

R = 0.5; % 圆孔半径 [m]
L = 4;   % 矩形边长 [m]
Tx = 10e3; % 远场拉伸应力 [Pa]
E = 1e9; % 弹性模量 [Pa]
nu = 0.3; % 泊松比

Hmax = 0.1; % 网格最大单元尺寸

% 定义平面应力和应变选项
analysisType = {'planestress', 'planestrain'}; % 两种分析方式

% 创建 PDE 模型
model = createpde('structural','static-planestrain' ); % 平面应力
% 对于平面应变，将 'static-planestress' 替换为 'static-planestrain'

% 定义四分之一模型的几何
rect = [3, 4, 0, L/2, L/2, 0, 0, 0, L/2, L/2]'; % 矩形几何
circle = [1, 0, 0, R]'; % 圆形几何
circle = [circle; zeros(size(rect, 1) - size(circle, 1), 1)];% 补齐行数
gd = [rect, circle];
sf = 'R1-C1'; % 减去圆
ns = char('R1', 'C1')';
g = decsg(gd, sf, ns); % 几何布尔操作
geometryFromEdges(model, g);

generateMesh(model, 'Hmax', Hmax); % 生成网格
figure;
pdeplot(model); % 可视化网格
title('网格结构');

%材料属性
structuralProperties(model, 'YoungsModulus', E, 'PoissonsRatio', nu);

%边界条件
% 圆孔边界：σ_rr = 0（无压力）
structuralBoundaryLoad(model, 'Edge', 2, 'Pressure', 0);

% 左侧边界：对称条件（x方向位移为0）
structuralBC(model, 'Edge', 4, 'XDisplacement', 0);

% 下侧边界：对称条件（y方向位移为0）
structuralBC(model, 'Edge', 3, 'YDisplacement', 0);

% 右侧边界：施加均匀拉伸应力 Tx
structuralBoundaryLoad(model, 'Edge', 1, 'SurfaceTraction', [Tx, 0]);

result = solve(model);

% 位移场可视化
figure;
pdeplot(model, 'XYData', result.Displacement.Magnitude, 'Deformation', result.Displacement, 'DeformationScaleFactor', 5);
title('位移场');
colorbar;

% 应力场可视化
figure;
pdeplot(model, 'XYData', result.VonMisesStress, 'Deformation', result.Displacement, 'DeformationScaleFactor', 5);
title('等效应力');
colorbar;

% x方向应力 σ_xx
figure;
pdeplot(model, 'XYData', result.Stress.sxx, 'Deformation', result.Displacement, 'DeformationScaleFactor', 5);
title('x方向应力（\sigma_{xx}）');
colorbar;

% y方向应力 σ_yy
figure;
pdeplot(model, 'XYData', result.Stress.syy, 'Deformation', result.Displacement, 'DeformationScaleFactor', 5);
title('y方向应力（\sigma_{yy}）');
colorbar;

% 剪应力 τ_xy
figure;
pdeplot(model, 'XYData', result.Stress.sxy, 'Deformation', result.Displacement, 'DeformationScaleFactor', 5);
title('剪应力（\tau_{xy}）');
colorbar;


