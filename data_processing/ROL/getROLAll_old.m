function [ROL] = getROLAll(sbj_name,project_name,block_names,dirs,elecs,freqband,ROLparams,column,conds,region)

%% INPUTS
%       sbj_name: subject name
%       project_name: name of task
%       block_names: blocks to be analyed (cell of strings)
%       dirs: directories pointing to files of interest (generated by InitializeDirs)
%       elecs: can select subset of electrodes to epoch (default: all)
%       freqband: 'CAR','HFB',or 'Spec'
%       locktype: 'stim' or 'resp' (which event epoched data is locked to)
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%               can group multiple conds together by having a cell of cells
%               (e.g. conds = {{'math'},{'autobio','self-internal'}})
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       noise_method:   how to exclude data (default: 'trial'):
%                       'none':     no epoch rejection
%                       'trial':    exclude noisy trials (set to NaN)
%                       'timepts':  set noisy timepoints to NaN but don't exclude entire trials
%       ROLparams:    (see genROLParams.m script)


if isempty(elecs)
    % load globalVar (just to get ref electrode, # electrodes)
    load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end

if isempty(freqband)
    freqband = 'HFB';
end

if isempty(ROLparams)
    ROLparams = genROLParams();
end

load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])

dir_in = [dirs.data_root,filesep,'BandData',filesep,freqband,filesep,sbj_name,filesep,block_names{1},'/EpochData/'];
load(sprintf('%s/%siEEG_stimlock_bl_corr_%s_%.2d.mat',dir_in,freqband,block_names{1},elecs(1)));
% ntrials = size(data.trialinfo,1);
nstim = size(data.trialinfo.allonsets,2); % (max) number of stim per trial

if strcmp(freqband,'Spec') % if spectral data, will average across specified freq. range
    freq_inds = find(data.freqs > ROLparams.freq_range(1) & data.freqs < ROLparams.freq_range(2));
end

% find onsets of each stim relative to first stim (in cases where each
% trial has multiple stims)

fs = data.fsample;
winSize = floor(fs*ROLparams.smwin);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

if isempty(conds)
    conds = unique(data.trialinfo.(column));
end

% if multiple stim per trial, get onset of each stim (relative to 1st stim)
stimtime = [0 cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)))];
if strcmp(project_name,'Memoria')&& ROLparams.firststim
    stimtime=0;
    nstim =1;
end
stiminds = nan(size(stimtime));
for i = 1:length(stimtime)
    stiminds(i)= find(data.time>stimtime(i),1);
end

befInd = round(ROLparams.pre_event * fs);
aftInd = round(ROLparams.dur * fs);
time = (befInd:aftInd)/fs;

%% loop

for ci = 1:length(conds)
    cond = conds{ci};
    ROL.(cond).thr = cell(globalVar.nchan,nstim);
    if ROLparams.linfit
        ROL.(cond).fit = cell(globalVar.nchan,nstim);
    end
    %     HFB_trace_bc.(cond) = cell(globalVar.nchan,nstim);
    %     ROL.(cond).HFB_trace_bc = cell(globalVar.nchan,nstim);
    ROL.(cond).traces = cell(globalVar.nchan,nstim);
    %     HFB_trace_bs.(cond) = cell(globalVar.nchan,nstim);
    sig.(cond) = cell(globalVar.nchan,nstim);
end

concatfield = {'wave'};
tag = 'stimlock';
if ROLparams.blc
    tag = [tag,'_bl_corr'];
end

disp('Concatenating data across blocks...')
for ei = 1:length(elecs)
    el = elecs(ei);
    data_all = concatBlocks(sbj_name,block_names,dirs,el,freqband,'Band',concatfield,tag);
    %     if ROLparams.power
    %         data_all.wave = data_all.wave.^2;
    %     end
    %     if strcmp(datatype,'Spec')
    %         data_all.wave = squeeze(nanmean(data_all.wave(freq_inds,:,:)));
    %     end
    if (ROLparams.smooth)
        data_all.wave = convn(data_all.wave,gusWin','same');
    end
    [grouped_trials,grouped_condnames] = groupConds(conds,data_all.trialinfo,column,ROLparams.noise_method,ROLparams.noise_fields_trials,false);
    [grouped_trials_all,~] = groupConds(conds,data_all.trialinfo,column,'none',ROLparams.noise_fields_trials,false);
    nconds = length(grouped_trials);
    for ci = 1:nconds
        cond = grouped_condnames{ci};
        bad_trials = setdiff(grouped_trials_all{ci},grouped_trials{ci});
        bad_trials = find(ismember(grouped_trials_all{ci},bad_trials));
        for ii = 1:nstim
            %             sig.(cond){el,ii} = [sig.(cond){el,ii}; data_all.wave(grouped_trials_all{ci},stiminds(ii)+befInd:stiminds(ii)+aftInd)];
            sig.(cond){el,ii} = data_all.wave(grouped_trials_all{ci},stiminds(ii)+befInd:stiminds(ii)+aftInd);
            sig.(cond){el,ii}(bad_trials,:)=NaN;
        end
    end
end
disp('DONE')

for ei = 1:length(elecs)
    el = elecs(ei);
    for ci = 1:length(conds)
        cond = grouped_condnames{ci};
        for ii = 1:nstim
            data.wave = sig.(cond){el,ii};
            data.time = time;
            if ~isempty(data.wave)
                %                 [Resp_data]= ROLbootstrap(data, ROLparams);
                Resp_data = getROL(data, ROLparams);
                ROL.(cond).thr{el,ii} = Resp_data.thr;
                if ROLparams.linfit
                    ROL.(cond).fit{el,ii} = Resp_data.fit;
                end
            end
            %             ROL.(cond).HFB_trace_bc{el,ii}=Resp_data.trace_bc;
            ROL.(cond).traces{el,ii}=Resp_data.traces;
        end
    end
    disp(['Computing ROL for elec: ',num2str(el)])
end

dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep];
if ~exist([dir_out,'ROL'])
    mkdir(dir_out,'ROL')
end
if ROLparams.firststim
    if ROLparams.bootstrap
        save([dir_out,'ROL',filesep,'ROL_bs_first_stim_',sbj_name,region,'.mat'],'ROL','ROLparams')
    else
        save([dir_out,'ROL',filesep,'ROL_no_bs_first_stim_',sbj_name,region,'.mat'],'ROL','ROLparams')
    end
else
    if ROLparams.bootstrap
        save([dir_out,'ROL',filesep,'ROL_bs_',sbj_name,region,'.mat'],'ROL','ROLparams')
    else
        save([dir_out,'ROL',filesep,'ROL_no_bs_',sbj_name,region,'.mat'],'ROL','ROLparams')
    end
end
