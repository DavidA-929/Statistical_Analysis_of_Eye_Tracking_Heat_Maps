close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% load files needed
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

% split unique stimulus
split_trials = split(unique_trials,'_');
split_trials(:,end) = [];

trials_wo_part = join(split_trials,'_');

pipes = ["Pipe01", "Pipe02", "Pipe03", "Pipe04"];
aoi = ["base", "hose", "stem"];
label = ["lung", "mouth", "text"];

for l = 1:length(label)
    
    title_it = "Pipe";
    Mat1= [1;2;3;4];

    varaince_table = zeros(length(pipes),length(aoi));

    for j = 1:length(pipes)
        for k = 1:length(aoi)
            stims = strcat(pipes(j),'_',label(l),'_', aoi(k), '_partial.jpg');
            ix = ismember(uni_stim, stims);
            Psi_bar = X_Kar_mean(:,:,ix);

            ix_tensor = ismember(trials_wo_part,stims);
            Psi_tensor = sqrt_trial_tensor(:,:,ix_tensor);

            varaince_table(j,k) = round(sum_sqrd_dist(grid_x, grid_y, Psi_bar, Psi_tensor), 3);
        end
    end
    
    Mat1 = cat(2, Mat1, varaince_table);
  
    disp(label(l))
    karcher_variance = array2table(Mat1, "VariableNames", {'Pipe', 'Base', 'Hose', 'Stem'});
    disp(karcher_variance)

end
