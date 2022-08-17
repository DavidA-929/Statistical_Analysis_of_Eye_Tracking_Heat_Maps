clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

%%%%%%% calculate and save karcher means in mat file with name X_Kar_mean %%%%%%%
functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
distance_matrix_source = join([wp_dir, "Data Files", "Distance-Matrices-csv", "dist_matrix_"], char_split);
distance_matrix_source_euclid = join([wp_dir, "Data Files","Euclidean Distance Matrices-csv", "euclid_dist_matrix_"], char_split);

addpath(functions_path)
load(append(mat_path, "participants"))
load(append(mat_path, "unique_trials"))
load(append(mat_path, "uni_images"))
load(append(mat_path, "uni_images_wo_aoi"))
load(append(mat_path,'uni_trial_tensor_params'))
load(append(mat_path,'sqrt_trial_tensor_1st'))
load(append(mat_path,'sqrt_trial_tensor_2nd'))
load(append(mat_path,'sqrt_trial_tensor_3rd'))
load(append(mat_path,'uni_trial_tensor_1st'))
load(append(mat_path,'uni_trial_tensor_2nd'))
load(append(mat_path,'uni_trial_tensor_3rd'))
load(append(mat_path,'ix_partial_ims'))

sqrt_trial_tensor = cat(3, sqrt_trial_tensor_1st, sqrt_trial_tensor_2nd, sqrt_trial_tensor_3rd);
clear 'sqrt_trial_tensor_1st' 'sqrt_trial_tensor_2nd' 'sqrt_trial_tensor_3rd'
uni_trial_tensor = cat(3, uni_trial_tensor_1st, uni_trial_tensor_2nd, uni_trial_tensor_3rd);
clear 'uni_trial_tensor_1st' 'uni_trial_tensor_2nd' 'uni_trial_tensor_3rd'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aoi = ["base", "hose", "stem"];



for i = ix_partial_ims
    % obtain the unique trial names for distance matrix
    split2 = split(uni_images(i), '_');
    image_i_aoi = strcat(split2(1),'_', split2(2),'_', aoi', '_', split2(4));

    distmat_parts = [];
    for k = 1:length(aoi)
        distmat_parts = cat(1,distmat_parts,strcat(image_i_aoi(k),'_',participants));
    end

    ix = ismember(unique_trials, distmat_parts);

    dist_matrix_names = unique_trials(ix);
    % add transpose to complete matrix
    full_dist_matrix = dist_mat_func(grid_x, grid_y, sqrt_trial_tensor(:,:,ix));
    
    % save ith distance matrix
    save_dist = array2table(full_dist_matrix,'VariableNames',cellstr(dist_matrix_names));
    save_dist.row_names = dist_matrix_names;
    save_dist = movevars(save_dist,'row_names','Before',dist_matrix_names(1));
    
    writetable(save_dist, append(distance_matrix_source, uni_images_wo_aoi(i), ".csv"))
    
    % euclidean distance
    full_dist_matrix2 = dist_mat_func_euclid(uni_trial_tensor(:,:,ix));
    save_dist2 = array2table(full_dist_matrix2,'VariableNames',cellstr(dist_matrix_names));
    save_dist2.row_names = dist_matrix_names;
    save_dist2 = movevars(save_dist2,'row_names','Before',dist_matrix_names(1));
    writetable(save_dist2, append(distance_matrix_source_euclid, uni_images_wo_aoi(i), ".csv"))
end


