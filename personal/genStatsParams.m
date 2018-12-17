function stats_params = genStatsParams(project_name)

%% INPUTS:
%   project_name: task name

switch project_name
    case 'MMR'
        stats_params.task_win = [0 2];
        stats_params.bl_win = [-0.2 0];
    case 'Memoria'
        stats_params.task_win = [0 7];
        stats_params.bl_win = [-0.5 0];
    case 'GradCPT'
        stats_params.task_win = [0 0.8];
        stats_params.bl_win = [-0.2 0];
end

stats_params.nreps= 10000; %%% 2000 for cluster based permutation
stats_params.freq_range = [70 180];
stats_params.paired = false;%true;%
stats_params.noise_method = 'trials';
stats_params.alpha = 0.05;
stats_params.blc=1;
stats_params.smooth=1;
stats_params.fwer=0.05;
stats_params.tail=0;
stats_params.sm=0.01;

stats_params.noise_fields_trials= {'bad_epochs_raw_LFspike','bad_epochs_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
stats_params.noise_fields_timepts= {'bad_epochs_raw_LFspike','bad_inds_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)


