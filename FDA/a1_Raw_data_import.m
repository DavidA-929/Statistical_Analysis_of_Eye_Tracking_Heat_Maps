clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

%% Import data from text file

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["RecordingTimems", "TimeofDayhmsms", "Trial", "Stimulus", "ExportStartTrialTimems", "ExportEndTrialTimems", "Participant", "Color", "PupilDiameterRightmm", "PointofRegardRightXpx", "PointofRegardRightYpx", "AOINameRight", "GazeVectorRightX", "GazeVectorRightY", "GazeVectorRightZ"];
opts.VariableTypes = ["double", "string", "string", "string", "double", "double", "string", "string", "double", "double", "double", "string", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["TimeofDayhmsms", "Trial", "Stimulus", "Color", "AOINameRight"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["TimeofDayhmsms", "Trial", "Stimulus", "Color", "AOINameRight"], "EmptyFieldRule", "auto");

% Import the data
raw_data_folder = join([wp_dir, "Data Files","Eye-Tracking-Data", "Raw Data_1-20-2020.txt"], char_split);

RawData = readtable(raw_data_folder, opts);


% remove participants with low number of observations or high proportion of
% zero eye coordinates
RawData(RawData.Participant == "153",:) = [];
RawData(RawData.Participant == "158",:) = [];
RawData(RawData.Participant == "164",:) = [];
RawData(RawData.Participant == "168",:) = [];
RawData(RawData.Participant == "193",:) = [];
RawData(RawData.Participant == "200_e",:) = [];


%% Clear temporary variables
clear opts
%%
% .mat files folder
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% save new raw data
save(append(mat_path, "RawData"), 'RawData')
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

