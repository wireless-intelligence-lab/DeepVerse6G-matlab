function [full_data, params] = load_and_validate_parameters(params)
    scenario_yaml_path = fullfile(params.dataset_folder, params.scenario, 'scenario.yaml');
    full_data = parse_scenario_yaml(scenario_yaml_path);
end