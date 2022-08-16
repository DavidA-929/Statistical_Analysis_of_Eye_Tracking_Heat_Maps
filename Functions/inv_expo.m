

function result = inv_expo(grid_x,grid_y,Psi_1,Psi_2)

    % arc length between points in unit Hilbert Sphere
  theta = dist_FR(grid_x,grid_y,Psi_1,Psi_2);
 
  if (theta == 0) 
      result = zeros(length(grid_y),length(grid_x));
  else
      result = (theta/sin(theta)).*(Psi_2 - cos(theta).*Psi_1) ;
  end
 
end