%假设图片放置于"images\"下，需要将其规范命名到"image-convert\"下
imgs = dir(['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\','*.jpg']);
for i = 1:length(imgs)
    imgPath = ['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\',imgs(i).name];
    img = imread(imgPath);
    imgPathTrans = ['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\','Sand_', num2str(i,'%06d'),'.jpg'];
    imwrite(img,imgPathTrans);
end