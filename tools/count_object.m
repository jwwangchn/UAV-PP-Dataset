clc
clear

category = '8_Playground'
annotation_path = ['H:\Data\WHU_Bottle\RAW\', category, '\Annotations\', category, '_Cut.mat'];
load(annotation_path)
sum=0;
for i = 1:size(imageLabel, 1)
    ann = imageLabel.Bottle{i};
    sum = sum + size(ann,1);
end
fprintf("目标个数: %d\n", sum);