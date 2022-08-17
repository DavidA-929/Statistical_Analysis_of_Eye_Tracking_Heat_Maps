close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
AOI_source = append(join([wp_dir, "Images", "Hookah Images"], char_split), char_split);

% functions folder to path
addpath(functions_path)
load(append(mat_path, "uni_stim"))
load(append(mat_path, "X_Kar_mean"))
load(append(mat_path, "participants"))
load(append(mat_path, "normed_coordinate_mat"))
load(append(mat_path, "unique_trials"))
load(append(mat_path,'uni_trial_tensor_params'))
load(append(mat_path,'sqrt_trial_tensor_1st'))
load(append(mat_path,'sqrt_trial_tensor_2nd'))
load(append(mat_path,'sqrt_trial_tensor_3rd'))
sqrt_trial_tensor = cat(3, sqrt_trial_tensor_1st, sqrt_trial_tensor_2nd, sqrt_trial_tensor_3rd);
clear sqrt_trial_tensor_1st sqrt_trial_tensor_2nd sqrt_trial_tensor_3rd


P_lab = ["Pipe01_lung_base_partial.jpg", "Pipe01_lung_stem_partial.jpg"];
P12 = ["Pipe01_lung_base_partial.jpg_163", "Pipe01_lung_stem_partial.jpg_179"];


figs_names = ["Pipe01_lung_base_partial.jpg", "Pipe01_lung_stem_partial.jpg",...
    "Pipe02_lung_base_partial.jpg", "Pipe01_no_label_partial.jpg", ...
    "Pipe02_no_label_partial.jpg", "Pipe03_no_label_partial.jpg", ...
    "Pipe04_no_label_partial.jpg"];

dist_vals = [0, 0];
P_no_lab = "Pipe01_no_label_partial.jpg";
index = ismember(unique_trials, P12);

Psi_bar_4path = sqrt_trial_tensor(:,:,index);

P1 = Psi_bar_4path(:,:,1);
P2 = Psi_bar_4path(:,:,2);


% get distance betwen P1 and P2
theta = dist_FR(grid_x, grid_y, P1, P2);
dist_vals(1) = theta;

% create single inpuit function
g = @(x) geo_path(x, theta, P1, P2);

path_len = 5;
t_path = linspace(0,1,path_len);
Psi_path = arrayfun(g, t_path,'UniformOutput', false);

x = [0 1];
y = [0 1];


j= 0;
for i=1:path_len
    
    j= j+1;
    z_values = Psi_path{i}.^2;
    
    % cut off value
    cut_off = prctile(z_values(:), 90);
    z_values(z_values < cut_off) = NaN;

    % transparancy
    W = z_values;
    W(~isnan(z_values)) = .85;
    W(isnan(z_values)) = 0;

     if i == 1
        pipe_name = P_lab(1);
    elseif i == path_len
        pipe_name = P_lab(2);
    else
        pipe_name = P_no_lab;
    end
        
    figure(100 + j);clf;
    I=imread(append(AOI_source, pipe_name));
    imagesc(x, y, I);
    set(gca,'visible','off')
    axis square
    hold on
    A = imagesc(x, y, z_values);
    set(A,'alphadata',W);    
    hold off

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% geodesic
id = ["102", "107"];


P_lab = ["Pipe02_lung_base_partial.jpg", "Pipe02_lung_base_partial.jpg"];
P12 = ["Pipe02_lung_base_partial.jpg_134", "Pipe02_lung_base_partial.jpg_163"];

% 104, 110, 134
P_no_lab = "Pipe02_no_label_partial.jpg";
index = ismember(unique_trials, P12);

Psi_bar_4path = sqrt_trial_tensor(:,:,index);

P1 = Psi_bar_4path(:,:,1);
P2 = Psi_bar_4path(:,:,2);


% get distance betwen P1 and P2
theta = dist_FR(grid_x, grid_y, P1, P2);
dist_vals(2) = theta;

% create single inpuit function
g = @(x) geo_path(x, theta, P1, P2);

path_len = 5;
t_path = linspace(0,1,path_len);
Psi_path = arrayfun(g, t_path,'UniformOutput', false);


j=0;
for i=1:path_len
    j= j +1;
    z_values = Psi_path{i}.^2;
    
    % cut off value
    cut_off = prctile(z_values(:), 90);
    z_values(z_values < cut_off) = NaN;

    % transparancy
    W = z_values;
    W(~isnan(z_values)) = .85;
    W(isnan(z_values)) = 0;



     if i == 1
        pipe_name = P_lab(1);
    elseif i == path_len
        pipe_name = P_lab(2);
    else
        pipe_name = P_no_lab;
    end
        
    figure(200 + j);clf;
    I=imread(append(AOI_source, pipe_name));
    imagesc(x, y, I);
    set(gca,'visible','off')
    axis square
    hold on
    A = imagesc(x, y, z_values);
    set(A,'alphadata',W);    
    hold off
   
    
end


disp(dist_vals)

