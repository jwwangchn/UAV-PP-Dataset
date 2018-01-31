%% 目标图像提取软件会对图像重新命名, 本程序实验根据索引重命名

clc
clear

% src 为筛选前图像路径, 用于提取图像原始名
src = 'H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\1_Sand\Cut\';
% dst 为筛选后图像路径, 将对此路径下的图像重新命名
dst = 'H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\test\';
src_img_list = dir(strcat(src,'*.jpg'));
dst_img_list = dir(strcat(dst,'*.jpg'));
%%
for i = 1:length(dst_img_list)
    name_temp = dst_img_list(i).name;
    index = str2num(name_temp(1:6));
    oldName = [dst, dst_img_list(i).name];
    newName = [dst, src_img_list(index).name];
    if strcmp(oldName, newName)
        continue;
    end
    movefile(oldName, newName);
end