%%%% DeepVerse Default Radar Parameters %%%%
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
radar.T_PRI = radar.N_samples/radar.Fs;
%radar.T_idle = 7e-6;
%radar.T_start = 4.22e-6;
%radar.T_excess = 1e-6;
%radar.duty_cycle = 1;
radar.num_paths = 500; 
radar.comp_speed = 5;

%%%% Additional Parameters for this file %%%%
% Parameters that need to exist in the default params file
% These are defined by the DeepVerse Generator - general params
radar.active_BS = [];
radar.scenario = [];   
radar.scene_first = [];
radar.scene_last = [];
radar.BS_ID_map = [];
