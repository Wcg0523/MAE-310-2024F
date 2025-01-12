
clear; clc;

R = 1; % 圆孔半径
L = 4 * R; % 矩形边长
Tx = 1e6; % 远场拉伸应力
E = 10e9; % 弹性模量
nu = 0.3; % 泊松比

% 网格尺寸
h_values = [0.5, 0.25, 0.1]; % 不同网格的细化尺寸
L2_errors = zeros(length(h_values), 1);

% 平面应力问题的解析应力场
sigma_rr = @(r, theta) Tx/2 * (1 - R^2 ./ r.^2) + ...
    Tx/2 * (1 - 4 * R^2 ./ r.^2 + 3 * R^4 ./ r.^4) .* cos(2 * theta);
sigma_tt = @(r, theta) Tx/2 * (1 + R^2 ./ r.^2) - ...
    Tx/2 * (1 + 3 * R^4 ./ r.^4) .* cos(2 * theta);
sigma_rt = @(r, theta) -Tx/2 * (1 + 2 * R^2 ./ r.^2 - 3 * R^4 ./ r.^4) .* sin(2 * theta);

% 循环测试不同网格尺寸
for h_index = 1:length(h_values)
    Hmax = h_values(h_index);
    
    % 创建 PDE 模型
    model = createpde('structural', 'static-planestress');
    
    % 定义几何区域：大矩形减去内圆
    rect = [3, 4, -L/2, L/2, L/2, -L/2, -L/2, -L/2, L/2, L/2]';
    circle = [1; 0; 0; R; 0; 0; 0; 0];
    circle = [circle; zeros(size(rect, 1) - size(circle, 1), 1)]; % 补齐行数
    gd = [rect, circle];
    ns = char('rect', 'circ')';
    sf = 'rect-circ';
    g = decsg(gd, sf, ns);
    geometryFromEdges(model, g);
    
    % 网格生成
    generateMesh(model, 'Hmax', Hmax);
    
    % 可视化网格
    figure;
    pdeplot(model);
    title(['网格（Hmax = ', num2str(Hmax), '）']);
    
    % 定义材料属性
    structuralProperties(model, 'YoungsModulus', E, 'PoissonsRatio', nu);
    
    % 圆孔边界：sigma_rr = 0
    structuralBoundaryLoad(model, 'Edge', 2, 'Pressure', 0);
    
    % 外边界：施加远场应力 Tx
    structuralBoundaryLoad(model, 'Edge', [3, 4], 'SurfaceTraction', [Tx, 0]); % 左右两侧拉伸
    
    % 刚体运动约束：固定矩形左侧中点的位移为零
    structuralBC(model, 'Vertex', 1, 'XDisplacement', 0, 'YDisplacement', 0);
    
    result = solve(model);
    u = result.Displacement; % 位移解
    
    % 提取有限元计算应力
    stress = result.VonMisesStress;
    
    % L2 误差：有限元应力和解析应力的对比
    L2_errors(h_index) = computeL2Error(u, sigma_rr, sigma_tt, sigma_rt, model, R);
end

convergence_rates_L2 = zeros(length(L2_errors)-1, 1);

for i = 1:length(L2_errors)-1
    % L2 收敛率
    convergence_rates_L2(i) = log(L2_errors(i) / L2_errors(i+1)) / log(h_values(i) / h_values(i+1));
end

% 结果输出
disp('L2 Errors:');
disp(L2_errors);


disp('Convergence Rates for L2 Norm:');
disp(convergence_rates_L2);

function L2_error = computeL2Error(u, sigma_rr, sigma_tt, sigma_rt, model, R)
    % 提取节点坐标
    nodes = model.Mesh.Nodes;
    x = nodes(1, :);
    y = nodes(2, :);
    
    % 计算极坐标
    [theta, r] = cart2pol(x, y);
    
    % 解析解应力
    sigma_rr_exact = sigma_rr(r, theta);
    sigma_tt_exact = sigma_tt(r, theta);
    sigma_rt_exact = sigma_rt(r, theta);
    
    % 假设 u 是结构体，提取 X 和 Y 位移分量
    ux = u.ux;
    uy = u.uy;
   
    L2_error = sqrt(sum((ux.^2 + uy.^2))); 
end


