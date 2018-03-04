clc
clear

%% 
categroys = {'1_Lawn', '2_Bush', '3_Forest', '4_Marshland', '5_Park', '6_Hillside', '7_Grove'};


% 对所有类别进行遍历
for idx = 1:size(categroys, 2)
    categroy = categroys{idx};
    mat_file = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\mat\', categroy, ];
    person = table({'a'}, {[1,2,3,4]});
    person.Properties.VariableNames = {'imageFilename','person'};
    mat_name = [categroy, '.mat'];
    labelingSession = load(mat_file);
    img_file = labelingSession.person.imageFilename;
    
    img_name = img_file
    ROI = labelingSession.person.person;
    
end






%%
caterory = '1_Lawn';
annPath = dir(['H:\Data\UAV-PP\UAV-PP-V2.0.0\mat\', '*.mat']);
saveFilename = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\save_mat\', caterory, '.mat'];

imageLabel = table({'a'}, {[1,2,3,4]});
imageLabel.Properties.VariableNames = {'imageFilename','person'};
sumBottle = 0;
% for i=1:length(annPath)
for i = 1:length(annPath)
    annName = annPath(i).name;
    annotation = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\mat\', annName];
    labelingSession = load(annotation);
    ROI = labelingSession.person.person;
    posPoint = find('.' == annName);
    imgName = annName(1:posPoint-1);
    imgPath = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\1_Lawn\', imgName, '.jpg']
    
    imageLabel.imageFilename{i} = imgPath;
    imageLabel.Bottle{i} = ROI;
    [numBottle, numAxis] = size(ROI);
    sumBottle = sumBottle + numBottle;
end
sumBottle

save(saveFilename, 'imageLabel')