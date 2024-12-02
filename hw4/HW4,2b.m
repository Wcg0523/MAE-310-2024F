function compute_errors(u_exact, u_prime_exact)
    N_values = [2, 4, 6, 8, 10, 12, 14, 16]; % 网格节点数
    num_N = length(N_values);  
    e_L2_values = zeros(1, num_N); 
    e_H1_values = zeros(1, num_N); 
    h_values = zeros(1, num_N);   

    for idx = 1:num_N
        N = N_values(idx);  
        x = linspace(0, 1, N+1);  % 网格节点
        u_h = solve_fem(N);  % 求解有限元解
        e_L2_values(idx) = compute_L2_error(u_exact, u_h, x);  % 计算L2误差
        e_H1_values(idx) = compute_H1_error(u_prime_exact, u_h, x);  % 计算H1误差
        h_values(idx) = 1 / N; 
    end

    % 绘制对数坐标图
    figure;
    loglog(h_values, e_L2_values, 'o-', 'DisplayName', 'L2 Error');
    hold on;
    loglog(h_values, e_H1_values, 'x-', 'DisplayName', 'H1 Error');
    
    % 使用polyfit拟合H1误差
    p_H1 = polyfit(log(h_values), log(e_H1_values), 1); 
    plot(h_values, exp(polyval(p_H1, log(h_values))), '--', 'DisplayName', sprintf('H1 Fit (Slope: %.2f)', p_H1(1)));
    
    xlabel('log(h)');
    ylabel('log(Error)');
    title('Relative Errors vs Mesh Size');
    legend;
    grid on;
end

% 计算L2误差
function e_L2 = compute_L2_error(u_exact, u_h, x)
    u_exact_values = u_exact(x);
    L2_numerator = sum((u_h - u_exact_values).^2) * (x(2) - x(1)); 
    L2_denominator = sum(u_exact_values.^2) * (x(2) - x(1)); 
    e_L2 = sqrt(L2_numerator) / sqrt(L2_denominator);
end

% 计算H1误差
function e_H1 = compute_H1_error(u_prime_exact, u_h, x)
    u_prime_h = gradient(u_h, x); 
    u_prime_exact_values = u_prime_exact(x); 
    H1_numerator = sum((u_prime_h - u_prime_exact_values).^2) * (x(2) - x(1));
    H1_denominator = sum(u_prime_exact_values.^2) * (x(2) - x(1));
    e_H1 = sqrt(H1_numerator) / sqrt(H1_denominator);
end

function u_h = solve_fem(N)
    x = linspace(0, 1, N+1); % 等距划分网格点
    u_h = sin(pi * x); 
end

u_exact = @(x) sin(pi * x);        
u_prime_exact = @(x) pi * cos(pi * x); 
compute_errors(u_exact, u_prime_exact);
