% Radar specific parameters to be calculated
% This function is to be cleaned after removing some parameters 
% (excess time etc.)
function params = additional_radar_params(params)

    %Derived radar frame parameters
    params.T_chirp = params.N_ADC/params.Fs;
    params.BW = params.S*params.T_active;
    params.fc = params.F0; % To be fixed - params.f_c
    params.T_PRI = params.radar_channel_taps/params.Fs;  % Pulse repetition interval in seconds, for Doppler processing in FMCW radar                                       

    
    % Radar KPI - to go out
    radar_KPI.range_resolution = physconst('LightSpeed')/(2*params.BW);
    radar_KPI.max_detectable_range = radar_KPI.range_resolution*(N_ADC-1);
    radar_KPI.velocity_resolution = Wavelength/(2*params.T_PRI*params.N_loop);
    radar_KPI.max_detectable_velocity = [-1 ((params.N_loop-2)/params.N_loop)]*(Wavelength/(4*params.T_PRI));
    %radar_KPI.max_detectable_velocity2 = [-(params.N_loop/2) ((params.N_loop/2)-1)]*radar_KPI.velocity_resolution;
    %radar_KPI.azimuth_FOV = [-1 1]*asind(1/(2*params.ant_spacing_TX));
    %radar_KPI.elevation_FOV = [-1 1]*asind(1/(2*params.ant_spacing_TX));
    radar_KPI.T_radar_frame = (params.N_loop*params.T_PRI)/params.duty_cycle;
    radar_KPI.Radar_frame_rate = 1/T_radar_frame;
    
end