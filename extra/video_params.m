%% General Parameters
dv.dataset_folder = 'F:\Umut\Wireless-Verse';
dv.scenario = 'Carla-Town05';

dv.basestations = [1]; % Basestations to be included
dv.scenes = [300:2000]; % Scenes to be included
    
dv.communication = true;
dv.communication_parameters = '';

dv.radar = false;
dv.radar_parameters = '';

dv.camera = true;
dv.camera_id = [1, 2, 3, 4, 5];

dv.lidar = true;
dv.position = true;

%% Comm
comm.num_ant_BS = [32, 1];
comm.num_ant_UE = [1, 1];
comm.array_rotation_BS = [0, 0, -90];
comm.array_rotation_UE = [0, 0, 0];
comm.ant_FoV_BS = [360, 180];
comm.ant_FoV_UE = [360, 180];
comm.ant_spacing_BS = .5;
comm.ant_spacing_UE = .5;
comm.bandwidth = 0.05;
comm.activate_RX_filter = 0;
comm.generate_OFDM_channels = 1;
comm.num_paths = 25;
comm.num_OFDM = 512;
comm.OFDM_sampling = [1:8];
comm.enable_Doppler = 1;

%% Radar
radar.num_ant_TX = [1, 1];
radar.num_ant_RX = [16, 1];
radar.array_rotation_TX = [0, 0, -90];
radar.array_rotation_RX = [0, 0, 0];
radar.ant_FoV_TX = [360, 180];
radar.ant_FoV_RX = [360, 180];
radar.ant_spacing_TX = .5;
radar.ant_spacing_RX = .5;
radar.S = 15e12;
radar.Fs = 15e6;
radar.N_samples = 512;
radar.N_chirp = 128;
radar.num_paths = 500;
radar.comp_speed = 5;