clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

%%%%%%% calculate and save karcher means in mat file with name X_Kar_mean %%%%%%%
functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% load files
addpath(functions_path)
load(append(mat_path, "participants"))
load(append(mat_path, "unique_trials"))
load(append(mat_path, "uni_stim"))
load(append(mat_path,'uni_trial_tensor_params'))
load(append(mat_path,'sqrt_trial_tensor_1st'))
load(append(mat_path,'sqrt_trial_tensor_2nd'))
load(append(mat_path,'sqrt_trial_tensor_3rd'))
load(append(mat_path,'uni_trial_tensor_1st'))
load(append(mat_path,'uni_trial_tensor_2nd'))
load(append(mat_path,'uni_trial_tensor_3rd'))



% uni_trial concatination
uni_trial_tensor = cat(3, uni_trial_tensor_1st, uni_trial_tensor_2nd, uni_trial_tensor_3rd);
clear 'uni_trial_tensor_1st' 'uni_trial_tensor_2nd' 'uni_trial_tensor_3rd'

sqrt_trial_tensor = cat(3, sqrt_trial_tensor_1st, sqrt_trial_tensor_2nd, sqrt_trial_tensor_3rd);
clear 'sqrt_trial_tensor_1st' 'sqrt_trial_tensor_2nd' 'sqrt_trial_tensor_3rd'


% save all Karcher means
X_Kar_mean = zeros(length(grid_y), length(grid_x), length(uni_stim));
split_trials = split(unique_trials, '_');
trials_wo_parts = join(split_trials(:,1:(end-1)), '_');

% Euclidean means
Euclid_mean = zeros(length(grid_y), length(grid_x), length(uni_stim));

for i = 1:length(uni_stim)

    ix = ismember(trials_wo_parts, uni_stim(i));

    Psi_tensor = sqrt_trial_tensor(:,:,ix);
    f_tensor = uni_trial_tensor(:,:,ix);
    % apply karcher mean function
    e1 = 1e-10;
    e2 = 1;
    [Psi_bar_final, norm_vect] = Karcher(grid_x, grid_y, Psi_tensor, e1, e2); 
    X_Kar_mean(:,:,i) = Psi_bar_final; 

    % check convergence of Karcher mean Algorithm
    %figure(1000);
    %plot(norm_vect)
    
    % get pointwise mean
    Euclid_mean(:,:,i) = mean(f_tensor,3);
end

% save karcher means for each 
save(append(mat_path,'X_Kar_mean'),'X_Kar_mean')
% save karcher means for each 
save(append(mat_path,'Euclid_mean'),'Euclid_mean')
