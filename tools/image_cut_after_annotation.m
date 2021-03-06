clc
clear
category = '8_Playground'
annotation_path = ['H:\Data\WHU_Bottle\RAW\', category, '\Annotations\', category, '.mat'];
load(annotation_path);
len = size(imageLabel, 1);
newHeigh = 342;
newWidth = 342;

imageLabelNew = table({'a'}, {[]});
imageLabelNew.Properties.VariableNames = {'imageFilename','Bottle'};

% 循环所有图片
k = 0;
for i=1:len
    imgPath = imageLabel.imageFilename{i};  % 图像路径
    imgDir = dir(imgPath);
    imgName = imgDir.name;
    annotations = imageLabel.Bottle{i};     % 注释路径
    annNum = size(annotations, 1);           % 当前图像中瓶子数量
    img = imread(imgPath);
    
    % 对每一个坐标进行变换
    annZeros = zeros(annNum, 2);
    annotations_new = [annotations, annZeros];
    for j = 1:annNum
        annotation = annotations(j,:);      % 遍历每个瓶子的位置
        x0 = annotation(1);
        y0 = annotation(2);
        x1 = annotation(1) + annotation(3);
        y1 = annotation(2) + annotation(4);
        % 分别计算 (x0, y0) (x1, y1) 的商和余数
        x0_consult = fix(x0 / newWidth);
        x0_remainder = mod(x0, newWidth);
        
        y0_consult = fix(y0 / newWidth);
        y0_remainder = mod(y0, newWidth);
        
        x1_consult = fix(x1 / newWidth);
        x1_remainder = mod(x1, newWidth);
        
        y1_consult = fix(y1 / newWidth);
        y1_remainder = mod(y1, newWidth);
        
        % 新坐标
        x0_new = x0_remainder;
        y0_new = y0_remainder;
        x1_new = x1_remainder;
        y1_new = y1_remainder;
        % 块编号
        numBlock = 16*y0_consult + x0_consult + 1;
        annotations_new(j, 1:2) = [x0_new, y0_new];
        annotations_new(j, 5) = numBlock;
        % 如果两个坐标的商相同, 就代表他们在同一块中
        if x0_consult == x1_consult && y0_consult == y1_consult
            annotations_new(j, 6) = 1;
        else
            annotations_new(j, 6) = 0;
        end
    end
    % 遍历每一个图像块
    for m = 1:144
        annPosition = find(annotations_new(:, 5)==m);    % 提取出有瓶子的块的编号, 用于判断当前块有没有瓶子
        annotationBlock = [];
        if annPosition
            flag = 0;
            for n = 1:length(annPosition)               % 当前块瓶子数量
                if annotations_new(annPosition(n), 6)   % 块中的瓶子是否在边界上
                    flag = 1;
                    annotationBlock = [annotationBlock; annotations_new(annPosition(n),1:4)];
                    % 求当前块的坐标
                    x0_block = mod((m-1),16)*newWidth + 1;
                    y0_block = fix((m-1)/16)*newHeigh + 1;
                    blockAxis = [x0_block, y0_block, newWidth - 1, newHeigh - 1];   % 块坐标
                    imgBlock = imcrop(img,blockAxis);
                    imgNewName = num2str(m);                                % 间接进行相似图像筛选
                    posPoint = find('.' == imgName);
                    imgNameNoSuffix = imgName(1:posPoint-1);
                    imgBlockPath = ['H:\Data\WHU_Bottle\VOC_WHU_Bottle_Cut\JPEGImages\', imgNameNoSuffix, '_', imgNewName, '.jpg'];
                    imwrite(imgBlock, imgBlockPath);
                    
                end
            end
            if flag == 1
                k = k + 1;
                imageLabelNew.imageFilename{k} = imgBlockPath;
                imageLabelNew.Bottle{k} = annotationBlock;
            end
        else
            continue;
        end
    end
end

% 保存
imageLabel = imageLabelNew;
saveFilename = ['H:\Data\WHU_Bottle\RAW\', category, '\Annotations\', category, '_Cut', '.mat'];
save(saveFilename, 'imageLabel')

fprintf('分割后图像数量: %d\n', k)