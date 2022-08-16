
function result = L2_dist(grid_x, grid_y, Psi_1, Psi_2)

    % component-wise multiplication
    Psi = Psi_1 .* Psi_2;
    % integrate over grid
    result = trapz(grid_y,trapz(grid_x,Psi,2));
 
end