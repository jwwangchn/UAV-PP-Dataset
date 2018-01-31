%% Ŀ��ͼ����ȡ������ͼ����������, ������ʵ���������������

clc
clear

% src Ϊɸѡǰͼ��·��, ������ȡͼ��ԭʼ��
src = 'H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\1_Sand\Cut\';
% dst Ϊɸѡ��ͼ��·��, ���Դ�·���µ�ͼ����������
dst = 'H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\test\';
src_img_list = dir(strcat(src,'*.jpg'));
dst_img_list = dir(strcat(dst,'*.jpg'));
%%
for i = 1:length(dst_img_list)
    name_temp = dst_img_list(i).name;
    index = str2num(name_temp(1:6));
    oldName = [dst, dst_img_list(i).name];
    newName = [dst, src_img_list(index).name];
    if strcmp(oldName, newName)
        continue;
    end
    movefile(oldName, newName);
end