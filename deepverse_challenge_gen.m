addpath(genpath('scripts')) %

dataset = generate_deepverse_dataset('combined_params.m');

%%
channels = zeros(16007, 1, 64, 64);
ue_idx = [];
channel_paths = {};
los_status = [];
location = [];
scene = [];
cam_1 = {};
cam_2 = {};
cam_3 = {};
angles = [];
radar_paths = {};

bs_loc = scene_data.bs{1}.location(1:2);

data_counter = 1;
for s=1:length(dataset.scene)
    scene_data = dataset.scene{s};
    if isfield(scene_data, 'ue')
        for u=1:length(scene_data.ue)
            user_data = scene_data.ue{u};
            ue_idx(data_counter) = user_data.id;
            
            channel = scene_data.bs{1}.comm.ue{u}.channel;
            channel_paths{data_counter} = sprintf("./wireless/%i.mat", data_counter);
            channel_path = sprintf("challenge_data/wireless/%i.mat", data_counter);
            save(channel_path, 'channel');
            
            cam_1{data_counter} = scene_data.bs{1}.cam{1};
            cam_2{data_counter} = scene_data.bs{1}.cam{2};
            cam_3{data_counter} = scene_data.bs{1}.cam{3};
            
            radar_paths{data_counter} = sprintf("./radar/%i.mat", s-1);
            
            los_status(data_counter) = scene_data.bs{1}.comm.ue{u}.LoS_status;
            location(data_counter, :) = scene_data.bs{1}.comm.ue{u}.loc;
            scene(data_counter) = s;
            
            % Calculate which camera is to be used
            bs_dist = location(data_counter, 1:2) - bs_loc;
            angles(data_counter) = rad2deg(atan2(bs_dist(2), bs_dist(1)));
            
            
            data_counter = data_counter + 1;
        end
    end
end

%save('dataset.mat', 'channels', 'location', 'ue_idx', 'scene', 'los_status');
selected_camera = zeros(1, length(data_counter));
margin = 40; % mid camera around [-margin, +margin] degrees
for ue = 0:47
    sel_samples = (ue_idx == ue);
    s = scene(sel_samples);
    a = angles(sel_samples);
%     plot(s, a)
%     hold on
    right_cam = a<90-margin;
    left_cam = a>90+margin;
    selected_camera(sel_samples) = right_cam - left_cam;
end

csv_file = table(location(:, 1), location(:, 2), location(:, 3), ue_idx', scene', los_status', channel_paths', cam_1', cam_2', cam_3', selected_camera', radar_paths');
csv_file.Properties.VariableNames = ["x", "y", "z", "user_idx", "scene", "los", "channel", "cam_right", "cam_mid", "cam_left", "cam_select", "radar"];
writetable(csv_file, 'challenge_data/dataset.csv')