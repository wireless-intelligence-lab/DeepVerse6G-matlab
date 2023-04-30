%% General Parameters
dv.dataset_folder = '.\scenarios';
dv.scenario = 'Scenario 1';

dv.basestations = [3]; % Basestations to be included
dv.scenes=[1996:2000];

dv.communication = false;
dv.communication_parameters = '';

dv.radar = true;
dv.radar_parameters = '';

dv.camera = false;
dv.camera_id = [1, 2, 3];

dv.lidar = false;
dv.position = false;

%% Comm
comm.num_ant_BS = [64, 1, 1];
comm.num_ant_UE = [1, 1, 1];
comm.activate_array_rotation = 0;
comm.array_rotation_BS = [5, 10, 20];
comm.array_rotation_UE = [0, 30, 0];
comm.ant_spacing_BS = .5;
comm.ant_spacing_UE = .5;
comm.bandwidth = 0.02;
comm.activate_RX_filter = 0;
comm.generate_OFDM_channels = 1;
comm.num_paths = 25;
comm.num_OFDM = 64;
comm.OFDM_sampling_factor = 1;
comm.OFDM_limit = 64;
comm.enable_Doppler = 0;

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
radar.N_samples = 512;
radar.N_chirp = 128;
radar.num_paths = 5000;
radar.comp_speed = 5;
