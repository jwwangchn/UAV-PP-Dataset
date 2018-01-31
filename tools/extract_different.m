%% 标注文件的数量跟图像数量不一致, 根据标注文件提取标注过的图像

clc
clear


ann_path = 'H:\Data\UAV-Bottle\UAV-Bottle-V1.2.0\Annotations\';

img_path = 'H:\Data\UAV-Bottle\UAV-Bottle-V1.2.0\JPEGImages\';

save_path = 'H:\Data\UAV-Bottle\UAV-Bottle-V1.2.0\Save\';

ann_list = dir(strcat(ann_path,'*.xml'));
img_list = dir(strcat(img_path,'*.jpg'));
%%
% for i=1
for i = 1:length(ann_list)
    name_temp = ann_list(i).name;
    index = name_temp(1:end-4);
    
    oldName = [img_path, index, '.jpg']

    movefile(oldName, save_path);
end