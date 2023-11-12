% --------- DeepMIMO: A Generic Dataset for mmWave and massive MIMO ------%
% Authors: Umut Demirhan, Abdelrahman Taha, Ahmed Alkhateeb
% Date: March 17, 2022
% Goal: Encouraging research on ML/DL for MIMO applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [channel_params_user, channel_params_BS, BS_loc] = read_raytracing(BS_ID, params, params_inner, comm)

    data_key_name = 'channels';
    num_paths = double(params.num_paths);
    tx_power_raytracing = params.transmit_power_raytracing;  % Current TX power in dBm
    transmit_power = 30; % Target TX power in dBm (1 Watt transmit power)
    power_diff = transmit_power-tx_power_raytracing;
    channel_params_all = struct('phase',[],'ToA',[],'power',[],'DoA_phi',[],'DoA_theta',[],'DoD_phi',[],'DoD_theta',[],'LoS_status',[],'num_paths',[],'loc',[],'distance',[],'pathloss',[],'Doppler_vel',[],'Doppler_acc',[]);
    channel_params_all_BS = struct('phase',[],'ToA',[],'power',[],'DoA_phi',[],'DoA_theta',[],'DoD_phi',[],'DoD_theta',[],'LoS_status',[],'num_paths',[],'loc',[],'distance',[],'pathloss',[],'Doppler_vel',[],'Doppler_acc',[]);

    if comm

        dc = duration_check(params.symbol_duration);

        file_idx = 1;
        file_loaded = 0;
        user_count = 1;

        if ~isempty(params_inner.UE_file_split)
            params.num_user = params_inner.UE_file_split(2, file_idx);
            filename = strcat('BS', num2str(BS_ID), '_UE_', num2str(params_inner.UE_file_split(1, params_inner.gen_idx)), '-', num2str(params_inner.UE_file_split(2, params_inner.gen_idx)), '.mat');
            data = importdata(fullfile(params_inner.scenario_files, filename));
            user_start = params_inner.UE_file_split(1, params_inner.gen_idx);

            for ue_idx = 1:params_inner.UE_file_split(2, params_inner.gen_idx)
                ue_idx_file = ue_idx - user_start;
                max_paths = double(size(data.(data_key_name){ue_idx_file}.p, 2));
                num_path_limited = double(min(num_paths, max_paths));

                channel_params = data.(data_key_name){ue_idx_file}.p;
                add_info = data.rx_locs(ue_idx_file, :);
                channel_params_all(user_count) = parse_data(num_path_limited, channel_params, add_info, power_diff);
                dc.add_ToA(channel_params_all(user_count).power, channel_params_all(user_count).ToA);

                user_count = user_count + 1;
            end
        else
            params.num_user = 0;
        end

        channel_params_user = channel_params_all(1,:);

        dc.print_warnings('BS', BS_ID);
        dc.reset()
    end
    %% Loading channel parameters between current active basesation transmitter and all the active basestation receivers
    user_count = 1;
    filename = strcat('BS', num2str(BS_ID), '_BS.mat');
    data = importdata(fullfile(params_inner.scenario_files, filename));
    for bs_idx = params.active_BS

        max_paths = double(size(data.(data_key_name){bs_idx}.p, 2));
        num_path_limited = double(min(num_paths, max_paths));

        channel_params = data.(data_key_name){bs_idx}.p;
        add_info = data.rx_locs(bs_idx, :);

        if bs_idx == BS_ID
            BS_loc = add_info(1:3);
        end

        channel_params_all_BS(user_count) = parse_data(num_path_limited, channel_params, add_info, power_diff);
        if comm
            dc.add_ToA(channel_params_all_BS(user_count).power, channel_params_all_BS(user_count).ToA);
        end
        user_count = user_count + 1;
    end

    channel_params_BS = channel_params_all_BS(1,:);

    if comm
        dc.print_warnings('BS', BS_ID);
        dc.reset()
    end

    if ~comm
        channel_params_user = 0;
    end
end

function x = parse_data(num_paths, paths, info, power_diff)
    if num_paths > 0
        x.phase = paths(1, 1:num_paths);
        x.ToA = paths(2, 1:num_paths);
        x.power = 1e-3*(10.^(0.1*(paths(3, 1:num_paths) + power_diff)));
        x.DoA_phi = paths(4, 1:num_paths);
        x.DoA_theta = paths(5, 1:num_paths);
        x.DoD_phi = paths(6, 1:num_paths);
        x.DoD_theta = paths(7, 1:num_paths);
        x.LoS_status = paths(8, 1:num_paths);
        x.Doppler_vel = paths(9, 1:num_paths);
        x.Doppler_acc = paths(10, 1:num_paths);
    else
        x.phase = [];
        x.ToA = [];
        x.power = [];
        x.DoA_phi = [];
        x.DoA_theta = [];
        x.DoD_phi = [];
        x.DoD_theta = [];
        x.LoS_status = [];
        x.Doppler_vel = [];
        x.Doppler_acc = [];
    end

    %add_info = data.rx_locs(ue_idx_file, :);
    x.num_paths = num_paths;
    x.loc = info(1:3);
    x.distance = info(4);
    x.pathloss = info(5);
end
