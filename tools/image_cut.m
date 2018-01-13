clc
clear
close all

%% [1] 获取图像文件
src = 'H:\Data\WHU_Bottle\RAW_多尺度测试图像';
dst = 'H:\Data\WHU_Bottle\RAW_多尺度测试图像\Cut';

img_list = dir(strcat(src,'\*.jpg'));
img_num = length(img_list);

crop_img_heigh = 342;
crop_img_width = 342;

%% [2] 处理图像
k = 0
% for i = 1:img_num
for i=2
    img_name = img_list(i).name;
    img_path_name = [src , '\', img_name];
    img = imread(img_path_name);
    [heigh, width, depth] = size(img);
    row_num = floor(heigh / crop_img_heigh);
    col_num = floor(width / crop_img_width);
    row_start_point = 1:342:(row_num-1)*342 + 1;
    col_start_point = 1:342:(col_num-1)*342 + 1;

    for m = 1:row_num
        for n = 1:col_num
            img_cut = imcrop(img,[col_start_point(n) row_start_point(m) 341 341]);
            k = k + 1;
            img_save_name = [dst '\' num2str(k,'%06d'),'.jpg'];
            fprintf('Processing %d/%d image \n',i, img_num);
            imwrite(img_cut, img_save_name)
%             subplot(row_num, col_num, k)
%             imshow(img_cut)
        end
    end
end