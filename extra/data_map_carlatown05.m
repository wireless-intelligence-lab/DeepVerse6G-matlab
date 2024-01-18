% This file generates the directories of the files of Scenario 1
% The output is saved as 'data_map.mat' and should be distributed 
% as a part of the Scenario

clear;
clc;

%% Add images
data_path = 'F:\Umut\Wireless-Verse\Carla-Town05';
% Data path is used to find number of BSs and cameras

file_idx = 0:2300;

num_bs = 3;

% Camera Angle Rotation
cam_yaw = {{0,60,120,180,240},{0,60,180,240,300},{0,60,120,180,300}};
cam_pitch = {{-30},{-30},{-30},{-30},{-30}};
cam_FoV = {{90},{90},{90},{90},{90}};


for i = 1:num_bs
    bs_name = ['bs' num2str(i)];
    num_cam = length(dir(fullfile(data_path, ['images/' bs_name])))-2;
    for j = 1:num_cam
        cam_name = ['cam' num2str(j, '%i')];
        cam_path = ['./images/', bs_name, '/', cam_name, '/'];
        full_data.(bs_name).image.(cam_name).data = strsplit(sprintf([cam_path, '%i.jpg '], file_idx));
        full_data.(bs_name).image.(cam_name).data = full_data.(bs_name).image.(cam_name).data(1:end-1);

        % If there are multiple pitch & FoV values, update the following
        % cam_pitch{i}{1} with {i}{j}
        full_data.(bs_name).image.(cam_name).rotation = [0, cam_pitch{i}{1}, cam_yaw{i}{j}];
        full_data.(bs_name).image.(cam_name).FoV = cam_FoV{i}{1};
    end
end

%% Add LiDAR files - Folder names needs to be reordered!!
for bs_id = 1:num_bs
    bs_name = ['bs' num2str(bs_id, '%i')];
    bs_path = ['./LiDAR/', bs_name, '/'];
    full_data.(bs_name).lidar.data = strsplit(sprintf([bs_path '%i.pcd '], file_idx));
    full_data.(bs_name).lidar.data = full_data.(bs_name).lidar.data(1:end-1);
end

%% WI Files
full_data.bs1.wireless.path = './wireless/';

%% Trajectories
full_data.trajectory = './wireless/trajectory.mat';

%% Save
save('data_map.mat', 'full_data');