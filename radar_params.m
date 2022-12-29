%%%% DeepSense Synth radar parameters set %%%%
% A detailed description of the parameters is available on ... 

% Antenna array dimensions
radar.num_ant_TX = [1, 1, 1];      % Number of antenna elements for the radar TX arrays at the BS in the x,y,z-axes
% By defauly, all BSs will have the same array sizes
% To define different array sizes for the selected active TX BSs, you can add multiple rows. 
% Example: For two active BSs with a 8x4 y-z UPA in the first BS and 4x4
% x-z UPA for the second BS, you write  
% params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

radar.num_ant_RX = [16, 1, 1];      % Number of antenna elements for the radar RX arrays at the BS in the x,y,z-axes
% To define different array sizes for the selected active TX BSs, you can add multiple rows. 
% Example: For two active BSs with a 8x4 y-z UPA in the first BS and 4x4
% x-z UPA for the second BS, you write  
% params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

% Antenna array orientations
radar.activate_array_rotation = 0; % 0 -> no array rotation - 1 -> apply the array rotation defined in params.array_rotation_TX and params.array_rotation_RX
radar.array_rotation_TX = [5, 10, 20];         
% 3D rotation angles in degrees around the x,y,z axes respectively
% The origin of these rotations is the position of the first BS antenna element
% The rotation sequence applied: (a) rotate around z-axis, then (b) rotate around y-axis, then (c) rotate around x-axis. 
% To define different orientations for the active TX BSs, add multiple rows..
% Example: For two active BSs with different transmit array orientations, you can define
% params.array_rotation_TX = [[10, 30, 45]; [0, 30, 0]];

radar.array_rotation_RX = [5, 10, 20]; 
% Radar RX antenna array orientation settings
% To define different orientations for the active RX BSs, add multiple rows..
% Example: For two active BSs with different transmit array orientations, you can define
% params.array_rotation_RX = [[10, 30, 45]; [0, 30, 0]];

% Antenna array spacing
radar.ant_spacing_TX = .5;           % ratio of the wavelength; for half wavelength enter .5
radar.ant_spacing_RX = .5;           % ratio of the wavelength; for half wavelength enter .5

% params.scene_frequency = 30; %Hz %%%%%%%%%%%%%%%% DEBUG!!! %%%%%%%%%%%% 

%Chirp configuration parameters
radar.S = 15e12;
radar.Fs = 15e6;
radar.N_ADC = 512;
radar.N_loop = 128;  % Number of chirp bursts (minimum of 1)
radar.T_idle = 7e-6;
radar.T_start = 4.22e-6;
radar.T_excess = 1e-6;
radar.duty_cycle = 1;
radar.F0 = 28e9 - radar.S*radar.T_start;

% Channel parameter
radar.num_paths = 500;                 % Maximum number of paths to be considered (starting from 1), e.g., choose 1 if you are only interested in the strongest path
radar.radar_channel_taps = 1000; 

% Computation parameter
radar.comp_speed = 5;                 % control the compromise between computational speed and memory requirement 
                                             % (defined between 1 and 5), e.g., choose 5 if you are only interested in the fastest computation with the largest memeory requirement  