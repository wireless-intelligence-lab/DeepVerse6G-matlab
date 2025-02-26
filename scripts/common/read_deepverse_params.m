% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function dv_ = read_deepverse_params(filename)

    run(filename);
    dv_ = struct();
    dv_.comm = struct();
    dv_.radar = struct();
    
    %% General Parameters
    dv_.dataset_folder = dv.dataset_folder;
    dv_.scenario = dv.scenario ;
    
    dv_.scenes = dv.scenes;
    
    dv_.basestations = dv.basestations;
    dv_.comm.enable = dv.comm.enable;
    dv_.radar.enable = dv.radar.enable;
    
    dv_.camera = dv.camera;
    dv_.camera_id = dv.camera_id;
    
    dv_.lidar = dv.lidar;
    dv_.lidar_id = dv.lidar_id;
    
    dv_.position = dv.position;
    
    %% Comm
    dv_.comm.num_ant_BS = dv.comm.bs_antenna.shape;
    dv_.comm.array_rotation_BS = dv.comm.bs_antenna.rotation;
    dv_.comm.ant_spacing_BS = dv.comm.bs_antenna.spacing;
    dv_.comm.ant_FoV_BS = dv.comm.bs_antenna.FoV;
    
    dv_.comm.num_ant_UE = dv.comm.ue_antenna.shape;
    dv_.comm.array_rotation_UE = dv.comm.ue_antenna.rotation;
    dv_.comm.ant_spacing_UE = dv.comm.ue_antenna.spacing;
    dv_.comm.ant_FoV_UE = dv.comm.ue_antenna.FoV;
    
    dv_.comm.bandwidth = dv.comm.OFDM.bandwidth;
    dv_.comm.num_OFDM = dv.comm.OFDM.subcarriers;
    dv_.comm.OFDM_sampling = dv.comm.OFDM.selected_subcarriers;
    
    dv_.comm.activate_RX_filter = dv.comm.activate_RX_filter;
    dv_.comm.generate_OFDM_channels = dv.comm.generate_OFDM_channels;
    dv_.comm.num_paths = dv.comm.num_paths;
    dv_.comm.enable_Doppler = dv.comm.enable_Doppler;
    
    %% Radar
    dv_.radar.num_ant_TX = dv.radar.tx_antenna.shape;
    dv_.radar.array_rotation_TX = dv.radar.tx_antenna.rotation;
    dv_.radar.ant_spacing_TX = dv.radar.tx_antenna.spacing;
    dv_.radar.ant_FoV_TX = dv.radar.tx_antenna.FoV;
    
    dv_.radar.num_ant_RX = dv.radar.rx_antenna.shape;
    dv_.radar.array_rotation_RX = dv.radar.rx_antenna.rotation;
    dv_.radar.ant_spacing_RX = dv.radar.rx_antenna.spacing;
    dv_.radar.ant_FoV_RX = dv.radar.rx_antenna.FoV;
    
    dv_.radar.S = dv.radar.FMCW.chirp_slope;
    dv_.radar.Fs = dv.radar.FMCW.Fs;
    dv_.radar.N_samples = dv.radar.FMCW.n_samples_per_chirp;
    dv_.radar.N_chirp = dv.radar.FMCW.n_chirps;
    
    dv_.radar.num_paths = dv.radar.num_paths;
end



