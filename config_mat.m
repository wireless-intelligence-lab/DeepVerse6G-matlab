%% General Parameters
dv.dataset_folder = 'D:/Deepverse_data/scenarios';
dv.scenario = 'DT31';

dv.scenes = [1:2];

dv.basestations = [1];
dv.comm.enable = true;
dv.radar.enable = true;

dv.camera = true;
dv.camera_id = ["unit1_cam1"];

dv.lidar = true;
dv.lidar_id = ["unit1_lidar1"];

dv.position = true;

%% Comm
dv.comm.bs_antenna.shape = [16, 1];
dv.comm.bs_antenna.rotation = [0, 0, -45.04];
dv.comm.bs_antenna.spacing = 0.5;
dv.comm.bs_antenna.FoV = [360, 180];

dv.comm.ue_antenna.shape = [1, 1];
dv.comm.ue_antenna.rotation = [0, 0, 0];
dv.comm.ue_antenna.spacing = 0.5;
dv.comm.ue_antenna.FoV = [360, 180];

dv.comm.OFDM.bandwidth = 0.05;
dv.comm.OFDM.subcarriers = 512;
dv.comm.OFDM.selected_subcarriers = [0:7];

dv.comm.activate_RX_filter = 0;
dv.comm.generate_OFDM_channels = 1;
dv.comm.num_paths = 5000;
dv.comm.enable_Doppler = 1;

%% Radar
dv.radar.tx_antenna.shape = [1, 1];
dv.radar.tx_antenna.rotation = [0, 0, -45.04];
dv.radar.tx_antenna.spacing = 0.5;
dv.radar.tx_antenna.FoV = [180, 180];

dv.radar.rx_antenna.shape = [16, 1];
dv.radar.rx_antenna.rotation = [0, 0, -45.04];
dv.radar.rx_antenna.spacing = 0.5;
dv.radar.rx_antenna.FoV = [180, 180];

dv.radar.FMCW.chirp_slope = 8.014e12;
dv.radar.FMCW.Fs = 6.2e6;
dv.radar.FMCW.n_samples_per_chirp = 256;
dv.radar.FMCW.n_chirps = 256;

dv.radar.num_paths = 500;