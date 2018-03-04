clc
clear

%%
% categroys = {'1_Lawn', '2_Bush', '3_Forest', '4_Marshland', '5_Park', '6_Hillside', '7_Grove'};
% mat_path = 'H:\Data\UAV-PP\UAV-PP-V2.0.0\mat_struct';
% 
% for idx = 1:size(categroys, 2)
%     mat_file = [mat_path, '\', categroys{idx}, '.mat'];
%     person = load(mat_file);
%     person = table2struct(person.person);
%     save_file = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\save_mat\', categroys{idx}, '.mat'];
%     save(save_file, 'person')
% end

file = 'H:\Data\UAV-PP\UAV-PP-V2.0.0\person_all\Jan_Lawn.mat';
save_path = 'H:\Data\UAV-PP\UAV-PP-V2.0.0\person_all_save';

person = load(file);
person = table2struct(person.person);
save_file = ['H:\Data\UAV-PP\UAV-PP-V2.0.0\person_all_save\', 'Jan_Lawn', '.mat'];
save(save_file, 'person')
