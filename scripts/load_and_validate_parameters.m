function [full_data, params] = load_and_validate_parameters(params)

    load(fullfile(params.dataset_folder, params.scenario, 'data_map.mat'), 'full_data');
    
    % Validation to be added here
end