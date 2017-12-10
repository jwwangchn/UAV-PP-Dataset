clc
%%
caterory = '1_Sand';
annPath = dir(['H:\Data\WHU_Bottle\RAW\', caterory, '\Annotations\', '*.mat']);
saveFilename = ['H:\Data\WHU_Bottle\RAW\', caterory, '\Annotations\', caterory, '.mat'];

imageLabel = table({'a'}, {[1,2,3,4]});
imageLabel.Properties.VariableNames = {'imageFilename','Bottle'};
sumBottle = 0;
% for i=1:length(annPath)
for i = 1:length(annPath)
    annName = annPath(i).name;
    annotation = ['H:\Data\WHU_Bottle\RAW\', caterory, '\Annotations\',annName];
    labelingSession = load(annotation);
    ROI = labelingSession.labelingSession.ImageSet.ImageStruct.objectBoundingBoxes;
    posPoint = find('.' == annName);
    imgName = annName(1:posPoint-1);
    imgPath = ['H:\Data\WHU_Bottle\VOC_WHU_Bottle\JPEGImages\', imgName, '.jpg']
    imageLabel.imageFilename{i} = imgPath;
    imageLabel.Bottle{i} = ROI;
    [numBottle, numAxis] = size(ROI);
    sumBottle = sumBottle + numBottle;
end
sumBottle

save(saveFilename, 'imageLabel')