function concatParams = genConcatParams(project_name,decimate, final_fs)

concatParams.blc = true;
concatParams.bl_win = [-0.2 0];
concatParams.power = true;
concatParams.noise_method = 'timepts';
concatParams.noise_fields_trials= {'bad_epochs_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
concatParams.noise_fields_timepts= {'bad_inds_HFO','bad_inds_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
if decimate
    concatParams.decimate = true;
    concatParams.fs_targ = final_fs;  % target sampling rate (Hz) after downsampling
    concatParams.sm_win = 0.05; % width of smoothing window (before downsampling, in sec)- put 0 for no smoothing
else
    concatParams.decimate = false;
end

if strcmp(project_name,'Memoria')
    concatParams.t_stim = [0 1]; % time relative to each stim. onset
    concatParams.t_bl = [-0.5 0];
else
    concatParams.t_stim = [0 5];
    concatParams.t_bl = [-0.2 0];
end

