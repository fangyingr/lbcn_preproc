function CopySubject(sbj_name, s_psychData, d_psychData, s_neuralData, d_neuralData, neuralData_folders, project_name, block_names)
% s source
% d destination

%% neuralData_folders
if strcmp(neuralData_folders, 'all')
    neuralData_folders = {'originalData', 'CARData', 'SpecData', 'HFBData'};
else
end

%% Copy psychData
for i = 1:length(block_names)
    bn = block_names{i};
    tmp_psych_folder_d = [d_psychData filesep sbj_name filesep bn];
    tmp_psych_folder_s = [s_psychData filesep sbj_name filesep bn];
    
    if ~exist(tmp_psych_folder_d)
        mkdir(tmp_psych_folder_d)
        copyfile(tmp_psych_folder_s, tmp_psych_folder_d)
    else
    end
    
    %% Copy neural data
    for ii = 1:length(neuralData_folders)
        %         tmp_neural_folder_s = [s_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn];
        if strcmp(neuralData_folders{ii}, 'CARData')
            tmp_neural_folder_d = [d_neuralData filesep neuralData_folders{ii} filesep 'CAR' filesep sbj_name filesep bn];
            tmp_neural_folder_s = [s_neuralData filesep neuralData_folders{ii} filesep 'CAR' filesep sbj_name filesep bn];
        else
            tmp_neural_folder_d = [d_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn];
            tmp_neural_folder_s = [s_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn];
        end
        if ~exist(tmp_neural_folder_d)
            disp(['copying ' neuralData_folders{ii} ' ' sbj_name])
            mkdir(tmp_neural_folder_d)
            copyfile(tmp_neural_folder_s, tmp_neural_folder_d)
        else
        end
    end
    
    %% Copy globalVar
    global_var_s_path = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',s_neuralData,sbj_name,project_name,sbj_name,bn);
    global_var_d_path = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',d_neuralData,sbj_name,project_name,sbj_name,bn);
    if ~exist(global_var_d_path)
        copyfile(global_var_s_path, global_var_d_path)
    else
    end
    
end
end





%
% if ~exist([d_psychData sbj_name])
%     copyfile([s_psychData '/' sbj_name], [d_psychData '/' sbj_name])
% else
% end