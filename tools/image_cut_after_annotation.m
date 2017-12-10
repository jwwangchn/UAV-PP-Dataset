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

% ѭ������ͼƬ
k = 0;
for i=1:len
    imgPath = imageLabel.imageFilename{i};  % ͼ��·��
    imgDir = dir(imgPath);
    imgName = imgDir.name;
    annotations = imageLabel.Bottle{i};     % ע��·��
    annNum = size(annotations, 1);           % ��ǰͼ����ƿ������
    img = imread(imgPath);
    
    % ��ÿһ��������б任
    annZeros = zeros(annNum, 2);
    annotations_new = [annotations, annZeros];
    for j = 1:annNum
        annotation = annotations(j,:);      % ����ÿ��ƿ�ӵ�λ��
        x0 = annotation(1);
        y0 = annotation(2);
        x1 = annotation(1) + annotation(3);
        y1 = annotation(2) + annotation(4);
        % �ֱ���� (x0, y0) (x1, y1) ���̺�����
        x0_consult = fix(x0 / newWidth);
        x0_remainder = mod(x0, newWidth);
        
        y0_consult = fix(y0 / newWidth);
        y0_remainder = mod(y0, newWidth);
        
        x1_consult = fix(x1 / newWidth);
        x1_remainder = mod(x1, newWidth);
        
        y1_consult = fix(y1 / newWidth);
        y1_remainder = mod(y1, newWidth);
        
        % ������
        x0_new = x0_remainder;
        y0_new = y0_remainder;
        x1_new = x1_remainder;
        y1_new = y1_remainder;
        % ����
        numBlock = 16*y0_consult + x0_consult + 1;
        annotations_new(j, 1:2) = [x0_new, y0_new];
        annotations_new(j, 5) = numBlock;
        % ����������������ͬ, �ʹ���������ͬһ����
        if x0_consult == x1_consult && y0_consult == y1_consult
            annotations_new(j, 6) = 1;
        else
            annotations_new(j, 6) = 0;
        end
    end
    % ����ÿһ��ͼ���
    for m = 1:144
        annPosition = find(annotations_new(:, 5)==m);    % ��ȡ����ƿ�ӵĿ�ı��, �����жϵ�ǰ����û��ƿ��
        annotationBlock = [];
        if annPosition
            flag = 0;
            for n = 1:length(annPosition)               % ��ǰ��ƿ������
                if annotations_new(annPosition(n), 6)   % ���е�ƿ���Ƿ��ڱ߽���
                    flag = 1;
                    annotationBlock = [annotationBlock; annotations_new(annPosition(n),1:4)];
                    % ��ǰ�������
                    x0_block = mod((m-1),16)*newWidth + 1;
                    y0_block = fix((m-1)/16)*newHeigh + 1;
                    blockAxis = [x0_block, y0_block, newWidth - 1, newHeigh - 1];   % ������
                    imgBlock = imcrop(img,blockAxis);
                    imgNewName = num2str(m);                                % ��ӽ�������ͼ��ɸѡ
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

% ����
imageLabel = imageLabelNew;
saveFilename = ['H:\Data\WHU_Bottle\RAW\', category, '\Annotations\', category, '_Cut', '.mat'];
save(saveFilename, 'imageLabel')

fprintf('�ָ��ͼ������: %d\n', k)