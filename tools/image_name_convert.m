%����ͼƬ������"images\"�£���Ҫ����淶������"image-convert\"��
imgs = dir(['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\','*.jpg']);
for i = 1:length(imgs)
    imgPath = ['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\',imgs(i).name];
    img = imread(imgPath);
    imgPathTrans = ['H:\Data\WHU_Bottle\RAW\1_Sand\RAW\','Sand_', num2str(i,'%06d'),'.jpg'];
    imwrite(img,imgPathTrans);
end