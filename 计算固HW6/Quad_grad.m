function [val_xi, val_eta] = Quad_grad(aa, xi, eta)

if aa == 1
    val_xi  = -1/3 * (1-eta);
    val_eta = -1/3 * (1-xi);
elseif aa == 2
    val_xi  = -1/3 * (1-eta);
    val_eta = 1/3 * (1+xi);
elseif aa == 3
    val_xi  = 1/3 * (1+eta);
    val_eta = 1/3 * (1+xi);

else
    error('Error: value of a should be 1,2,or 3.');
end

% EOF