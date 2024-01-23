%%%% DeepVerse Default Radar Parameters %%%%
radar.enable = true;
radar.num_ant_TX = [1, 1];
radar.num_ant_RX = [16, 1];
radar.activate_array_rotation = 0;
radar.array_rotation_TX = [5, 10, 20];         
radar.array_rotation_RX = [5, 10, 20]; 
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

%%%% Additional Parameters for this file %%%%
% Parameters that need to exist in the default params file
% These are defined by the DeepVerse Generator - general params
radar.active_BS = [];
radar.scenario = [];   
radar.scenes = [];