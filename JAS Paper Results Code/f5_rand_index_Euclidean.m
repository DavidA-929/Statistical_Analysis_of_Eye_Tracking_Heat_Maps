close all; clear;
[wp_dir, char_split] = set_MainFolder_directory('Statistical_Analysis_of_Eye_Tracking_Heat_Maps');

functions_path = join([wp_dir, "Functions"], char_split);
mat_path = append(join([wp_dir, "Data Files", "mat Files"], char_split), char_split);

% load mat files needed
addpath(functions_path)
load(append(mat_path,'uni_images_wo_aoi'))
load(append(mat_path,'Rand_index_mat_Euclid'))


pipes = ["Pipe01", "Pipe02", "Pipe03", "Pipe04"];
label = ["lung", "mouth", "text"];

Mat1= [1;2;3;4];
for l = 1:length(label)

    pipe_ims =  strcat(pipes,'_',label(l), '_partial.jpg');            
    ix = ismember(uni_images_wo_aoi, pipe_ims);
    
    rand_array = table2array(Rand_index_mat(ix,1));
    
    Mat1 = cat(2, Mat1, rand_array);

end

randidexmat = array2table(Mat1, "VariableNames", {'Pipe', 'Lung', 'Mouth', 'Text'});
disp(randidexmat)

