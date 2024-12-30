
mesh_sizes = [];
L2_errors_quad = [];
H1_errors_quad = [];
L2_errors_tri = [];
H1_errors_tri = [];

for refinement = 1:5
 
    [mesh_quad, mesh_tri] = generate_mesh(refinement); 
    
    u_h_quad = solve_FEM(mesh_quad); 
    u_h_tri = solve_FEM(mesh_tri); 
    
    % 计算四边形单元的误差
    [L2_error_quad, H1_error_quad] = compute_error(u_h_quad, exact_solution, grad_u_h_quad, grad_u_exact_quad, mesh_quad);
    L2_errors_quad = [L2_errors_quad, L2_error_quad];
    H1_errors_quad = [H1_errors_quad, H1_error_quad];
    
    % 计算三角形单元的误差
    [L2_error_tri, H1_error_tri] = compute_error(u_h_tri, exact_solution, grad_u_h_tri, grad_u_exact_tri, mesh_tri);
    L2_errors_tri = [L2_errors_tri, L2_error_tri];
    H1_errors_tri = [H1_errors_tri, H1_error_tri];
    
    mesh_sizes = [mesh_sizes, mesh_quad.size];
end

% 对数-对数图（收敛性分析）
figure;
loglog(mesh_sizes, L2_errors_quad, '-o', 'DisplayName', '四边形 L2 误差');
hold on;
loglog(mesh_sizes, H1_errors_quad, '-x', 'DisplayName', '四边形 H1 误差');
loglog(mesh_sizes, L2_errors_tri, '-o', 'DisplayName', '三角形 L2 误差');
loglog(mesh_sizes, H1_errors_tri, '-x', 'DisplayName', '三角形 H1 误差');
xlabel('网格大小 (h)');
ylabel('误差');
legend show;
title('FEM 方法收敛性分析');
