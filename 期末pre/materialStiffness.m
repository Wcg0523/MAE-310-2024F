function D = materialStiffness(E, nu, modelType)
    % E: 杨氏模量 (Young's Modulus)
    % nu: 泊松比 (Poisson's Ratio)
    % modelType: 'plane_stress' 或 'plane_strain'
    
    if nargin < 3
        error('需要指定材料模型类型：''plane_stress'' 或 ''plane_strain''');
    end
    
    % 初始化刚度矩阵
    switch modelType
        case 'plane_stress'  % 平面应力模型
            factor = E / (1 - nu^2);
            D = factor * [1, nu, 0;
                          nu, 1, 0;
                          0, 0, (1 - nu) / 2];
        case 'plane_strain'   % 平面应变模型
            factor = E / ((1 + nu) * (1 - 2 * nu));
            D = factor * [1 - nu, nu, 0;
                          nu, 1 - nu, 0;
                          0, 0, (1 - 2 * nu) / 2];
        otherwise
            error('未知的模型类型：请输入 ''plane_stress'' 或 ''plane_strain''');
    end
end
