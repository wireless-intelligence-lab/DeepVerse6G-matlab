function ret = parse_scenario_yaml(yaml_path)
yaml_data = readyaml(yaml_path).modalities;
for i = 1:numel(yaml_data)
    modality = yaml_data{i};
    if ~isfield(modality, 'name')
        fprintf('Skipping a modality without name\n');
    end
    if strcmpi(modality.name, 'camera')
        ret.cam = rmfield(modality, 'name');
    elseif strcmpi(modality.name, 'LiDAR')
        ret.lidar = rmfield(modality, 'name');
    elseif strcmpi(modality.name, 'dynamic_objects')
        ret.trajectory = rmfield(modality, 'name');
    else
        fprintf('Skipping unknown modality: %s\n', modality.name);
    end
end
end


