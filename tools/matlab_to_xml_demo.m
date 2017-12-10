clc
clear
%% [1] Sand
matFile = load('H:\Data\WHU_Bottle\RAW\1_Sand\Annotations\1_Sand_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')

%% [2] Lawn
matFile = load('H:\Data\WHU_Bottle\RAW\2_Lawn\Annotations\2_Lawn_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')

%% [3] Bush
matFile = load('H:\Data\WHU_Bottle\RAW\3_Bush\Annotations\3_Bush_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
%% [4] Land
matFile = load('H:\Data\WHU_Bottle\RAW\4_Land\Annotations\4_Land_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
% [5] Step
matFile = load('H:\Data\WHU_Bottle\RAW\5_Step\Annotations\5_Step_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
% [6] Mixture
matFile = load('H:\Data\WHU_Bottle\RAW\6_Mixture\Annotations\6_Mixture_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
% [7] Ground
matFile = load('H:\Data\WHU_Bottle\RAW\7_Ground\Annotations\7_Ground_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
% [8] Playground
matFile = load('H:\Data\WHU_Bottle\RAW\8_Playground\Annotations\8_Playground_Cut.mat');
tableAnnotation = matFile.imageLabel;
matlab_to_xml(tableAnnotation,'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\Annotations')
