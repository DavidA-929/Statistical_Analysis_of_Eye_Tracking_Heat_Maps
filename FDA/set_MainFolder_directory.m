function [Shape_imp_dir, char_split] = set_MainFolder_directory(shape_imp_folder_name)
    
    curr_wd = pwd;
    char_split =  curr_wd(ismember(curr_wd, ['\', '/']));
    char_split = char_split(1);
    split_dir = split(curr_wd, char_split);
    split_dir(logical(cumsum(ismember(split_dir,shape_imp_folder_name)))) = [];
    n = size(split_dir,1);
    split_dir{n+1,1} = shape_imp_folder_name;
    Shape_imp_dir = string(join(split_dir, char_split));
end