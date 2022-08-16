function result = dist_mat_func_euclid(tensor)

    % dimension of distance matrix
    n = size(tensor, 3);

    % distance matrix
    dist_matrix = zeros(n,n);
    
    for j = 1:(n-1)
        % jth row sqrt pdf
        X_1 = tensor(:,:,j);
        % total vaules that require distances to be calculated
        L = n - j;
     
        for l = 1:L
            X_2 = tensor(:,:,j+l); 
            % obtain distance between Psi_1 and Psi_2
            dist_matrix(j,(j+l)) = norm((X_1-X_2), "fro");
        end
    end

    % add transpose to complete matrix
    result = dist_matrix + dist_matrix';
end