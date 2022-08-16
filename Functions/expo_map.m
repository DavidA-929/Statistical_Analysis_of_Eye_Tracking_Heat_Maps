
function result = expo_map(grid_x,grid_y,delta_Psi,Psi)

  % norm of point in tangent space
  norm_dpsi = sqrt(L2_dist(grid_x, grid_y, delta_Psi, delta_Psi));
  
  if (norm_dpsi == 0) 
      result=Psi;
  else
      Psi_expo = cos(norm_dpsi) .* Psi + (sin(norm_dpsi)/norm_dpsi) .* delta_Psi;
      result = Psi_expo/sqrt(trapz(grid_y,trapz(grid_x,Psi_expo.^2,2)));
  end
end

