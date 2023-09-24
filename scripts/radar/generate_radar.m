% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [radar_dataset, params] = generate_radar(params)

    % -------------------------- Radar Dataset Generation -----------------%
    fprintf(' Radar Dataset Generation started')

    [params, params_inner] = validate_radar_params(params);

    for f = 1:length(params_inner.list_of_folders)
        fprintf('\nGenerating Scene %i/%i', f, length(params_inner.list_of_folders))
        params_inner.scenario_files = params_inner.list_of_folders{f}; % The initial of all the scenario files

        Radar_scene{f} = generate_data(params, params_inner);
        param{f} = params;
    end

    radar_dataset = Radar_scene;
    params = param;

    fprintf('\n Radar Dataset Generation completed \n')

end

function radar_dataset = generate_data(radar_params, params_inner)
    % Reading ray tracing data
    for t=1:radar_params.num_active_BS
        bs_ID = radar_params.active_BS(t);
        % fprintf('\n Basestation %i', bs_ID);
        [~, TX{t}.channel_params_BSBS, TX{t}.loc] = read_raytracing(bs_ID, radar_params, params_inner, 0);
    end

    % Constructing the channel matrices from ray-tracing
    for t = 1:radar_params.num_active_BS % Loop over BS transceivers
        fprintf('\n Constructing the radar dataset for BS %d', radar_params.active_BS(t))
        c = progress_counter(radar_params.num_active_BS);

        % BS transmitter location & rotation
        radar_dataset{t}.loc = TX{t}.loc;
        radar_dataset{t}.rotation = params_inner.array_rotation_TX(t,:);

        %----- BS-BS radar signals (monostatic and bistatic radar)
        for r = 1:radar_params.num_active_BS

            radar_dataset{t}.bs{r}.signal = construct_radar_signal(params_inner.num_ant_TX(t, :), params_inner.array_rotation_TX(t,:), params_inner.ant_FoV_TX(t,:), params_inner.ant_spacing_TX(t), params_inner.num_ant_RX(r, :), params_inner.array_rotation_RX(r,:), params_inner.ant_FoV_RX(r,:), params_inner.ant_spacing_RX(r), TX{t}.channel_params_BSBS(r), radar_params);
            radar_dataset{t}.bs{r}.rotation = params_inner.array_rotation_RX(r, :);

            % Location, LOS status, distance, pathloss, and channel path parameters
            radar_dataset{t}.bs{r}.loc=TX{t}.channel_params_BSBS(r).loc;
            radar_dataset{t}.bs{r}.LoS_status=TX{t}.channel_params_BSBS(r).LoS_status;
            radar_dataset{t}.bs{r}.distance=TX{t}.channel_params_BSBS(r).distance;
            radar_dataset{t}.bs{r}.pathloss=TX{t}.channel_params_BSBS(r).pathloss;
            radar_dataset{t}.bs{r}.path_params=rmfield(TX{t}.channel_params_BSBS(r),{'loc','distance','pathloss'});

            c.increment();
        end
    end

end