function [dataset] = generate_deepverse_dataset(params)

[full_data, params] = load_and_validate_parameters(params);

%% Empty structure for the dataset
dataset.parameters = params;

%% Camera Data Processing
if params.camera
    dataset = process_camera_data(full_data, params, dataset);
end

%% Lidar Data Processing
if params.lidar
    dataset = process_lidar_data(full_data, params, dataset);
end

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

end

function dataset = process_mobility_data(full_data, params, dataset)
trajectory_file_path = fullfile(params.dataset_folder, params.scenario, full_data.trajectory.path);
trajectory_data = load(trajectory_file_path);
dataset.info.mobility.object_types = trajectory_data.object_info;

for scene = 1:length(params.scenes)
    traffic_data = trajectory_data.scene{params.scenes(scene)}.objects;
    dataset.scene{scene}.ue = {};
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
if isfield(full_data, 'wireless')
    comm_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.wireless.path);
else
    comm_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, 'wireless');
end
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
                if isempty(dataset.scene{scene}.ue)
                    v.ue{user}.id = [];
                else
                    v.ue{user}.id = dataset.scene{scene}.ue{user}.id;
                end
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
if isfield(full_data, 'wireless')
    radar_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, full_data.wireless.path);
else
    radar_params.dataset_folder = fullfile(params.dataset_folder, params.scenario, 'wireless');
end
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

cam_count = 1;
for cam = params.camera_id
    sonser_idx = -1;
    for s=1:numel(full_data.cam.sensors)
        if strcmp(full_data.cam.sensors{s}.id, cam)
            sonser_idx = s;
            break;
        end
    end
    if sonser_idx < 1
        error("camera id %s not found", cam)
    end

    data_folder = fullfile(params.dataset_folder, params.scenario, ...
        full_data.cam.path, cam);
    file_list = dir(data_folder);
    file_list = file_list(3:end);
    [~, file_idx] = natsort({file_list.name});
    file_list = file_list(file_idx);
    file_list = string({file_list.name});

    for scene = 1:length(params.scenes)
        dataset.scene{scene}.cam{cam_count}.name = cam;
        dataset.scene{scene}.cam{cam_count}.data = fullfile(data_folder, file_list(params.scenes(scene)));
        cam_data = full_data.cam.sensors{sonser_idx}.properties;
        fieldNames = fieldnames(cam_data);
        for i = 1:length(fieldNames)
            fieldName = fieldNames{i};
            dataset.scene{scene}.cam{cam_count}.(fieldName) = cam_data.(fieldName);
        end
    end
    cam_count = cam_count + 1;
end
end

function dataset = process_lidar_data(full_data, params, dataset)
dataset.info.scenario_folder = fullfile(params.dataset_folder, params.scenario);

lidar_count = 1;
for lidar = params.lidar_id
    sonser_idx = -1;
    for s=1:numel(full_data.lidar.sensors)
        if strcmp(full_data.lidar.sensors{s}.id, lidar)
            sonser_idx = s;
            break;
        end
    end
    if sonser_idx < 1
        error("LiDAR id %s not found", lidar)
    end
    
    data_folder = fullfile(params.dataset_folder, params.scenario, ...
            full_data.lidar.path, lidar);
    file_list = dir(data_folder);
    file_list = file_list(3:end);
    [~, file_idx] = natsort({file_list.name});
    file_list = file_list(file_idx);
    file_list = string({file_list.name});

    for scene = 1:length(params.scenes)
        dataset.scene{scene}.lidar{lidar_count}.name = lidar;

        dataset.scene{scene}.lidar{lidar_count}.data = fullfile(data_folder, file_list(params.scenes(scene)));

        lidar_data = full_data.lidar.sensors{sonser_idx}.properties;
        fieldNames = fieldnames(lidar_data);
        for i = 1:length(fieldNames)
            fieldName = fieldNames{i};
            dataset.scene{scene}.lidar{lidar_count}.(fieldName) = lidar_data.(fieldName);
        end
    end
    lidar_count = lidar_count + 1;
end
end
