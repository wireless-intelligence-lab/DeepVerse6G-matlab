% Antenna array dimensions
params.num_ant_BS = [32, 1, 1];      % Number of antenna elements for the BS arrays in the x,y,z-axes
% By defauly, all BSs will have the same array sizes
% To define different array sizes for the selected active BSs, you can add multiple rows. 
% Example: For two active BSs with a 8x4 y-z UPA in the first BS and 4x4
% x-z UPA for the second BS, you write  
% params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

params.num_ant_UE = [1, 1, 1];      % Number of antenna elements for the user arrays in the x,y,z-axes

% Antenna array orientations
params.activate_array_rotation = 0; % 0 -> no array rotation - 1 -> apply the array rotation defined in params.array_rotation_BS and params.array_rotation_UE
params.array_rotation_BS = [5, 10, 20];         
% 3D rotation angles in degrees around the x,y,z axes respectively
% The origin of these rotations is the position of the first BS antenna element
% The rotation sequence applied: (a) rotate around z-axis, then (b) rotate around y-axis, then (c) rotate around x-axis. 
% To define different orientations for the active BSs, add multiple rows..
% Example: For two active BSs with different array orientations, you can define
% params.array_rotation_BS = [[10, 30, 45]; [0, 30, 0]];

params.array_rotation_UE = [0, 30, 0];      
% User antenna orientation settings
% For uniform random selection in
% [x_min, x_max], [y_min, y_max], [z_min, z_max]
% set [[x_min, x_max]; [y_min, y_max]; [z_min, z_max]]
% params.array_rotation_UE = [[0, 30]; [30, 60]; [60, 90]]; 

% % % params.enable_BS2BSchannels = 1;      % Enable generating BS to BS channel (could be useful for IAB, RIS, repeaters, etc.) 

% Antenna array spacing
params.ant_spacing_BS = .5;           % ratio of the wavelength; for half wavelength enter .5
params.ant_spacing_UE = .5;           % ratio of the wavelength; for half wavelength enter .5

% Antenna element radiation pattern
params.radiation_pattern = 0;         % 0: Isotropic and 
                                      % 1: Half-wave dipole
                                    
% System parameters
params.bandwidth = 0.05;              % The bandwidth in GHz
params.activate_RX_filter = 0;        % 0 No RX filter 
                                      % 1 Apply RX low-pass filter (ideal: Sinc in the time domain)

% Channel parameters # Activate OFDM
params.generate_OFDM_channels = 1;    % 1: activate frequency domain (FD) channel generation for OFDM systems
                                      % 0: activate instead time domain (TD) channel impulse response generation
params.num_paths = 25;                 % Maximum number of paths to be considered (a value between 1 and 25), e.g., choose 1 if you are only interested in the strongest path

% OFDM parameters
params.num_OFDM = 512;                % Number of OFDM subcarriers
params.OFDM_sampling_factor = 1;      % The constructed channels will be calculated only at the sampled subcarriers (to reduce the size of the dataset)
params.OFDM_limit = 1;                % Only the first params.OFDM_limit subcarriers will be considered  

params.saveDataset = 0;               % 0: Will return the dataset without saving it (highly recommended!) 