clc
clear

% all_img_path 是所有图像的路径
all_img_path = 'H:\Data\UAV\UAV-PP-V2.0.0\RAW\All\';
pos_img_path = 'H:\Data\UAV\UAV-PP-V2.0.0\RAW\Pos\';
neg_img_path = 'H:\Data\UAV\UAV-PP-V2.0.0\RAW\Neg\';

all_img_list = dir(strcat(all_img_path,'*.jpg'));
pos_img_list = dir(strcat(pos_img_path,'*.jpg'));
pos_img_name = {pos_img_list.name}';
% pos_img_name = char(pos_img_name);
for i = 1:length(all_img_list)
    img_name = all_img_list(i).name;
    idx = strfind(pos_img_name, img_name);
    idx_sum = sum(cell2mat(idx));
    if idx_sum
        continue
    else
        old_name = [all_img_path, img_name];
        new_name = [neg_img_path, img_name];
        copyfile(old_name, neg_img_path)
    end
end