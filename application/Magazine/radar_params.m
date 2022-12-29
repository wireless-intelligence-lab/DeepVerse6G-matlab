%%%% DeepSense Synth radar parameters set %%%%
% A detailed description of the parameters is available on ... 

% Antenna array dimensions
params.num_ant_TX = [1, 1, 1];      % Number of antenna elements for the radar TX arrays at the BS in the x,y,z-axes
% By defauly, all BSs will have the same array sizes
% To define different array sizes for the selected active TX BSs, you can add multiple rows. 
% Example: For two active BSs with a 8x4 y-z UPA in the first BS and 4x4
% x-z UPA for the second BS, you write  
% params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

params.num_ant_RX = [8, 1, 1];      % Number of antenna elements for the radar RX arrays at the BS in the x,y,z-axes
% To define different array sizes for the selected active TX BSs, you can add multiple rows. 
% Example: For two active BSs with a 8x4 y-z UPA in the first BS and 4x4
% x-z UPA for the second BS, you write  
% params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

% Antenna array orientations
params.activate_array_rotation = 0; % 0 -> no array rotation - 1 -> apply the array rotation defined in params.array_rotation_TX and params.array_rotation_RX
params.array_rotation_TX = [5, 10, 20];         
% 3D rotation angles in degrees around the x,y,z axes respectively
% The origin of these rotations is the position of the first BS antenna element
% The rotation sequence applied: (a) rotate around z-axis, then (b) rotate around y-axis, then (c) rotate around x-axis. 
% To define different orientations for the active TX BSs, add multiple rows..
% Example: For two active BSs with different transmit array orientations, you can define
% params.array_rotation_TX = [[10, 30, 45]; [0, 30, 0]];

params.array_rotation_RX = [5, 10, 20]; 
% Radar RX antenna array orientation settings
% To define different orientations for the active RX BSs, add multiple rows..
% Example: For two active BSs with different transmit array orientations, you can define
% params.array_rotation_RX = [[10, 30, 45]; [0, 30, 0]];

% Antenna array spacing
params.ant_spacing_TX = .5;           % ratio of the wavelength; for half wavelength enter .5
params.ant_spacing_RX = .5;           % ratio of the wavelength; for half wavelength enter .5

% Antenna element radiation pattern
params.radiation_pattern = 0;         % 0: Isotropic and 
                                            % 1: Half-wave dipole
params.radar_channel_taps = 5000; % Radar channel tap length to generate a time domain radar channel impulse response for one "chirp burst"
% params.scene_frequency = 30; %Hz %%%%%%%%%%%%%%%% DEBUG!!! %%%%%%%%%%%% 

%Chirp configuration parameters
params.S = 15e12;
params.Fs = 15e6;
params.N_ADC = 512;
params.N_loop = 128;  % Number of chirp bursts (minimum of 1)
params.T_idle = 7e-6;
params.T_start = 4.22e-6;
params.T_excess = 1e-6;
params.duty_cycle = 1;
params.F0 = 28e9 - params.S*params.T_start;

%Derived radar frame parameters
params.T_active = params.N_ADC/params.Fs;
params.T_ramp = params.T_start + params.T_active + params.T_excess;
params.T_chirp = params.T_idle + params.T_ramp;
% params.T_gap = params.T_chirp - params.T_active;
params.T_gap = params.T_idle + params.T_start + params.T_excess;
params.BW_active = params.S*params.T_active;
params.BW_total = params.S*params.T_chirp;
params.fc = params.F0 + params.S*((params.T_active/2)+params.T_start);
params.f_step = params.S/params.Fs;
params.T_PRI = params.radar_channel_taps/params.Fs;  % Pulse repetition interval in seconds, for Doppler processing in FMCW radar                                       

% Channel parameter
params.num_paths = 5000;                 % Maximum number of paths to be considered (starting from 1), e.g., choose 1 if you are only interested in the strongest path

% Computation parameter
params.comp_speed = 5;                 % control the compromise between computational speed and memory requirement 
                                             % (defined between 1 and 5), e.g., choose 5 if you are only interested in the fastest computation with the largest memeory requirement  

params.saveDataset = 0;               % 0: Will return the dataset without saving it (highly recommended!) 