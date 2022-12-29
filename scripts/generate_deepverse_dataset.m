function [dataset] = generate_deepverse_dataset(parameters_file)

    params = read_params(parameters_file, 'dv');
    [full_data, params] = load_and_validate_parameters(params);

    % Wireless 
    % - Generated together for BS-BS channel possibility
    % - May be cleaned later
    if params.communication
        comm_params = read_params(params.communication_parameters, 'comm', parameters_file);
        comm_params.active_BS = params.basestations;
        comm_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.bs1.wireless.path);
        comm_params.scenario = params.scenario;
        % Scene first - last to be updated to a list
        comm_params.scene_first = params.scenes(1);
        comm_params.scene_last = params.scenes(end);
        comm_params.BS_ID_map = full_data.bs1.wireless.BS_ID_map;
        
        [comm_dataset, comm_params] = generate_comm(comm_params);
        
        % Transfer data to dataset
        bs_count = 1;
        for bs=params.basestations
            for scene = 1:length(params.scenes)
                dataset{scene}.bs{bs_count}.comm = comm_dataset{scene}{bs_count};
                dataset{scene}.bs{bs_count}.comm.parameters = comm_params{scene};
            end
            bs_count = bs_count + 1;
        end
        clear comm_dataset comm_params
    end
    
    % Radar
    if params.radar
        radar_params = read_params(params.radar_parameters, 'radar', parameters_file);
        radar_params.active_BS = params.basestations;
        radar_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.bs1.wireless.path);
        radar_params.scenario = params.scenario;
        % Scene first - last to be updated to a list
        radar_params.scene_first = params.scenes(1);
        radar_params.scene_last = params.scenes(end);
        radar_params.BS_ID_map = full_data.bs1.wireless.BS_ID_map;
        
        [radar_dataset, radar_params] = generate_radar(radar_params);
        
        % Transfer data to WV dataset
        bs_count = 1;
        for bs=params.basestations
            bs_name = sprintf('bs%i', bs);
            for scene = 1:length(params.scenes)
                dataset{scene}.bs{bs_count}.radar = radar_dataset{scene}{bs_count};
                dataset{scene}.bs{bs_count}.radar.parameters = radar_params{scene};
            end
            bs_count = bs_count + 1;
        end
        clear radar_dataset radar_params
    end
    
    bs_count = 1;
    for bs=params.basestations
        bs_name = sprintf('bs%i', bs);
        
        if params.camera
            dataset{1}.bs{bs_count}.camera{1}.folder = fullfile(params.dataset_folder, params.scenario);
            cam_count = 1;
            for cam = params.camera_id
                cam_name = sprintf('cam%i', cam);
                for scene = 1:length(params.scenes)
                    dataset{scene}.bs{bs_count}.camera{cam_count}.data = full_data.(bs_name).image.(cam_name).data{params.scenes(scene)};
                end
                cam_count = cam_count + 1;
            end
        end
        if params.lidar
            for scene = 1:length(params.scenes)
                dataset{scene}.bs{bs_count}.lidar{1}.data = full_data.(bs_name).lidar.data{params.scenes(scene)};
            end
        end
        if params.position
            trajectory = load(fullfile(params.dataset_folder, params.scenario, full_data.trajectory));
            for scene = 1:length(params.scenes)
                dataset{scene}.trajectory = trajectory.scene{params.scenes(scene)};
            end
        end
        
        bs_count = bs_count + 1;
    end

end