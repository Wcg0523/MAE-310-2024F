clear all; clc; clf; % clean the memory, screen, and figure

% Problem definition
f = @(x) -20*x.^3; % f(x) is the source
g = 1.0;           % u = g  at x = 1
h = 0.0;           % -u,x = h  at x = 0

% Setup the mesh
pp_values = [2, 3]; 
n_el = 3;            
n_np = n_el * max(pp_values) + 1; 
n_eq = n_np - 1;    
n_int = 10;

hh = 1.0 / (n_np - 1); % space between two adjacent nodes
x_coor = 0 : hh : 1; % Nodal coordinates for equally spaced nodes

IEN = zeros(n_el, max(pp_values));
for ee = 1 : n_el
    for aa = 1 : max(pp_values)
        IEN(ee, aa) = (ee - 1) * max(pp_values) + aa;
    end
end

% Setup the ID array for the problem
ID = 1 : n_np;
ID(end) = 0;

% Setup the quadrature rule
[xi, weight] = Gauss(n_int, -1, 1);

% Allocate the stiffness matrix 
K = spalloc(n_eq, n_eq, (2*max(pp_values)+1)*n_eq);
F = zeros(n_eq, 1);


for pp = pp_values
    % Assembly of the stiffness matrix and load vector
    for ee = 1 : n_el
        k_ele = zeros(pp+1, pp+1); 
        f_ele = zeros(pp+1, 1);    
        x_ele = x_coor(IEN(ee,:)); 
        
        % Quadrature loop
        for qua = 1 : n_int
            dx_dxi = 0.0;
            x_l = 0.0;
            for aa = 1 : pp+1
                x_l = x_l + x_ele(aa) * PolyShape(pp, aa, xi(qua), 0);
                dx_dxi = dx_dxi + x_ele(aa) * PolyShape(pp, aa, xi(qua), 1);
            end
            dxi_dx = 1.0 / dx_dxi;

           for aa = 1 : pp+1
                f_ele(aa) = f_ele(aa) + weight(qua) * PolyShape(pp, aa, xi(qua), 0) * f(x_l) * dx_dxi;
                for bb = 1 : pp+1
                    k_ele(aa, bb) = k_ele(aa, bb) + weight(qua) * PolyShape(pp, aa, xi(qua), 1) * PolyShape(pp, bb, xi(qua), 1) * dxi_dx;
                end
            end
        end

        % Assembly of the matrix and vector based on the ID or LM data
        for aa = 1 : pp+1
            P = ID(IEN(ee,aa));
            if P > 0
                F(P) = F(P) + f_ele(aa);
                for bb = 1 : pp+1
                    Q = ID(IEN(ee,bb));
                    if Q > 0
                        K(P, Q) = K(P, Q) + k_ele(aa, bb);
                    else
                        F(P) = F(P) - k_ele(aa, bb) * g;
                    end
                end
            end
        end
    end

    F(ID(IEN(1,1))) = F(ID(IEN(1,1))) + h;

    % Solve the system Kd = F
    d_temp = K \ F;

    disp = [d_temp; g];

    n_sam = 20;
    xi_sam = -1 : (2/n_sam) : 1;
    x_sam = zeros(n_el * n_sam + 1, 1);
    u_sam = x_sam;
    y_sam = x_sam;  

    for ee = 1 : n_el
        x_ele = x_coor(IEN(ee, :));
        u_ele = disp(IEN(ee, :));

        if ee == n_el
            n_sam_end = n_sam + 1;
        else
            n_sam_end = n_sam;
        end

        for ll = 1 : n_sam_end
            x_l = 0.0;
            u_l = 0.0;
            for aa = 1 : pp+1
                x_l = x_l + x_ele(aa) * PolyShape(pp, aa, xi_sam(ll), 0);
                u_l = u_l + u_ele(aa) * PolyShape(pp, aa, xi_sam(ll), 0);
            end

            x_sam((ee-1)*n_sam + ll) = x_l;
            u_sam((ee-1)*n_sam + ll) = u_l;
            y_sam((ee-1)*n_sam + ll) = x_l^5; 
        end
    end

   
    figure;
    plot(x_sam, u_sam, '-r', 'LineWidth', 3);
    hold on;
    plot(x_sam, y_sam, '-k', 'LineWidth', 3);
    xlabel('x');
    ylabel('u(x)');
    title(['Solution with Polynomial Degree = ', num2str(pp)]);
    legend('Numerical Solution', 'Exact Solution');
end

% EOF
