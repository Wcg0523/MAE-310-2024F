function [L2_error, H1_error] = compute_error(u_h, u_exact, grad_u_h, grad_u_exact, mesh)
 
    L2_error = 0;
    H1_error = 0;
    
    for i = 1:length(mesh.elements)
        nodes = mesh.elements(i, :); 
        coords = mesh.nodes(nodes, :);  
        
        for j = 1:length(coords)
         
            u_h_at_qp = u_h(nodes(j));  
            u_exact_at_qp = u_exact(coords(j, 1), coords(j, 2));  
            
            grad_u_h_at_qp = grad_u_h(nodes(j), :); 
            grad_u_exact_at_qp = grad_u_exact(coords(j, 1), coords(j, 2)); 
            
            L2_error = L2_error + (u_h_at_qp - u_exact_at_qp)^2;
           
            grad_error = norm(grad_u_h_at_qp - grad_u_exact_at_qp)^2;
            H1_error = H1_error + (u_h_at_qp - u_exact_at_qp)^2 + grad_error;
        end
    end
   
    L2_error = sqrt(L2_error);
    H1_error = sqrt(H1_error);
end
