clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% load files
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
load(append(mat_path, "RawData2"))
load(append(mat_path, "unique_trials_full"))

% initialize eye coordinate matrix
trial_names = [];
coordinate_mat = [];
deleted_trials = [];

for i = 1:length(unique_trials_full)
    % for ith trial get x and y coordinated and original row index
    Raw2 = RawData2(RawData2.Unique_Trial == unique_trials_full(i),{'PointofRegardRightXpx','PointofRegardRightYpx','Rows'});

    %convert to array
    X = table2array(Raw2(:,1:2));
    del = X(:,1)<=0 | isnan(X(:,1)) | X(:,1) >= 1280 |...
          X(:,2)<=0 | isnan(X(:,2)) | X(:,2) >= 1024;

      
    if sum(del) > size(X,1)*0.80 
        deleted_trials = cat(1,deleted_trials,unique_trials_full(i));
        continue;
    else 
        %get rid of zeros and NAs
        X(del ,:)=[];
    end
    
    coordinate_mat = cat(1,coordinate_mat,X);
    trial_names = cat(1,trial_names,repelem(unique_trials_full(i),size(X,1))');
end


coordinate_mat = array2table(coordinate_mat);
coordinate_mat.trial = trial_names;

coordinate_mat.Properties.VariableNames = {'X', 'Y' 'trial'};
save(append(mat_path,'coordinate_mat'),  'coordinate_mat')
save(append(mat_path,'deleted_trials'),  'deleted_trials')

unique_trials = unique(trial_names);
save(append(mat_path, "unique_trials"), 'unique_trials')

%%%%%%%%%%%%%%%%%%%%%%%%% standardize to [0,1]^2 %%%%%%%%%%%%%%%%%%%%%%%%%

% get x and y coordinates for all trials 
XY_coords = table2array(coordinate_mat(:,1:2));

% normed eye coordinated 
normed_coordinate_mat = array2table(XY_coords./[1280 1024]);
normed_coordinate_mat.trial = trial_names;
normed_coordinate_mat.Properties.VariableNames = {'X', 'Y' 'trial'};

save(append(mat_path,'normed_coordinate_mat'),  'normed_coordinate_mat')



