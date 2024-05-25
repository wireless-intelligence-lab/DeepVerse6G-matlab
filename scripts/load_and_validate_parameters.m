function [full_data, params] = load_and_validate_parameters(params)
    
    scenario_map_file = fullfile(params.dataset_folder, params.scenario, 'data_map.mat');
    load(scenario_map_file, 'full_data');
    
end