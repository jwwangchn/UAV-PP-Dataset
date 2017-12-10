function matlab_to_xml(mylabel, folder_name)
% 功能： 把trainingImageLabel APP数据格式(table类型)转为VOC格式的xml
% 输入： mylabel为导出到工作空间的标注文件, generated_path为存储Annotation的文件夹,
% 默认存储到当前路径下的xmlSaveFolder文件夹
% 输出： 自动生成 xml 文件存储，每张图对应一个
%
% 说明：mylabel标注变量，请在 command window 输入 trainingImageLabeler 打开app进行文件标注，标注完后导出到mylabel变量，然后使用该函数
% Example:
%          matlab_to_xml(mylabel)
%
%%
if nargin<1 || ~istable(mylabel)
    error('请导入trainingImageLabel APP文件的table数据！');
end

%%
tableLabel = mylabel; %这里是自己的标注好的table类型数据
variableNames = tableLabel.Properties.VariableNames; %cell类型
numSamples = size(mylabel,1);
numVariables = size(variableNames,2);
steps = numSamples;
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
    annotation.source.database = 'UAV-PP-V2.0.0';
    image = imread(annotation.path);
    
    annotation.size.width = size(image,2);
    annotation.size.height = size(image,1);
    annotation.size.depth = size(image,3);
    annotation.segmented = 0;
    
    objectnum = 0;
    for j = 2:numVariables %对于每个变量
        ROI_matrix = rowTable.(variableNames{j} );%cell
        if iscell(ROI_matrix)
            ROI_matrix = cell2mat(ROI_matrix);
        end
        numROIS = size(ROI_matrix,1);
        for ii = 1: numROIS % 对于每个ROI
            objectnum= objectnum+1;
            annotation.object(objectnum).name = variableNames{1,j};
            annotation.object(objectnum).pose = 'Unspecified';
            annotation.object(objectnum).truncated = 0;
            annotation.object(objectnum).difficult= 0;
            annotation.object(objectnum).bndbox.xmin = ROI_matrix(ii,1);
            annotation.object(objectnum).bndbox.ymin = ROI_matrix(ii,2);
            annotation.object(objectnum).bndbox.xmax = ROI_matrix(ii,1)+ROI_matrix(ii,3) - 1;
            annotation.object(objectnum).bndbox.ymax = ROI_matrix(ii,2)+ROI_matrix(ii,4) - 1;
        end
    end
    
    filename = fullfile(folder_name,[name,'_temp.xml']);
    xml_write(filename,annotation);
    
    %% 整理
    fid_r = fopen(filename,'r');
    fid_w = fopen(fullfile(folder_name,[name,'.xml']),'w');
    fgetl(fid_r);
    flagOffset = 0;flagObjects = 0;
    while(~feof(fid_r))
        tline = fgetl(fid_r);
        if contains(tline,'<object>')||contains(tline,'</object>')
            t_next_line = fgetl(fid_r);
            if contains(t_next_line,'<item>')
                flagOffset = mod(flagOffset+1,2);
                flagObjects = 1;
                newStr = strrep(t_next_line,'item','object');
                fprintf(fid_w,'%s\r\n',newStr(4:end));
                continue;
            end
            if ~flagObjects
                fprintf(fid_w,'%s\r\n',tline);
                fprintf(fid_w,'%s\r\n',t_next_line);
            else % 多个objects
                fprintf(fid_w,'%s\r\n',t_next_line);
            end
        elseif contains(tline,'<item>')||contains(tline,'</item>')
            newStr = strrep(tline,'item','object');
            fprintf(fid_w,'%s\r\n',newStr(4:end));
        elseif flagOffset
            fprintf(fid_w,'%s\r\n',tline(4:end));
        else
            fprintf(fid_w,'%s\r\n',tline);% 写objects前面若干行
        end
    end
    fclose(fid_r);
    fclose(fid_w);
    delete(filename);
    clear annotation;
    fprintf('%f%%, %s\n', i/steps*100, filename);
end
