% Radar specific parameters to be calculated
% This function is to be cleaned after removing some parameters 
% (excess time etc.)
function params = additional_radar_params(params)

    %Derived radar frame parameters
    params.T_active = params.N_ADC/params.Fs;
    params.T_ramp = params.T_start + params.T_active + params.T_excess;
    params.T_chirp = params.T_idle + params.T_ramp;
    params.T_gap = params.T_idle + params.T_start + params.T_excess;
    params.BW_active = params.S*params.T_active;
    params.BW_total = params.S*params.T_chirp;
    params.fc = params.F0 + params.S*((params.T_active/2)+params.T_start);
    params.f_step = params.S/params.Fs;
    params.T_PRI = params.radar_channel_taps/params.Fs;  % Pulse repetition interval in seconds, for Doppler processing in FMCW radar                                       

end