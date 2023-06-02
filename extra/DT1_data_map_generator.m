% This file generates the directories of the files of Scenario 1
% The output is saved as 'data_map.mat' and should be distributed 
% as a part of the Scenario

clear;
clc;

bs_name_orig_order = [1]; % BS names based on WI ordering (Third BS appears first)
[~, bs_name_new_order] = sort(bs_name_orig_order);% Renaming of basestations (BS1->2, BS3->3 ...)

%% Add images
file_idx = 0:2410;
for i = 1:1
    bs_id = 1;
    bs_name = ['bs' num2str(bs_name_new_order(bs_id), '%i')];
    cam_name = ['cam' num2str(i, '%i')];
    camid = rem(i, 3);
    if camid ==0
        camid=3;
    end
    cam_new_name = ['cam' num2str(camid, '%i')];
    cam_path = ['./RGB_images/cam', num2str(i, '%i'), '/'];
    full_data.(bs_name).image.(cam_new_name).data = strsplit(sprintf([cam_path, '%i.jpg '], file_idx));
    full_data.(bs_name).image.(cam_new_name).data = full_data.(bs_name).image.(cam_new_name).data(1:end-1);
end

%% Add LiDAR files - Folder names needs to be reordered!!
file_idx = 0:2410;
for bs_id = 1:1
    bs_name = ['bs' num2str(bs_id, '%i')];
    bs_path = ['./LiDAR/', bs_name, '/'];
    full_data.(bs_name).lidar.data = strsplit(sprintf([bs_path '%i.pcd '], file_idx));
    full_data.(bs_name).lidar.data = full_data.(bs_name).lidar.data(1:end-1);
end

%% WI Files
file_idx = 0:2410;
% Corresponding to the BS 1-2-3-4
TX_bsID = 1:1;
TX_ID = [1]; % For BSs in WI from 1 to 4
TX_subID = [1];
TX_boresight_az = [0];
TX_boresight_el = [0];

TX_ID = TX_ID(bs_name_orig_order);
TX_subID = TX_subID(bs_name_orig_order);
TX_boresight_az = TX_boresight_az(bs_name_orig_order);
TX_boresight_el = TX_boresight_el(bs_name_orig_order);

full_data.bs1.wireless.path = './wireless/';
full_data.bs1.wireless.BS_ID_map = [TX_bsID; TX_ID; TX_subID; TX_boresight_az; TX_boresight_el]';
full_data.bs1.wireless.UE_ID_map = [3*ones(12); 1*ones(12)]';
for bs_id = TX_bsID
    bs_name = ['bs', num2str(bs_id, '%i')];
    full_data.(bs_name).wireless.data = strsplit(sprintf('./wireless/scene_%i_TX%i.mat ', [file_idx; repmat(TX_ID(bs_id), 1, length(file_idx))]));
    full_data.(bs_name).wireless.data = full_data.(bs_name).wireless.data(1:end-1);
    full_data.(bs_name).wireless.scenario_file = './wireless/scenario_params.mat';
end

%% Trajectories
full_data.trajectory = './wireless/trajectory.mat';

%% Save
save('data_map.mat', 'full_data');