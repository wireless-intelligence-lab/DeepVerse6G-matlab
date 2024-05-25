% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [radar_dataset, params] = generate_radar(params)
    % Generates radar dataset based on provided parameters
    
    % -------------------------- Radar Dataset Generation -----------------%
    fprintf('Radar Dataset Generation started\n');
    
    % Validate and prepare radar parameters
    [params, params_inner] = validate_radar_params(params);

    % Initialize output variables
    radar_dataset = cell(1, length(params_inner.list_of_folders));
    param = cell(1, length(params_inner.list_of_folders));
    
    for f = 1:length(params_inner.list_of_folders)
        fprintf('Generating Scene %i/%i\n', f, length(params_inner.list_of_folders));
        params_inner.scenario_files = params_inner.list_of_folders{f}; % Initial scenario files

        radar_dataset{f} = generate_data(params, params_inner);
        param{f} = params;
    end
    
    params = param; % Assign output parameters
    fprintf('Radar Dataset Generation completed\n');
end

function radar_dataset = generate_data(radar_params, params_inner)
    % Generates data for radar based on parameters
    
    % Reading ray tracing data for each active base station
    TX = cell(1, radar_params.num_active_BS);
    for t = 1:radar_params.num_active_BS
        bs_ID = radar_params.active_BS(t);
        [~, TX{t}.channel_params_BSBS, TX{t}.loc] = read_raytracing(bs_ID, radar_params, params_inner, 0);
    end

    % Constructing the radar dataset
    radar_dataset = cell(1, radar_params.num_active_BS);
    for t = 1:radar_params.num_active_BS % Loop over base stations
        fprintf('Constructing the radar dataset for BS %d\n', radar_params.active_BS(t));

        radar_dataset{t}.loc = TX{t}.loc;
        radar_dataset{t}.rotation = params_inner.array_rotation_TX(t,:);

        % Construct radar signals for monostatic and bistatic radar
        for r = 1:radar_params.num_active_BS
            radar_dataset{t}.bs{r} = construct_bs_radar_signal(TX{t}.channel_params_BSBS(r), params_inner, radar_params, t, r);
        end
    end
end

function bs_radar = construct_bs_radar_signal(channel_params, params_inner, radar_params, t, r)

    % Constructs radar signal for a base station
    bs_radar.signal = construct_radar_signal(params_inner.num_ant_TX(t, :), params_inner.array_rotation_TX(t,:), params_inner.ant_FoV_TX(t,:), params_inner.ant_spacing_TX(t), params_inner.num_ant_RX(r, :), params_inner.array_rotation_RX(r,:), params_inner.ant_FoV_RX(r,:), params_inner.ant_spacing_RX(r), channel_params, radar_params);
    bs_radar.rotation = params_inner.array_rotation_RX(r, :);

    % Location, LOS status, distance, pathloss, and channel path parameters
    bs_radar.loc = channel_params.loc;
    bs_radar.LoS_status = channel_params.LoS_status;
    bs_radar.distance = channel_params.distance;
    bs_radar.pathloss = channel_params.pathloss;
    bs_radar.path_params = rmfield(channel_params, {'loc', 'distance', 'pathloss'});
end