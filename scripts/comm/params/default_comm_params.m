%%%% DeepVerse Default Communication Parameters %%%%
% Parameters
comm.enable = true;
comm.num_ant_BS = [16, 1];
comm.num_ant_UE = [1, 1];
comm.array_rotation_BS = [0, 0, 0];         
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

%%%% Additional Parameters for this file %%%%
% Parameters that need to exist in the default params file
% These are defined by the DeepVerse Generator - general params
comm.active_BS = [];
comm.scenario = [];   
comm.scenes = [];
comm.scenario_folder = [];

% Additional fields for the adapted generator (possibly to be cleaned)
comm.num_active_users = 1;
comm.enable_BS2BSchannels = 1;