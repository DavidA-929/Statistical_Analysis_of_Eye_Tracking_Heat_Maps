function result = dist_mat_func(grid_x, grid_y, Psi_tensor)

    % dimension of distance matrix
    n = size(Psi_tensor, 3);

    % distance matrix
    dist_matrix = zeros(n,n);
    
    for j = 1:(n-1)
        % jth row sqrt pdf
        Psi_1 = Psi_tensor(:,:,j);
        % total vaules that require distances to be calculated
        L = n - j;
     
        for l = 1:L
            Psi_2 = Psi_tensor(:,:,j+l); 
            % obtain distance between Psi_1 and Psi_2
            dist_matrix(j,(j+l)) = dist_FR(grid_x,grid_y,Psi_1,Psi_2);
        end
    end

    % add transpose to complete matrix
    result = dist_matrix + dist_matrix';
end