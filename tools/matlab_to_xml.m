function matlab_to_xml(mylabel, generated_path)
% ���ܣ� ��trainingImageLabel APP���ݸ�ʽ(table����)תΪVOC��ʽ��xml
% ���룺 mylabelΪ�����������ռ�ı�ע�ļ�, generated_pathΪ�洢Annotation���ļ���,
% Ĭ�ϴ洢����ǰ·���µ�xmlSaveFolder�ļ���
% ����� �Զ����� xml �ļ��洢��ÿ��ͼ��Ӧһ��
%
% ˵����mylabel��ע���������� command window ���� trainingImageLabeler ��app�����ļ���ע����ע��󵼳���mylabel������Ȼ��ʹ�øú���
% Example:
%          matlab_to_xml(mylabel)
%

%% ��������������ж�
if nargin<1 || ~istable(mylabel)
    error('�������̫�ٻ������ʹ�������trainingImageLabel APP������table�������ݣ�')
end

if nargin == 1
    if ~exist('xmlSaveFolder','file')
        mkdir xmlSaveFolder
    end
    generated_path = 'xmlSaveFolder/'
end

%%
tableLabel = mylabel; %�������Լ��ı�ע�õ�table��������
variableNames = tableLabel.Properties.VariableNames; %cell����
numSamples = size(mylabel,1);
numVariables = size(variableNames,2);

%%
for i = 1:numSamples
    
    rowTable = tableLabel(i,:);
    imageFullPathName = rowTable.(variableNames{1});%cell
    path = char(imageFullPathName);
    [pathstr,name,ext] = fileparts(path);
    index =strfind(pathstr,'\');
    
    annotation.folder = pathstr(index(end)+1:end);
    annotation.filename = [name,ext];
    annotation.path = path;
    
    fprintf('Generating %s.xml, %d/%d, %f%% \n', name, i, numSamples, i/numSamples*100);
    
    % source
    annotation.source.database = 'UAV-PP-V2.0.0';
    annotation.source.annotation = 'PASCAL VOC2007';
    annotation.source.flickrid = 'NULL';
    
    image = imread(annotation.path);
    
    annotation.size.width = size(image,2);
    annotation.size.height = size(image,1);
    annotation.size.depth = size(image,3);
    annotation.segmented = 0;
    
    objectnum = 0;
    for j = 2:numVariables %����ÿ������
        ROI_matrix = rowTable.(variableNames{j});%cell
        ROI_matrix = ROI_matrix{:};
        numROIS = size(ROI_matrix,1);
        for ii = 1: numROIS % ����ÿ��ROI
            %             field = ['object',num2str(ii)];
            objectnum= objectnum+1;
            annotation.object(objectnum).name = variableNames{1,j};
            annotation.object(objectnum).pose = 'Front';
            annotation.object(objectnum).truncated = 0;
            annotation.object(objectnum).difficult= 0;
            annotation.object(objectnum).bndbox.xmin = ROI_matrix(ii,1);
            annotation.object(objectnum).bndbox.ymin = ROI_matrix(ii,2);
            annotation.object(objectnum).bndbox.xmax = ROI_matrix(ii,1)+ROI_matrix(ii,3)-1;
            annotation.object(objectnum).bndbox.ymax = ROI_matrix(ii,2)+ROI_matrix(ii,4)-1;
        end
    end
    xml_write([generated_path, '\', name,'.xml'],annotation);
    clear annotation;
end

