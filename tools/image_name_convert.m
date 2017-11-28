%假设图片放置于"images\"下，需要将其规范命名到"image-convert\"下
imgs = dir(['3dsMax render\','*.jpg']);
for i = 1:length(imgs)
    imgPath = ['3dsMax render\',imgs(i).name];
    img = imread(imgPath);
    imgPathTrans = ['3DSMax_Render_VOC\',num2str(i,'%06d'),'.jpg'];
    imwrite(img,imgPathTrans);
end