close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% add functions folder to path
functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% load trial names and stimulus names 
addpath(functions_path)
load(append(mat_path, "uni_stim"))
load(append(mat_path, "unique_trials"))
load(append(mat_path, "uni_trial_tensor_params"))

load(append(mat_path,'X_Kar_mean'))
% load trial tensor
load(append(mat_path,'sqrt_trial_tensor_1st'))
load(append(mat_path,'sqrt_trial_tensor_2nd'))
load(append(mat_path,'sqrt_trial_tensor_3rd'))

sqrt_trial_tensor = cat(3, sqrt_trial_tensor_1st, sqrt_trial_tensor_2nd, sqrt_trial_tensor_3rd);
clear sqrt_trial_tensor_1st sqrt_trial_tensor_2nd sqrt_trial_tensor_3rd


% split unque trials
split_trials = split(unique_trials,"_");
split_trials(:,end) = [];

unique_trials_wo_part = join(split_trials, "_");

K_svds = 10;
M = length(uni_stim);
N2 = length(grid_x) * length(grid_y);
U_tensor = zeros(N2, K_svds, M);
sqrt_Sigma_mat = zeros(M, K_svds);

for i = 1:M
    % get index for unique trials for ith stimulus
    index_stim = ismember(unique_trials_wo_part, uni_stim(i));

    Psi_tensor = sqrt_trial_tensor(:,:,index_stim);

    % karcher mean
    Psi_bar = X_Kar_mean(:,:,i);

    % using covariance function: Elapsed time is 7.211489 seconds
    [U, sqrt_Sigma] = SVD_Cov_func(grid_x, grid_y, Psi_bar, Psi_tensor, K_svds);
  
    U_tensor(:,:,i) = U;
    sqrt_Sigma_mat(i,:) = diag(sqrt_Sigma); 
end


save(append(mat_path, 'U_tensor'), 'U_tensor')
save(append(mat_path, 'sqrt_Sigma_mat'), 'sqrt_Sigma_mat')               


%%%%%%%%%%%%%%%%%%%%%%%% test svd function %%%%%%%%%%%%%%%%%%%%%%%%
A = [1 4; 3 7; 4 8];
B = A * A';

% S.^2 should equal S2
[U,S,V] = svd(A);
[U2,S2,V2] = svd(A * A');


% A2 should equal A
A2 = U * S * V';

% B2 should equal B
B2 = U * (S * S') * U';

% U2 and U should be apporximately the same 
diff_Us = U2 - U;
