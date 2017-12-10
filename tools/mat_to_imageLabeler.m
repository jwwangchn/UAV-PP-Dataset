clc

data = load('H:\Data\WHU_Bottle\RAW\1_Sand\Annotations\1_Sand_Cut.mat');
imageFilenames = data.imageLabel.imageFilename(:)
dataSource = groundTruthDataSource(imageFilenames);
names = {'Bottle'};
types = [labelType('Rectangle')];

labelDefs = table(names,types,'VariableNames',{'Name','Type'})
numRows = numel(imageFilenames);
labelData = table(data.imageLabel.Bottle(:),'VariableNames',names)
gTruth = groundTruth(dataSource,labelDefs,labelData)

