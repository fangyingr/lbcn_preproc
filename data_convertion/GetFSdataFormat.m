function [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center)


if strcmp(center, 'Stanford')
    
    sbj_name_split = strsplit(sbj_name, '_');
    sbj_ind = sbj_name_split{2};
    num_inds = find(ismember(sbj_ind,'0123456789')); % for cases where sbj number has letter appended (e.g. 69b)
    if length(num_inds)<length(sbj_ind) % if sbj_ind has letters (e.g. A,B)
        if ismember(sbj_ind,{'69b','89b','81b'})
            fs_iEEG = 1000;
            fs_Pdio = 1000;
            data_format = 'edf';
        end
    else % if only number
        sbj_number = str2num(sbj_ind);
        
        
        if sbj_number < 48
            fs_iEEG = 3051.76;
            fs_Pdio = 24414.1;
            data_format = 'TDT';
            
        elseif (sbj_number > 47) && (sbj_number < 87)
            fs_iEEG = 1525.88;
            fs_Pdio = 24414.1;
            data_format = 'TDT';
            
        elseif sbj_number > 86
            fs_iEEG = 1000;
            fs_Pdio = 1000;
            data_format = 'edf';
        end
    end
elseif strcmp(center, 'China')
    fs_iEEG = 2000;
    fs_Pdio = 2000;
    data_format = 'edf';
    
end

% Add exceptions for subjects who came twice between system change
if strcmp(sbj_name, 'S17_69_RTb')
    fs_iEEG = 1000;
    fs_Pdio = 1000;
    data_format = 'edf';
else
end



end