close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

functions_path = join([wp_dir, "Functions"], char_split);
addpath(functions_path)

% path for files outside of current folder
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);
clust_source = append(join([wp_dir, "Images", "Clustering Images"], char_split), char_split);
distance_matrix_source = join([wp_dir, "Data Files", "Distance-Matrices-csv", "dist_matrix_"], char_split);

%%%%%%% clustering and rand index %%%%%%%
load(append(mat_path,'uni_images_wo_aoi'))
load(append(mat_path,'ix_partial_ims'))


% dimension for multidimentional scaling
mds_dim = 2;
cluster_size = 3;

font_size = 25;
m_size = 15;

aoi = ["base", "hose", "stem"];
cols = ["b.", "g.", "r."];

clust_cols  = [ "#D95319", "#7E2F8E", "#77AC30"];
Rand_index_mat = zeros(length(uni_images_wo_aoi), 2);

for i = ix_partial_ims

    X1 = readtable(append(distance_matrix_source,uni_images_wo_aoi(i), ".csv"),'PreserveVariableNames', true);
    row_names = X1.row_names;
    names = split(row_names, '_');

    X1.row_names = [];
    D = table2array(X1);
    sf_D = squareform(D);
    Z = linkage(sf_D, 'complete');

    Y = mdscale(D, mds_dim);
    max0 = round(max(abs(Y), [], 'all'), 1);
    axis_tics = linspace(-max0,max0, 5);

    % mds of true label
    figure(1);clf;
    hold on
    axis square
    for k = 1:length(aoi)
        ix = names(:,3) == aoi(k);
        plot(Y(ix,1), Y(ix,2), cols(k), 'DisplayName', aoi(k), 'MarkerSize', m_size)
    end
    set(gca,'FontSize', font_size)
    xlim([-max0 max0]); ylim([-max0 max0]);
    xticks(axis_tics); yticks(axis_tics);
    hold off
    title_name = strcat('mds_', uni_images_wo_aoi(i), '_true','.png');
    exportgraphics(gcf, append(clust_source, title_name))


    % mds using complete linkage
    clust1 = cluster(Z, 'maxclust', cluster_size);
    figure(2);clf;
    hold on
    axis square
    for k = 1:length(aoi)
        clust_id = strcat("Cluster ", string(k));
        plot(Y(clust1 == k,1), Y(clust1 == k,2), cols(k), 'DisplayName', clust_id,... 
        'Color', clust_cols(k), 'MarkerSize', m_size)
    end
    set(gca,'FontSize', font_size)
    xlim([-max0 max0]);ylim([-max0 max0]);
    xticks(axis_tics); yticks(axis_tics);
    hold off
    title_name = strcat('mds_', uni_images_wo_aoi(i), '_hc','.png');
    exportgraphics(gcf, append(clust_source, title_name))
    hold off

    % rand index
    true_label = zeros(length(Y),1);

    for k = 1:length(aoi)
        ix = names(:,3) == aoi(k);
        true_label(ix) = k;
    end
    
    [AR,RI,~,~] = RandIndex(true_label, clust1);
    Rand_index_mat(i,:) = [RI, AR];
end


Rand_index_mat = array2table(Rand_index_mat);
Rand_index_mat.Properties.VariableNames = ["Rand_Index", "Adjusted Rand Index"];
save(append(mat_path, 'Rand_index_mat'), 'Rand_index_mat')

