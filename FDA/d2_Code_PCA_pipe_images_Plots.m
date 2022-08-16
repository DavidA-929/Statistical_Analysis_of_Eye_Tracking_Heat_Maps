close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% Implementing PCA

% .mat files path
functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
AOI_source= append(join([wp_dir, "Images", "Hookah Images"], char_split), char_split);
pca_source = append(join([wp_dir, "Images", "PCA Results"], char_split), char_split);


% load pipe images
addpath(functions_path)
load(append(mat_path, "uni_stim"))
load(append(mat_path, "U_tensor"))
load(append(mat_path, "sqrt_Sigma_mat"))
load(append(mat_path, "X_Kar_mean"))
load(append(mat_path, "uni_trial_tensor_params"))
load(append(mat_path, "ix_partial"))

% time
t = linspace(-0.1,0.1, 5);

% total direction
tot_directions = 3;
font_size = 15;
            
% check quadrants sign
Quadrant2_matrix = zeros(length(uni_stim),length(t),tot_directions);

for i = ix_partial
    
    % first direction
    I=imread(append(AOI_source,uni_stim(i)));
    
    jk_th_plot = 0; 
    Psi_bar = X_Kar_mean(:,:,i);
    
    figure(100);
    set(gcf, 'Position', get(0, 'Screensize'));
    for k=1:tot_directions
 
        U_k = reshape(U_tensor(:,k,i), length(grid_x), length(grid_y));
    
        for j = 1:length(t)
            
            jk_th_plot = jk_th_plot + 1;

            if t(j) ~= 0
                sd_x_t =expo_map(grid_x, grid_y, (t(j).* sqrt_Sigma_mat(i,k) .* U_k), Psi_bar);
            else
                sd_x_t = Psi_bar;
            end

            % check if exponential map is in first quadrant
            Quadrant2_matrix(i,j,k) = sum((sd_x_t < 0), 'all');

            z_values = sd_x_t.^2;
            % cut off value
            cut_off = prctile(z_values(:), 90);
            z_values(z_values < cut_off) = NaN;

            % transparancy
            W = z_values;
            W(~isnan(z_values)) = .75;
            W(isnan(z_values)) = 0;

            x = [0 1];
            y = [0 1];

            subplot(tot_directions, length(t), jk_th_plot),
            imagesc(x,y, I);
            hold on
            axis square
            set(gca,'visible','off')
            A = imagesc(x,y,z_values);
            set(A,'alphadata',W);
            hold off
             
        end
    end
    title_fig = strcat('PCA_', uni_stim(i));
    exportgraphics(gcf, append(pca_source, title_fig))
end

