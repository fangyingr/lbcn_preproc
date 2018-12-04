function vid_params = genVidParams(project_name)

if strcmp(project_name,'Memoria')
    vid_params.t_stim = [0 1]; % time relative to each stim. onset
    vid_params.t_bl = [-0.5 0];
else
    vid_params.t_stim = [0 5];
    vid_params.t_bl = [-0.2 0];
end

