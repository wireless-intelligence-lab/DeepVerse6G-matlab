% This file generates the directories of the files of Scenario 1
% The output is saved as 'data_map.mat' and should be distributed 
% as a part of the Scenario

clear;
clc;

bs_name_orig_order = [1 2 3 4]; % BS names based on WI ordering (Third BS appears first)
[~, bs_name_new_order] = sort(bs_name_orig_order);% Renaming of basestations (BS1->2, BS3->3 ...)
%% Add images

file_idx = 0:1999;
cams = ["bs1-cam1", 
        "bs2-cam1", 
        "bs3-cam1", 
        "nlos-a1", 
        "nlos-a2", 
        "nlos-a3", 
        "nlos-a4", 
        "nlos-a5"];
cam_bs = [1, 2, 3, 4, 4, 4, 4, 4];
cam_counter = 1;

for i = 1:length(cam_bs)
    if i>1
        if cam_bs(i) == cam_bs(i-1)
            cam_counter = cam_counter + 1;
        else
            cam_counter = 1;
        end
    end

    bs_name = ['bs' num2str(cam_bs(i), '%i')];
    cam_name = ['cam' num2str(cam_counter, '%i')];
    cam_path = ['./RGB_images/', cams(i), '/'];
    cam_path = strjoin(cam_path, '');
    full_data.(bs_name).image.(cam_name).data = strsplit(sprintf(strjoin([cam_path, '%i.jpg '], ''), file_idx));
    full_data.(bs_name).image.(cam_name).data = full_data.(bs_name).image.(cam_name).data(1:end-1);
end


%% Add LiDAR files - Folder names needs to be reordered!!
file_idx = 0:1999;
for bs_id = 1:4
    bs_name = ['bs' num2str(bs_id, '%i')];
    bs_path = ['./LiDAR/', bs_name, '/'];
    full_data.(bs_name).lidar.data = strsplit(sprintf([bs_path '%i.pcd '], file_idx));
    full_data.(bs_name).lidar.data = full_data.(bs_name).lidar.data(1:end-1);
end

%% WI Files
file_idx = 0:1999;

full_data.bs1.wireless.path = './wireless/';

%% Trajectories
full_data.trajectory = './wireless/trajectory.mat';

%% Save
save('data_map.mat', 'full_data');