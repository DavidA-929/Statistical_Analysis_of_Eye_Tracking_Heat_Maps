clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

% Import the data
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% save new raw data
load(append(mat_path, "RawData"))

%% add unique trials to Raw Data and remove images with no labels

RawData2 = RawData;
% find indeces without label
split_stimulus = split(RawData2.Stimulus,"_");
no_label_index = split_stimulus(:,2) == "no";

% remove no label
RawData2(no_label_index,:) = [];

% add row index
RawData2.Rows = (1:size(RawData2,1))';

% use '_' to concatinate image and participant 
joining_string(1:size(RawData2,1),1) = '_';

% add unique trials 
RawData2.Unique_Trial = strcat(RawData2.Stimulus,joining_string,RawData2.Participant);

save(append(mat_path, "RawData2"), 'RawData2')

%% save useful variables
uni_stim = unique(RawData2.Stimulus);
save(append(mat_path, "uni_stim"), 'uni_stim')

participants = unique(RawData2.Participant);
save(append(mat_path, "participants"), 'participants')

% get unique images without label location
split1 = split(uni_stim, '_');
split2 = split1;
split2(:,3) = "aoi";
uni_images = unique(join(split2, '_'));
save(append(mat_path, "uni_images"), 'uni_images')
split_stims = split(uni_images, '_');
ix = split_stims(:,end) == "partial.jpg";
n = 1:length(uni_images);
ix_partial_ims = n(ix);
save(append(mat_path,'ix_partial_ims'),'ix_partial_ims')


% repeat above but remove "aoi"
uni_images_wo_aoi = split1;
uni_images_wo_aoi(:,3) = [];
uni_images_wo_aoi = unique(join(uni_images_wo_aoi, '_'));
save(append(mat_path, "uni_images_wo_aoi"), 'uni_images_wo_aoi')

% unique trials
unique_trials_full = unique(RawData2.Unique_Trial);
save(append(mat_path, "unique_trials_full"), 'unique_trials_full')

% rindex for partial images only
split_stims = split(uni_stim, '_');
ix = split_stims(:,end) == "partial.jpg";
n = 1:length(uni_stim);
ix_partial = n(ix);
save(append(mat_path,'ix_partial'),'ix_partial')

