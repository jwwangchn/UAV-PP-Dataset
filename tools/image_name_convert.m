%����ͼƬ������"images\"�£���Ҫ����淶������"image-convert\"��
imgs = dir(['3dsMax render\','*.jpg']);
for i = 1:length(imgs)
    imgPath = ['3dsMax render\',imgs(i).name];
    img = imread(imgPath);
    imgPathTrans = ['3DSMax_Render_VOC\',num2str(i,'%06d'),'.jpg'];
    imwrite(img,imgPathTrans);
end