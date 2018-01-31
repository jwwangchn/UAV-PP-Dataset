%% 对原始图像进行分割

clc
clear
close all

%% [1] 获取图像文件
% categroys = {'4_Marshland', '5_Park', '6_Hillside', '7_Grove'};
% for idx = 1:length(categroys)

categroy ='Jan_20'
% categroy = categroys{idx}
src = ['H:\Data\UAV\UAV-PP-V2.0.0\RAW\1月20日'];
dst = ['H:\Data\UAV\UAV-PP-V2.0.0\RAW\1月20日', '\Cut'];

img_list = dir(strcat(src,'\*.jpg'));
img_num = length(img_list);

crop_img_heigh = 1000;
crop_img_width = 1000;

%% [2] 处理图像

for i = 1:img_num
    % for i=1
    img_name = img_list(i).name;
    img_path_name = [src , '\', img_name];
    img = imread(img_path_name);
    [heigh, width, depth] = size(img);
    row_num = floor(heigh / crop_img_heigh);
    col_num = floor(width / crop_img_width);
    row_start_point = 1:crop_img_heigh:(row_num-1)*crop_img_heigh + 1;
    col_start_point = 1:crop_img_heigh:(col_num-1)*crop_img_heigh + 1;
    k = 0;
    for m = 1:row_num
        for n = 1:col_num
            img_cut = imcrop(img,[col_start_point(n) row_start_point(m) crop_img_heigh - 1 crop_img_heigh - 1]);
            k = k + 1;
            img_save_name = [dst '\', categroy, '_', num2str(i,'%06d'), '_', num2str(k), '.jpg'];
            fprintf('Processing %d/%d image \n',i, img_num);
            imwrite(img_cut, img_save_name)
            %             subplot(row_num, col_num, k)
            %             imshow(img_cut)
        end
    end
end
