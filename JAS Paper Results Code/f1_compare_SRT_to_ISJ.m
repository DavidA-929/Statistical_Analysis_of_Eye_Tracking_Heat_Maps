close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% functions folder to path
functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
AOI_source= append(join([wp_dir, "Images", "Hookah Images"], char_split), char_split);


% bandwith info for (silvermans rule of thumb) SRT and (Improved Seather-Jones) ISJ methods
addpath(functions_path)
load(append(mat_path, "uni_stim"))
load(append(mat_path, "participants"))
load(append(mat_path, "normed_coordinate_mat"))
load(append(mat_path, "unique_trials"))
load(append(mat_path,'bw_vect_ksdensity'))

load(append(mat_path,'uni_trial_tensor_1st'))
load(append(mat_path,'uni_trial_tensor_2nd'))
load(append(mat_path,'uni_trial_tensor_3rd'))
uni_trial_tensor = cat(3, uni_trial_tensor_1st, uni_trial_tensor_2nd, uni_trial_tensor_3rd);
clear uni_trial_tensor_1st uni_trial_tensor_2nd uni_trial_tensor_3rd

i = 2;

% get image to plot
I = imread(append(AOI_source,uni_stim(i)));

id = ["102", "103", "107"];

fig_it = 0;

bw_method = ["SRT", "ISJ"];
bw_results = zeros(length(id), 4);


% make grid to evaluate KS density (ISJ method)
n = 2^7;
grid_x = linspace(0,1, n);
grid_y = linspace(0,1, n);
uni_trial_tensor_kde2d = zeros(length(grid_y), length(grid_x), length(unique_trials));
% trial names corresponding to eye coordinates
coordinate_mat_names_col = normed_coordinate_mat.trial;
normed_coordinate_mat.trial = [];
bw_vect_kde2d = zeros(length(unique_trials),2);
m = 1:length(unique_trials);


for k = 1:length(id)
    trial = strcat(uni_stim(i), "_", id(k));

    coords = normed_coordinate_mat(coordinate_mat_names_col == trial,1:2);

    x = [0 1];
    y = [0 1];

    fig_it =  fig_it + 1;
    figure(fig_it);clf;
    imagesc(x,y,I);
    set(gca,'visible','off')
    hold on
    axis square
    plot(coords.X, coords.Y, 'y*')
    fig_it =  fig_it + 1;



    trial_ix = unique_trials == trial;
    for j = m(trial_ix)
        % (x,y) coordinated for ith trial
        X = table2array(normed_coordinate_mat(coordinate_mat_names_col == unique_trials(j) ,1:2));
        [bw,f2, ~, ~] = kde2d(X, n, [0,0], [1,1]);
        uni_trial_tensor_kde2d(:,:,j) = f2;
        bw_vect_kde2d(j,:) = bw;
    end



    KDE_mat = {uni_trial_tensor(:,:, trial_ix), uni_trial_tensor_kde2d(:,:, trial_ix)};
    bw_mat = {bw_vect_ksdensity(trial_ix,:), bw_vect_kde2d(trial_ix,:)};
    
    for l = 1:2

        bw_results(k, (2*l-1):2*l)= bw_mat{1,l};

        % KDE for participant
        z_values = KDE_mat{1,l};
        % cut off value
        cut_off = prctile(z_values(:), 90);
        z_values(z_values < cut_off) = NaN;
    
        % transparancy
        W = z_values;
        W(~isnan(z_values)) = .75;
        W(isnan(z_values)) = 0;
    
    
        fig_it =  fig_it + 1;
        figure(fig_it);clf;
        imagesc(x,y, I);
        set(gca,'visible','off')
        axis square
        hold on
        A = imagesc(x,y,z_values);
        set(A,'alphadata',W);
        hold off
    end
end

disp(bw_results)


