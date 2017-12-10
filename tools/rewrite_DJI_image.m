imgs = dir(['H:\Data\WHU_Bottle\VOC_WHU_Bottle\JPEGImages\','*.jpg']);
for i = 1:length(imgs)
    imgPath = ['H:\Data\WHU_Bottle\VOC_WHU_Bottle\JPEGImages\',imgs(i).name];
    fprintf('%d/%d, %s \n', i, length(imgs), imgs(i).name)
    img = imread(imgPath);
    imwrite(img,imgPath);
end