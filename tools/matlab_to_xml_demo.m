clc
clear

clc
clear
dict = {'1_Sand', '2_Lawn', '3_Bush', '4_Land', '5_Step', '6_Mixture', '7_Ground', '8_Playground'};
for idx = 1:size(dict,2)
    categroy = dict{idx};
    path = ['H:\Data\WHU_Bottle\RAW\', categroy, '\Annotations\', categroy, '_Cut.mat'];
    matFile = load(path);
    tableAnnotation = matFile.imageLabel;
    tableAnnotation.Properties.VariableNames = {'imageFilename','bottle'};
    matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations_Low_Case')
end
