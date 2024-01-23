function [params, params_inner] = add_additional_params(params, type)

    % Add dataset path
    params_inner.dataset_folder = fullfile(params.dataset_folder);
    
    scenario_folder = fullfile(params_inner.dataset_folder);
    assert(logical(exist(scenario_folder, 'dir')), ['There is no scenario named "' params.scenario '" in the folder "' scenario_folder '/"' '. Please make sure the scenario name is correct and scenario files are downloaded and placed correctly.']);

    % All DeepSense Synth scenarios are dynamic scenarios
    params_inner.dynamic_scenario = 1;
    list_of_folders = strsplit(sprintf('/scene_%i--', params.scenes-1),'--');
    list_of_folders(end) = [];
    list_of_folders = fullfile(params_inner.dataset_folder, list_of_folders);
    params_inner.list_of_folders = list_of_folders;
    params_inner = findUserFileSplit(params_inner);
    
    % Read scenario parameters
    params_inner.scenario_files=fullfile(params_inner.dataset_folder, filesep); % The initial of all the scenario files
    load([params_inner.scenario_files, 'params.mat']) % Scenario parameter file

    params.num_active_BS =  length(params.active_BS); %%%%%%%&&&&%%%%%%%
    params.carrier_freq = carrier_freq; % in Hz
    params.transmit_power_raytracing = transmit_power; % in dB
    
    eval(sprintf('params=additional_%s_params(params);', type));
    
end

function params_inner = findUserFileSplit(params_inner)
    % Get a list of UE split
    params_inner.UE_file_split = [];
    for scene_folder = params_inner.list_of_folders
        fileList = dir(fullfile(scene_folder{1}, '*.mat'));
        filePattern = 'BS1_UE_(\d+)-(\d+)\.mat';

        number1 = [];
        number2 = [];

        % Loop through each file and extract the numbers
        for i = 1:numel(fileList)
            filename = fileList(i).name;

            % Check if the file name matches the pattern
            match = regexp(filename, filePattern, 'tokens');

            if ~isempty(match)
                % Extract the numbers from the file name
                number1 = [number1 str2double(match{1}{1})];
                number2 = [number2 str2double(match{1}{2})];
            end
        end
        params_inner.UE_file_split = [params_inner.UE_file_split, [number1; number2]];
    end
end