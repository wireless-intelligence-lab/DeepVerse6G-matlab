%% General Parameters
dv.dataset_folder = '..\..\DV_Scenarios';
dv.scenario = 'Scenario 1';

dv.basestations = [1]; % Basestations to be included
dv.scenes = [1:2000]; % Scenes to be included
    
dv.communication = true;
dv.communication_parameters = '';

dv.radar = false;
dv.radar_parameters = '';

dv.camera = true;
dv.camera_id = [1, 2, 3];

dv.lidar = false;
dv.position = true;

%% Comm
comm.num_ant_BS = [32, 1, 1];
comm.num_ant_UE = [1, 1, 1];
comm.activate_array_rotation = 0;
comm.array_rotation_BS = [5, 10, 20];
comm.array_rotation_UE = [0, 30, 0];
comm.ant_spacing_BS = .5;
comm.ant_spacing_UE = .5;
comm.bandwidth = 0.05;
comm.activate_RX_filter = 0;
comm.generate_OFDM_channels = 1;
comm.num_paths = 25;
comm.num_OFDM = 512;
comm.OFDM_sampling_factor = 1;
comm.OFDM_limit = 1; 

%% Radar
radar.num_ant_TX = [1, 1, 1];
radar.num_ant_RX = [16, 1, 1];
radar.activate_array_rotation = 0;
radar.array_rotation_TX = [5, 10, 20];
radar.array_rotation_RX = [5, 10, 20];
radar.ant_spacing_TX = .5;
radar.ant_spacing_RX = .5;
radar.S = 15e12;
radar.Fs = 15e6;
radar.N_ADC = 512;
radar.N_loop = 128;
radar.T_idle = 7e-6;
radar.T_start = 4.22e-6;
radar.T_excess = 1e-6;
radar.duty_cycle = 1;
radar.F0 = 28e9 - radar.S*radar.T_start;
radar.num_paths = 500;
radar.radar_channel_taps = 1000; 
radar.comp_speed = 5;