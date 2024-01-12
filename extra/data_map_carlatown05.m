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
cam_counter = 1;

for i = 1:num_bs
    bs_name = ['bs' num2str(i)];
    num_cam = length(dir(fullfile(data_path, ['images/' bs_name])))-2;
    for j = 1:num_cam
        cam_name = ['cam' num2str(j, '%i')];
        cam_path = ['./images/', bs_name, '/', cam_name, '/'];
        full_data.(bs_name).image.(cam_name).data = strsplit(sprintf([cam_path, '%i.jpg '], file_idx));
        full_data.(bs_name).image.(cam_name).data = full_data.(bs_name).image.(cam_name).data(1:end-1);
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