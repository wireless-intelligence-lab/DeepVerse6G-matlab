%% General Parameters
dv.dataset_folder = 'D:\abhilash\';
dv.scenario = 'Carla-Town01';

dv.basestations = [1]; % Basestations to be included
dv.scenes = [1]; % Scenes to be included
    
dv.comm.enable = false;
dv.radar.enable = true;

dv.camera = false;
dv.camera_id = [1, 2, 3, 4, 5];

dv.lidar = false;
dv.position = false;

%% Comm
dv.comm.num_ant_BS = [32, 1];
dv.comm.num_ant_UE = [1, 1];
dv.comm.array_rotation_BS = [5, 10, 20];
dv.comm.array_rotation_UE = [0, 30, 0];
dv.comm.ant_FoV_BS = [360, 180];
dv.comm.ant_FoV_UE = [360, 180];
dv.comm.ant_spacing_BS = .5;
dv.comm.ant_spacing_UE = .5;
dv.comm.bandwidth = 0.05;
dv.comm.activate_RX_filter = 0;
dv.comm.generate_OFDM_channels = 1;
dv.comm.num_paths = 25;
dv.comm.num_OFDM = 512;
dv.comm.OFDM_sampling = [1:8];
dv.comm.enable_Doppler = 1;

%% Radar
dv.radar.num_ant_TX = [1, 1];
dv.radar.num_ant_RX = [32, 1];
dv.radar.array_rotation_TX = [0, 0, -90];
dv.radar.array_rotation_RX = [0, 0, -90];
dv.radar.ant_FoV_TX = [180, 180];
dv.radar.ant_FoV_RX = [180, 180];
dv.radar.ant_spacing_TX = .5;
dv.radar.ant_spacing_RX = .5;
dv.radar.S = 15e12;
dv.radar.Fs = 4e6;
dv.radar.N_samples = 512;
dv.radar.N_chirp = 128;
dv.radar.num_paths = 20000;
dv.radar.comp_speed = 5;