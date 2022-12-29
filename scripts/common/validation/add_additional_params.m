function [params, params_inner] = add_additional_params(params, type)

    % Add dataset path
    params_inner.dataset_folder = fullfile(params.dataset_folder);
    
    scenario_folder = fullfile(params_inner.dataset_folder);
    assert(logical(exist(scenario_folder, 'dir')), ['There is no scenario named "' params.scenario '" in the folder "' scenario_folder '/"' '. Please make sure the scenario name is correct and scenario files are downloaded and placed correctly.']);

    % All DeepSense Synth scenarios are dynamic scenarios
    params_inner.dynamic_scenario = 1;
    list_of_folders = strsplit(sprintf('/scene_%i--', params.scene_first-1:params.scene_last-1),'--');
    list_of_folders(end) = [];
    list_of_folders = fullfile(params_inner.dataset_folder, list_of_folders);
    params_inner.list_of_folders = list_of_folders;
    
    % Read scenario parameters
    params_inner.scenario_files=fullfile(params_inner.dataset_folder, filesep); % The initial of all the scenario files
    load([params_inner.scenario_files, 'scenario_params.mat']) % Scenario parameter file

    params.num_active_BS =  length(params.active_BS); %%%%%%%&&&&%%%%%%%
    params.carrier_freq = CarrierFrequency; % in Hz
    params.transmit_power_raytracing = TxPower; % in dBm
    
    eval(sprintf('params=additional_%s_params(params);', type));
    
end