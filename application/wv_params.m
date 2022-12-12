wv.dataset_folder = 'C:\Users\Umt\Desktop\WV_scenarios';
wv.scenario = 'Scenario 1';

wv.basestations = [1, 2, 3, 4]; % Basestations to be included
wv.scenes = [1:2000];           % Scenes to be included
    
wv.wireless = true;
wv.wireless_parameters = 'wireless_params.m';

wv.radar = false;
wv.radar_parameters = 'radar_params.m';

wv.camera = true;
wv.camera_id = [1, 2, 3];

wv.lidar = true;
wv.position = true;
