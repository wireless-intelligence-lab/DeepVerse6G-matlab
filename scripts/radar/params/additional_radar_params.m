% Radar specific parameters to be calculated
% This function is to be cleaned after removing some parameters 
% (excess time etc.)
function params = additional_radar_params(params)

    %Derived radar frame parameters
    params.T_chirp = params.N_samples/params.Fs;
    params.BW = params.S*params.T_chirp;
    params.T_PRI = params.N_samples/params.Fs;
    wavelength = physconst('LightSpeed')/params.carrier_freq;
    
    params.radar_KPI.range_resolution = physconst('LightSpeed')/(2*params.BW);
    params.radar_KPI.max_detectable_range = params.radar_KPI.range_resolution*(params.N_samples-1);
    params.radar_KPI.velocity_resolution = wavelength/(2*params.T_PRI*params.N_chirp);
    params.radar_KPI.max_detectable_velocity = [-1 ((params.N_chirp-2)/params.N_chirp)]*(wavelength/(4*params.T_PRI));
    T_radar_frame = (params.N_chirp*params.T_PRI);
    params.radar_KPI.Radar_frame_rate = 1/T_radar_frame;
    % disp(params.radar_KPI)
    
end