clc
clear
categroy = '7_Grove';
path = 'H:\Data\UAV\UAV-PP-V2.0.0\RAW\7_Grove\';
imgs = dir([path,'*.jpg']);
% for i=1
for i = 1:length(imgs)
    fprintf("%d\n", i)
    oldName = [path, imgs(i).name];
    newName = [path, categroy, '_', num2str(i,'%06d'),'.jpg'];
    if strcmp(oldName, newName)
        continue;
    end
    movefile(oldName, newName)
end