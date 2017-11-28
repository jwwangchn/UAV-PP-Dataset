function matlab_to_xml(mylabel, generated_path)
% 功能： 把trainingImageLabel APP数据格式(table类型)转为VOC格式的xml
% 输入： mylabel为导出到工作空间的标注文件, generated_path为存储Annotation的文件夹,
% 默认存储到当前路径下的xmlSaveFolder文件夹
% 输出： 自动生成 xml 文件存储，每张图对应一个
%
% 说明：mylabel标注变量，请在 command window 输入 trainingImageLabeler 打开app进行文件标注，标注完后导出到mylabel变量，然后使用该函数
% Example:
%          matlab_to_xml(mylabel)
%

%% 输入参数合理性判断
if nargin<1 || ~istable(mylabel)
    error('输入参数太少或者类型错误！请用trainingImageLabel APP导出的table类型数据！')
end

if nargin == 1
    if ~exist('xmlSaveFolder','file')
        mkdir xmlSaveFolder
    end
    generated_path = 'xmlSaveFolder/'
end

%%
tableLabel = mylabel; %这里是自己的标注好的table类型数据
variableNames = tableLabel.Properties.VariableNames; %cell类型
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
    for j = 2:numVariables %对于每个变量
        ROI_matrix = rowTable.(variableNames{j});%cell
        ROI_matrix = ROI_matrix{:};
        numROIS = size(ROI_matrix,1);
        for ii = 1: numROIS % 对于每个ROI
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

