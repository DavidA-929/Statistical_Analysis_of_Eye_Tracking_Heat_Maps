
function [Psi_bar_final, norm_vect] = Karcher(grid_x,grid_y,Psi_tensor,e1,e2)
   
    % tensor size
    n = size(Psi_tensor,3);
    % initial Psi_bar
    Psi_bar = Psi_tensor(:,:,1);
    
    M = 200;
    % variable to initialize while loop 
    norm_avg = zeros(M,1) + 10;
    iter=1;
    
    while norm_avg(iter) >= e1
        
        % update iteration
        iter=iter+1;
        
        % start the values that will be averaged
        avg_tensor = zeros(size(Psi_tensor));

        for i = 1:n
        % sum all direction vectors
        avg_tensor(:,:,i) = inv_expo(grid_x, grid_y, Psi_bar, Psi_tensor(:,:,i));
        end

        % average of all directions 
        Tang_avg = mean(avg_tensor, 3);

        norm_avg(iter) = sqrt(L2_dist(grid_x,grid_y,Tang_avg,Tang_avg));

        % update Psi_bar
        Psi_bar = expo_map(grid_x,grid_y,(e2 .* Tang_avg),Psi_bar);
        
        if norm_avg(iter) < e1
            break
        end
        
        if iter == M
            break 
        end
    end
    % if norm_avg < e1, stop and return last 
    Psi_bar_final = Psi_bar;
    norm_vect = norm_avg(2:iter);
    
end