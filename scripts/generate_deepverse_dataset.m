function [dataset] = generate_deepverse_dataset(params)

    [full_data, params] = load_and_validate_parameters(params);

    %% Empty structure for the dataset
    dataset.parameters = params;
    
    %% Mobility Data Processing
    if params.position
        dataset = process_mobility_data(full_data, params, dataset);
    end

    %% Communication Data Processing
    if params.comm.enable
        dataset = process_communication_data(full_data, params, dataset);
    end
    
    %% Radar Data Processing
    if params.radar.enable
        dataset = process_radar_data(full_data, params, dataset);
    end
    
    %% Camera Data Processing
    if params.camera
        dataset = process_camera_data(full_data, params, dataset);
    end
    
    %% Lidar Data Processing
    if params.lidar
        dataset = process_lidar_data(full_data, params, dataset);
    end

end

function dataset = process_mobility_data(full_data, params, dataset)
    trajectory_file_path = fullfile(params.dataset_folder, params.scenario, full_data.trajectory);
    trajectory_data = load(trajectory_file_path);
    dataset.info.mobility.object_types = trajectory_data.object_info;
    
    for scene = 1:length(params.scenes)
        traffic_data = trajectory_data.scene{params.scenes(scene)}.objects;
        for user = 1:length(traffic_data)
            utdata = traffic_data{user};
            dataset.scene{scene}.ue{user}.id = utdata.id;
            dataset.scene{scene}.ue{user}.location = [utdata.x, utdata.y, utdata.tx_height];
            utdata = rmfield(utdata, {'x', 'y', 'tx_height', 'id'});
            dataset.scene{scene}.ue{user}.mobility = utdata;
        end
    end
end

function dataset = process_communication_data(full_data, params, dataset)
    comm_params = params.comm;
    comm_params.active_BS = params.basestations;
    comm_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.bs1.wireless.path);
    comm_params.scenario_folder = fullfile(params.dataset_folder, params.scenario);
    comm_params.scenario = params.scenario;
    comm_params.scenes = params.scenes;

    [comm_dataset, comm_params] = generate_comm(comm_params);

    bs_count = 1;
    for bs = params.basestations
        for scene = 1:length(params.scenes)
            v = comm_dataset{scene}{bs_count};
            if params.position
                for user = 1:length(v)
                    v.ue{user}.id = dataset.scene{scene}.ue{user}.id;
                end
            end
            dataset.scene{scene}.bs{bs_count}.comm = v;
            dataset.scene{scene}.bs{bs_count}.location = v.loc;
        end
        dataset.info.comm.params = comm_params{1};
        bs_count = bs_count + 1;
    end
end

function dataset = process_radar_data(full_data, params, dataset)
    radar_params = params.radar;
    radar_params.active_BS = params.basestations;
    radar_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.bs1.wireless.path);
    radar_params.scenario = params.scenario;
    radar_params.scenes = params.scenes;

    [radar_dataset, radar_params] = generate_radar(radar_params);

    bs_count = 1;
    for bs = params.basestations
        for scene = 1:length(params.scenes)
            dataset.scene{scene}.bs{bs_count}.radar = radar_dataset{scene}{bs_count};
            dataset.info.radar.params = radar_params{scene};
        end
        bs_count = bs_count + 1;
    end
end

function dataset = process_camera_data(full_data, params, dataset)
    dataset.info.scenario_folder = fullfile(params.dataset_folder, params.scenario);
    bs_count = 1;
    for bs = params.basestations
        cam_count = 1;
        for cam = params.camera_id
            cam_name = sprintf('cam%i', cam);
            for scene = 1:length(params.scenes)
                if isfield(full_data.(sprintf('bs%i', bs)).image, cam_name)
                    cam_data = full_data.(sprintf('bs%i', bs)).image.(cam_name);
                    dataset.scene{scene}.bs{bs_count}.cam{cam_count}.data = cam_data.data{params.scenes(scene)};
                    if isfield(cam_data, 'rotation')
                        dataset.scene{scene}.bs{bs_count}.cam{cam_count}.rotation = cam_data.rotation;
                    end
                    if isfield(cam_data, 'FoV')
                        dataset.scene{scene}.bs{bs_count}.cam{cam_count}.FoV = cam_data.FoV;
                    end
                end
            end
            cam_count = cam_count + 1;
        end
        bs_count = bs_count + 1;
    end
end

function dataset = process_lidar_data(full_data, params, dataset)
    bs_count = 1;
    for bs = params.basestations
        for scene = 1:length(params.scenes)
            dataset.scene{scene}.bs{bs_count}.lidar{1} = full_data.(sprintf('bs%i', bs)).lidar.data{params.scenes(scene)};
        end
        bs_count = bs_count + 1;
    end
end