dv.dataset_folder = r'../../DV_scenarios';
dv.scenario = 'Scenario 1';

dv.basestations = [1, 2, 3, 4]; % Basestations to be included
dv.scenes = [1:2000];           % Scenes to be included
    
dv.wireless = true;
dv.wireless_parameters = 'wireless_params.m';

dv.radar = false;
dv.radar_parameters = 'radar_params.m';

dv.camera = true;
dv.camera_id = [1, 2, 3];

dv.lidar = true;
dv.position = true;
