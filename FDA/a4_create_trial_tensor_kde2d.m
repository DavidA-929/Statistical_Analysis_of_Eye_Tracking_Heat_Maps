clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% load files
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
load(append(mat_path,'normed_coordinate_mat'))
load(append(mat_path,'unique_trials'))

% make grid to evaluate KS density
n = 2^7;
grid_x = linspace(0,1, n);
grid_y = linspace(0,1, n);

uni_trial_tensor = zeros(length(grid_y), length(grid_x), length(unique_trials));

% trial names corresponding to eye coordinates
coordinate_mat_names_col = normed_coordinate_mat.trial;
normed_coordinate_mat.trial = [];
normed_coordinate_mat = table2array(normed_coordinate_mat);

bw_vect_kde2d = zeros(length(unique_trials),2);

for i = 1:length(unique_trials)
    % (x,y) coordinated for ith trial
    X = normed_coordinate_mat(coordinate_mat_names_col == unique_trials(i) ,1:2);
    
    [bw,f2, ~, ~] = kde2d(X, n, [0,0], [1,1]);
    uni_trial_tensor(:,:,i) = f2;

    bw_vect_kde2d(i,:) = bw;
end

s = size(uni_trial_tensor,3)/3;
uni_trial_tensor_1st = uni_trial_tensor(:,:,1:s);
uni_trial_tensor_2nd = uni_trial_tensor(:,:,(s+1):2*s);
uni_trial_tensor_3rd = uni_trial_tensor(:,:,(2*s+1):3*s);


sqrt_trial_tensor = zeros(length(grid_y), length(grid_x), length(unique_trials));

for i = 1:length(unique_trials)
    Psi = sqrt(uni_trial_tensor(:,:,i));
    sqrt_trial_tensor(:,:,i) = Psi/sqrt(trapz(grid_y,trapz(grid_x,Psi.^2,2)));
end

sqrt_trial_tensor_1st = sqrt_trial_tensor(:,:,1:s);
sqrt_trial_tensor_2nd = sqrt_trial_tensor(:,:,(s+1):2*s);
sqrt_trial_tensor_3rd = sqrt_trial_tensor(:,:,(2*s+1):3*s);


% save tensor in .mat file
save(append(mat_path,'uni_trial_tensor_kde2d'),'uni_trial_tensor_1st','uni_trial_tensor_2nd','uni_trial_tensor_3rd')

save(append(mat_path,'uni_trial_tensor_params_kde2d'),'grid_x','grid_y')

save(append(mat_path,'sqrt_trial_tensor_kde2d'),'sqrt_trial_tensor_1st', 'sqrt_trial_tensor_2nd','sqrt_trial_tensor_3rd')
save(append(mat_path,'bw_vect_kde2d'),'bw_vect_kde2d')

