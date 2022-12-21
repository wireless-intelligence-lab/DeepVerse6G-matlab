function [dataset] = generate_deepverse_dataset(parameters_file)

    [full_data, parameters] = load_and_validate_parameters(parameters_file);

    % Wireless 
    % - Generated together for BS-BS channel possibility
    % - May be cleaned slater
    if parameters.wireless

        % DeepMIMO Channel generator
        wireless_params = read_params(parameters.wireless_parameters);
        wireless_params.active_BS = parameters.basestations;
        wireless_params.dataset_folder = fullfile(parameters.dataset_folder, parameters.scenario, full_data.bs1.wireless.path);
        wireless_params.scenario = parameters.scenario;
        % Scene first - last to be updated to a list
        wireless_params.scene_first = parameters.scenes(1);
        wireless_params.scene_last = parameters.scenes(end);
        wireless_params.BS_ID_map = full_data.bs1.wireless.BS_ID_map;
        
        [wireless_dataset, wireless_params] = wv_comm_generator(wireless_params);
        
        % Transfer data to WV dataset
        bs_count = 1;
        for bs=parameters.basestations
            bs_name = sprintf('bs%i', bs);
            for scene = 1:length(parameters.scenes)
                dataset{scene}.(bs_name).wireless.parameters = wireless_params{scene};
                dataset{scene}.(bs_name).wireless.channels = wireless_dataset{scene}{bs_count};
            end
            bs_count = bs_count + 1;
        end
        clear wireless_dataset wireless_params
    end
    
    % Radar
    if parameters.radar
                % DeepMIMO Channel generator
        radar_params = read_params(parameters.radar_parameters);
        radar_params.active_BS = parameters.basestations;
        radar_params.dataset_folder = fullfile(parameters.dataset_folder, parameters.scenario, full_data.bs1.wireless.path);
        radar_params.scenario = parameters.scenario;
        % Scene first - last to be updated to a list
        radar_params.scene_first = parameters.scenes(1);
        radar_params.scene_last = parameters.scenes(end);
        radar_params.BS_ID_map = full_data.bs1.wireless.BS_ID_map;
        
        [radar_dataset, radar_params] = wv_radar_generator(radar_params);
        
        % Transfer data to WV dataset
        bs_count = 1;
        for bs=parameters.basestations
            bs_name = sprintf('bs%i', bs);
            for scene = 1:length(parameters.scenes)
                dataset{scene}.(bs_name).radar.parameters = radar_params{scene};
                dataset{scene}.(bs_name).radar.channels = radar_dataset{scene}{bs_count};
            end
            bs_count = bs_count + 1;
        end
        clear radar_dataset radar_params
    end
    
    for bs=parameters.basestations
        bs_name = sprintf('bs%i', bs);
        
        if parameters.radar
            % DeepMIMO Radar generator
        end
        if parameters.camera
            for cam = parameters.camera_id
                cam_name = sprintf('cam%i', cam);
                for scene = 1:length(parameters.scenes)
                    dataset{scene}.(bs_name).image.(cam_name).data = full_data.(bs_name).image.(cam_name).data{parameters.scenes(scene)};
                end
            end
        end
        if parameters.lidar
            for scene = 1:length(parameters.scenes)
                dataset{scene}.(bs_name).lidar.data = full_data.(bs_name).lidar.data{parameters.scenes(scene)};
            end
        end
        if parameters.position
            trajectory = load(fullfile(parameters.dataset_folder, parameters.scenario, full_data.trajectory));
            for scene = 1:length(parameters.scenes)
                dataset{scene}.trajectory = trajectory.scene{parameters.scenes(scene)};
            end
        end
    end

end