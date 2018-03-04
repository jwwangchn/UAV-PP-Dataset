clc
clear

clc
clear
dict = {'1_Sand', '2_Lawn', '3_Bush', '4_Land', '5_Step', '6_Mixture', '7_Ground', '8_Playground'};
for idx = 1:size(dict,2)
%     categroy = dict{idx};
    categroy = '1_Lawn'
    path = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\mat\', categroy, '.mat'];
    matFile = load(path);
    tableAnnotation = matFile.person;
    tableAnnotation.Properties.VariableNames = {'imageFilename','person'};
    matlab_to_xml(tableAnnotation,'H:\Data\UAV-PP\UAV-PP-V2.2.0\Annotations')
end
