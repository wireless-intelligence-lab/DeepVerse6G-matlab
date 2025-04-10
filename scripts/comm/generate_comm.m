% --------- DeepMIMO: A Generic Dataset for mmWave and massive MIMO ------%
% Authors: Ahmed Alkhateeb, Umut Demirhan, Abdelrahman Taha 
% Date: March 17, 2022
% Goal: Encouraging research on ML/DL for MIMO applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [COMM_dataset, params] = generate_comm(params)

    % -------------------------- DeepMIMO Dataset Generation -----------------%
    fprintf(' DeepMIMO Dataset Generation started')

    [params, params_inner] = validate_comm_params(params);

    for f = 1:length(params_inner.list_of_folders)
        fprintf('\nGenerating Scene %i/%i', f, length(params_inner.list_of_folders))
        params_inner.scenario_files = params_inner.list_of_folders{f}; % The initial of all the scenario files
        params_inner.gen_idx = f;
        COMM_scene{f} = generate_data(params, params_inner);
        param{f} = params;
    end

    COMM_dataset = COMM_scene;
    params = param;

    fprintf('\n COMM Dataset Generation completed \n')

end

function COMM_dataset = generate_data(params, params_inner)
    % Reading ray tracing data
    for t=1:params.num_active_BS
        bs_ID = params.active_BS(t);
        % fprintf('\n Basestation %i', bs_ID);
        [TX{t}.channel_params, TX{t}.channel_params_BSBS, TX{t}.loc] = read_raytracing(bs_ID, params, params_inner, 1);
    end

    % Constructing the channel matrices from ray-tracing
    for t = 1:params.num_active_BS
        % fprintf('\n Constructing the DeepMIMO Dataset for BS %d', params.active_BS(t))
        % c = progress_counter(params.num_active_users+params.enable_BS2BSchannels*params.num_active_BS);

        % BS transmitter location & rotation
        COMM_dataset{t}.loc = TX{t}.loc;
        COMM_dataset{t}.rotation = params_inner.array_rotation_BS(t,:);

        %----- BS-User Channels
        COMM_dataset{t}.ue = {};
        for user=1:length(TX{t}.channel_params)
            % Channel Construction

            if params.generate_OFDM_channels
                %construct_COMM_channel(tx_ant_size, tx_rotation, tx_FoV, tx_ant_spacing, rx_ant_size, rx_rotation, rx_FoV, rx_ant_spacing, path_params, params, params_inner)

                [COMM_dataset{t}.ue{user}.channel, channel_LoS_status, TX{t}.channel_params(user)]=construct_COMM_channel(params_inner.num_ant_BS(t, :), params_inner.array_rotation_BS(t,:), params_inner.ant_FoV_BS(t,:), params_inner.ant_spacing_BS(t), params.num_ant_UE, params_inner.array_rotation_UE(1, :), params.ant_FoV_UE, params.ant_spacing_UE, TX{t}.channel_params(user), params);
            else
                [COMM_dataset{t}.ue{user}.channel]=construct_COMM_channel_TD(params_inner.num_ant_BS(t, :), params_inner.array_rotation_BS(t,:), params_inner.ant_spacing_BS(t), params.num_ant_UE, params_inner.array_rotation_UE(1, :), params.ant_spacing_UE, TX{t}.channel_params(user), params);
                COMM_dataset{t}.ue{user}.ToA = TX{t}.channel_params(user).ToA; %Time of Arrival/Flight of each channel path (seconds)
            end
            COMM_dataset{t}.ue{user}.rotation = params_inner.array_rotation_UE(1, :);

            % Location, LOS status, distance, pathloss, and channel path parameters
            COMM_dataset{t}.ue{user}.loc=TX{t}.channel_params(user).loc;
            COMM_dataset{t}.ue{user}.LoS_status = channel_LoS_status;
            COMM_dataset{t}.ue{user}.distance=TX{t}.channel_params(user).distance;
            COMM_dataset{t}.ue{user}.pathloss=TX{t}.channel_params(user).pathloss;
            COMM_dataset{t}.ue{user}.path_params=rmfield(TX{t}.channel_params(user),{'loc','distance','pathloss'});

            % c.increment();
        end

        %----- BS-BS Channels
        if params.enable_BS2BSchannels
            for BSreceiver=1:params.num_active_BS
                % Channel Construction
                if params.generate_OFDM_channels
                    [COMM_dataset{t}.bs{BSreceiver}.channel, channel_LoS_status, TX{t}.channel_params_BSBS(BSreceiver)]=construct_COMM_channel(params_inner.num_ant_BS(t, :), params_inner.array_rotation_BS(t,:), params_inner.ant_FoV_BS(t,:), params_inner.ant_spacing_BS(t), params_inner.num_ant_BS(BSreceiver, :), params_inner.array_rotation_BS(BSreceiver,:), params_inner.ant_FoV_BS(BSreceiver,:), params_inner.ant_spacing_BS(BSreceiver), TX{t}.channel_params_BSBS(BSreceiver), params);
                else
                    [COMM_dataset{t}.bs{BSreceiver}.channel] = construct_COMM_channel_TD(params_inner.num_ant_BS(t, :), params_inner.array_rotation_BS(t,:), params_inner.ant_spacing_BS(t), params_inner.num_ant_BS(BSreceiver, :), params_inner.array_rotation_BS(BSreceiver,:), params_inner.ant_spacing_BS(BSreceiver), TX{t}.channel_params_BSBS(BSreceiver), params);
                    COMM_dataset{t}.bs{BSreceiver}.ToA=TX{t}.channel_params_BSBS(BSreceiver).ToA; %Time of Arrival/Flight of each channel path (seconds)
                end
                COMM_dataset{t}.bs{BSreceiver}.rotation = params_inner.array_rotation_BS(BSreceiver, :);

                % Location, LOS status, distance, pathloss, and channel path parameters
                COMM_dataset{t}.bs{BSreceiver}.loc=TX{t}.channel_params_BSBS(BSreceiver).loc;
                COMM_dataset{t}.bs{BSreceiver}.LoS_status=channel_LoS_status;
                COMM_dataset{t}.bs{BSreceiver}.distance=TX{t}.channel_params_BSBS(BSreceiver).distance;
                COMM_dataset{t}.bs{BSreceiver}.pathloss=TX{t}.channel_params_BSBS(BSreceiver).pathloss;
                COMM_dataset{t}.bs{BSreceiver}.path_params=rmfield(TX{t}.channel_params_BSBS(BSreceiver),{'loc','distance','pathloss'});

                % c.increment();
            end
        end
    end

end