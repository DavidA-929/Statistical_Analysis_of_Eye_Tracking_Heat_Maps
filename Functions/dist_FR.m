
function theta = dist_FR(grid_x,grid_y,Psi_1,Psi_2)

    % component-wise multiplication
    Psi = Psi_1 .* Psi_2;
    % integrate over grid
    trap_integral = trapz(grid_y,trapz(grid_x,Psi,2));
    % angle
    theta = acos(trap_integral);
 
end