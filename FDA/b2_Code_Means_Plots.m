close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

%%%%%%% calculate and save karcher means in mat file with name X_Kar_mean %%%%%%%
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% code to save karcher mean plots
AOI_source =  append(join([wp_dir, "Images", "Hookah Images"], char_split), char_split);
Karcher_mean_source = join([wp_dir, "Images", "Karcher Means", "K_m_plot_"], char_split);
Euclidean_mean_source = join([wp_dir, "Images", "Euclidean Means", "Euclid_plot_"], char_split);

% load files
load(append(mat_path, "uni_stim"))
load(append(mat_path,'X_Kar_mean'))
load(append(mat_path,'Euclid_mean'))
load(append(mat_path,'ix_partial'))

for i=ix_partial
    % get image to plot
    I = imread(append(AOI_source, uni_stim(i)));
    
    z_values = X_Kar_mean(:,:,i);
    % cut off value
    cut_off = prctile(z_values(:), 90);
    z_values(z_values < cut_off) = NaN;


    W = z_values;
    W(~isnan(z_values)) = .75;
    W(isnan(z_values)) = 0;


    axis_lims = [0 1];

    figure(1000);
    imagesc(axis_lims, axis_lims, I);
    set(gca,'visible','off')
    axis square
    hold on
    A = imagesc(axis_lims,axis_lims, z_values);
    set(A,'alphadata',W);
    exportgraphics(gcf, append(Karcher_mean_source, uni_stim(i)))
    hold off

end

% Euclidean mean plots

for i=ix_partial
    % get image to plot
    I = imread(append(AOI_source,uni_stim(i)));

    z_values = Euclid_mean(:,:,i);
    % cut off value
    cut_off = prctile(z_values(:), 90);
    z_values(z_values < cut_off) = NaN;


    W = z_values;
    W(~isnan(z_values)) = .75;
    W(isnan(z_values)) = 0;


    axis_lims = [0 1];

    figure(100);
    imagesc(axis_lims, axis_lims, I);
    set(gca,'visible','off')
    axis square
    hold on
    A = imagesc(axis_lims, axis_lims, z_values);
    set(A,'alphadata',W);
    exportgraphics(gcf, append(Euclidean_mean_source,uni_stim(i)))
    hold off

end


