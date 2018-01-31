%假设图片放置于"images\"下，需要将其规范命名到"image-convert\"下
imgs = dir(['H:\Data\UAV\UAV-PP-V2.0.0\RAW\1_Lawn\','*.jpg']);
categroy = '1_Lawn';
idx = 966
for i = 1 : length(imgs)
    imgPath = ['H:\Data\UAV\UAV-PP-V2.0.0\RAW\1_Lawn\',imgs(i).name];
    img = imread(imgPath);
    imgPathTrans = ['H:\Data\UAV\UAV-PP-V2.0.0\RAW\1_Lawn\', categroy, num2str(idx,'%06d'),'.jpg'];
    imwrite(img, imgPathTrans);
    idx = idx + 1
end