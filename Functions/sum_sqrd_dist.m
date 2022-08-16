
function result = sum_sqrd_dist(grid_x, grid_y, Psi_bar, Psi_tensor)

    
    dist_vect = zeros(size(Psi_tensor,3),1);
    for i = 1:length(dist_vect)
        dist_vect(i) = dist_FR(grid_x, grid_y, Psi_bar, Psi_tensor(:,:,i));
    end
     
      result = sum(dist_vect.^2)/length(dist_vect);

end




