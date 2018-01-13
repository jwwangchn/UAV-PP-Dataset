clc
clear
close all

categroy = '8_Playground'
data = load(['H:\Data\WHU_Bottle\RAW\', categroy, '\Annotations\', categroy, '_Cut.mat']);
imageFilenames = data.imageLabel.imageFilename(:);
names = {'Bottle'};
labelData = data.imageLabel.Bottle(:);

imageNum = size(imageFilenames, 1);

k = 0;
for i = 1:imageNum
    bboxNum = size(labelData{i}, 1);
    boundingBoxAxis = labelData{i};
    im = imread(imageFilenames{i});
    boundingBox = [];
    for j = 1:bboxNum
        k = k + 1;
        boundingBoxTemp = imcrop(im, boundingBoxAxis(j, :));
        imgPathBoundingBox = ['H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut_BoundingBox\', categroy, num2str(k,'%06d'),'.jpg'];
        imwrite(boundingBoxTemp, imgPathBoundingBox);
    end
end

