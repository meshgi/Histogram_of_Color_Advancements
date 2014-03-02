function vn = find_videos ( database_path)

file_list = dir (database_path);
folder_flag = find(vertcat(file_list.isdir));
vn = {};

for i = 1:length(folder_flag)-2
    % skip '.' and '..'
    elm = folder_flag(i+2);
    vn{i} = file_list(elm).name;
end