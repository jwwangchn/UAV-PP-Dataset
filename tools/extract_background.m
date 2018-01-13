clc
clear
close all
path = 'H:\Data\WHU_Bottle\RAW\6_Mixture\RAW\';

data = dir([path, '*.jpg']);

imageNum = length(data);

width = 100 - 1;
height = 100 - 1;
k = 4949;

for i = 1:imageNum
    imagePath = [path, data(i).name];
    im  = imread(imagePath);
    for j = 1:20
        k = k + 1;
        rect = [randi(size(im, 2)/2), randi(size(im, 1)/2), width, height]
        imBackground = imcrop(im, rect);
        imgPathBackground = ['H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut_Background\', num2str(k,'%06d'),'.jpg'];
        imwrite(imBackground, imgPathBackground);
    end
end

