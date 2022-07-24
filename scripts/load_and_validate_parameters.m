function [full_data, parameters] = load_and_validate_parameters(parameters_file)
    run(parameters_file);
    parameters = wv;
    load(fullfile(parameters.dataset_folder, parameters.scenario, 'data_map.mat'));
    
    % Validation to be added here
end