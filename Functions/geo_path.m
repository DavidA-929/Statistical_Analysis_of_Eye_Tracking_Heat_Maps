function alpha_t = geo_path(t, theta, Psi_1, Psi_2)

    alpha_t = (sin(theta.*(1-t)).*Psi_1 + sin(theta.*t).*Psi_2)/sin(theta);
end