dv.dataset_folder = '../../DV_Scenarios';
dv.scenario = 'Scenario 1';

dv.basestations = [1, 2, 3, 4]; % Basestations to be included
dv.scenes = [1000:1002]; % Scenes to be included
    
dv.wireless = true;
dv.wireless_parameters = 'wireless_params.m';

dv.radar = true;
dv.radar_parameters = 'radar_params.m';

dv.camera = true;
dv.camera_id = [1, 2, 3];

dv.lidar = true;
dv.position = true;
