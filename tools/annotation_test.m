clc
clear
dict = {'1_Sand', '2_Lawn', '3_Bush', '4_Land', '5_Step', '6_Mixture', '7_Ground', '8_Playground'};
% for idx = 1:size(dict,2)
for idx = 1:2
    categroy = dict{idx};
    path = ['H:\Data\WHU_Bottle\RAW\', categroy, '\Annotations\', categroy, '_Cut.mat'];
    matFile = load(path);
    tableAnnotation = matFile.imageLabel;
    len = size(tableAnnotation, 1);
    for i = 1:len
        if size(tableAnnotation.Bottle{i}, 1) == 0
            fprintf('Find');
        end
    end
end
