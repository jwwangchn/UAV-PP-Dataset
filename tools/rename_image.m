clc
clear

path = 'H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut_Background\';
imgs = dir([path,'*.jpg']);
for i = 1:length(imgs)
    fprintf("%d\n", i)
    oldName = [path, imgs(i).name];
    newName = [path, 'Neg_', num2str(i,'%06d'),'.jpg'];
    if strcmp(oldName, newName)
        continue;
    end
    movefile(oldName, newName)
end