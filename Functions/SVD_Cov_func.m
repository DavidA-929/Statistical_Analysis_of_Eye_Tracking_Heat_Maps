
function [U,sqrt_Sigma] = SVD_Cov_func(grid_x, grid_y, Psi_bar, Psi_tensor, K_svds)

    % tensor size
    N = size(Psi_tensor,3);
    M2 = length(grid_x) * length(grid_y);

    V = zeros(M2,N);
    
    for i = 1:N
        % first value of v_i's
        psi_ie = inv_expo(grid_x,grid_y,Psi_bar,Psi_tensor(:,:,i));
        % tensor to hold all v_i * v_i'
        V(:,i) = psi_ie(:);
    end
    
    [U,sqrt_Sigma,~] = svds(V,K_svds);
end











