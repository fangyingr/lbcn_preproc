function epoch_params = genEpochParams(project_name, locktype)
%% Generate parameters for epoching. 

%   epoch_params.locktype: 'stim' or 'resp' (which events to timelock to)
%   epoch_params.bef_time: time (in s) before event to start each epoch of data
%   epoch_params.aft_time: time (in s) after event to end each epoch of data
%   epoch_params.blc: baseline correction
%       .run: true or false (whether to run baseline correction)
%       .locktype: 'stim' or 'resp' (which event to use to choose baseline window)
%       .win: 2-element vector specifiying window relative to lock event to use for baseline, in sec (e.g. [-0.2 0])
%   epoch_params.noise.method: 'trials','timepts', or 'none' (which baseline data to
%                       exclude before baseline correction)
%               .noise_fields_trials  (which trials to exclude- if method = 'trials')
%               .noise_fields_timepts (which timepts to exclude- if method = 'timepts')


epoch_params.locktype = locktype;

switch project_name
    case 'GradCPT'
        epoch_params.blc.run = false;
        epoch_params.bef_time = -0.5; %-0.8
        epoch_params.aft_time = 1.6; % 0.8
        
    case 'Memoria'
        if strcmp(locktype, 'stim')
            epoch_params.bef_time = -0.5;
            epoch_params.aft_time = 8.5;
        elseif strcmp(locktype, 'resp')
            epoch_params.bef_time = -5;
            epoch_params.aft_time = 1;
        end
        epoch_params.blc.run = true; % or false
        epoch_params.blc.win = [-.5 0];
        
    case 'Calculia_China'
        if strcmp(locktype, 'stim')
            epoch_params.bef_time = -0.5;
            epoch_params.aft_time = 7;
        elseif strcmp(locktype, 'resp')
            epoch_params.bef_time = -5;
            epoch_params.aft_time = 1;
        end
        epoch_params.blc.run = true; % or false
        epoch_params.blc.win = [-.5 0];
        
    case 'MMR'
        if strcmp(locktype, 'stim')
            epoch_params.bef_time = -0.2;
            epoch_params.aft_time = 3;
        elseif strcmp(locktype, 'resp')
            epoch_params.bef_time = -3;
            epoch_params.aft_time = 1;
        end
        epoch_params.blc.run = true; % or false
        epoch_params.blc.win = [-.2 0];
        
    case 'UCLA'
        if strcmp(locktype, 'stim')
            epoch_params.bef_time = -0.5;
            epoch_params.aft_time = 5;
        elseif strcmp(locktype, 'resp')
            epoch_params.bef_time = -3;
            epoch_params.aft_time = 1;
        end
        epoch_params.blc.run = true; % or false
        epoch_params.blc.win = [-.5 0];
        
    case 'Number_comparison'
        if strcmp(locktype, 'stim')
            epoch_params.bef_time = -0.5;
%             epoch_params.aft_time = 5;
            epoch_params.aft_time = 4;
        elseif strcmp(locktype, 'resp')
            epoch_params.bef_time = -3;
            epoch_params.aft_time = 1;
        end
        epoch_params.blc.run = true; % or false
        epoch_params.blc.win = [-.5 0];        
end

epoch_params.blc.locktype = 'stim';
epoch_params.blc.bootstrap = false; 
epoch_params.blc.fieldtrip = false; 
epoch_params.noise.method = 'trials';
epoch_params.noise.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};%'bad_epochs_raw_LFspike',
epoch_params.noise.noise_fields_timepts = {'bad_inds_HFO','bad_inds_raw_HFspike'};%'bad_inds_raw_LFspike',
end
