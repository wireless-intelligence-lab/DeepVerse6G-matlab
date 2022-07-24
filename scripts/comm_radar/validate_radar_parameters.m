% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [params, params_inner] = validate_radar_parameters(params)

    [params] = compare_with_default_params(params);
    
    [params, params_inner] = additional_params(params);

    params_inner = validate_params(params, params_inner);
end

function [params, params_inner] = additional_params(params)

    % Add dataset path
    if ~isfield(params, 'dataset_folder')
        current_folder = mfilename('fullpath');
        deepsense_synth_folder = fileparts(fileparts(current_folder));
        params_inner.dataset_folder = fullfile(deepsense_synth_folder, '/Raytracing_scenarios/');

        % Create folders if not exists
        folder_one = fullfile(deepsense_synth_folder, '/Raytracing_scenarios/');
        folder_two = fullfile(deepsense_synth_folder, '/Radar_dataset/');
        if ~exist(folder_one, 'dir')
            mkdir(folder_one);
        end
        if ~exist(folder_two, 'dir')
            mkdir(folder_two)
        end
    else
        params_inner.dataset_folder = fullfile(params.dataset_folder);
    end
    
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


    % BS-BS channel parameters
%     if params.enable_BS2BSchannels
%         load([params_inner.scenario_files, '.BSBS.params.mat']) % BS2BS parameter file %%%%%%%&&&&%%%%%%%
%         params.BS_grids = BS_grids;
%     end

%%%%%%%&&&&%%%%%%%
% %     params.symbol_duration = (params.num_OFDM) / (params.bandwidth*1e9);
% %     params.user_grids = user_grids;
% %     params.num_BS = num_BS;
    
% %     assert(params.row_subsampling<=1 & params.row_subsampling>0, 'Row subsampling parameters must be selected in (0, 1]')
% %     assert(params.user_subsampling<=1 & params.user_subsampling>0, 'User subsampling parameters must be selected in (0, 1]')

% %     [params.user_ids, params.num_user] = find_users(params);
end

% Check the validity of the given parameters
% Add default parameters if they don't exist in the current file
function [params] = compare_with_default_params(params)
    default_params = read_params('default_radar_parameters.m');
    default_fields = fieldnames(default_params);
    fields = fieldnames(params);
    default_fields_exist = zeros(1, length(default_fields));
    for i = 1:length(fields)
        comp = strcmp(fields{i}, default_fields);
        if sum(comp) == 1
            default_fields_exist(comp) = 1;
        else
            if ~strcmp(fields{i}, "dataset_folder")
                fprintf('\nThe parameter "%s" defined in the given parameters is not used by the radar generator', fields{i}) 
            end
        end
    end
    default_fields_exist = ~default_fields_exist;
    default_nonexistent_fields = find(default_fields_exist);
    for i = 1:length(default_nonexistent_fields)
        field = default_fields{default_nonexistent_fields(i)};
        value = getfield(default_params, field);
        params = setfield(params, field, value);
        % fprintf('\nAdding default parameter: %s - %s', field, num2str(value)) 
    end
end

function [params_inner] = validate_params(params, params_inner)
    % Check RX antenna size
    ant_size = size(params.num_ant_RX);
    assert(ant_size(2) == 3, 'The defined RX antenna panel size must be 3 dimensional (in x-y-z)')
    if ant_size(1) ~= params.num_active_BS
        if ant_size(1) == 1
            params_inner.num_ant_RX = repmat(params.num_ant_RX, params.num_active_BS, 1);
        else
            error('The defined RX antenna panel size must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.')
        end
    else
        params_inner.num_ant_RX = params.num_ant_RX;
    end    

    % Check TX antenna size
    ant_size = size(params.num_ant_TX);
    assert(ant_size(2) == 3, 'The defined TX antenna panel size must be 3 dimensional (in x-y-z)')
    if ant_size(1) ~= params.num_active_BS
        if ant_size(1) == 1
            params_inner.num_ant_TX = repmat(params.num_ant_TX, params.num_active_BS, 1);
        else
            error('The defined TX antenna panel size must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.')
        end
    else
        params_inner.num_ant_TX = params.num_ant_TX;
    end

    % Check TX antenna array (panel) orientation
    if params.activate_array_rotation
        array_rotation_size = size(params.array_rotation_TX);
        assert(array_rotation_size(2) == 3, 'The defined TX antenna array rotation must be 3 dimensional (rotation angles around x-y-z axes)')
        if array_rotation_size(1) ~= params.num_active_BS
            if array_rotation_size(1) == 1
                params_inner.array_rotation_TX = repmat(params.array_rotation_TX, params.num_active_BS, 1);
            else
                error('The defined TX antenna array rotation size must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.')
            end
        else
            params_inner.array_rotation_TX = params.array_rotation_TX;
        end
    else
        params_inner.array_rotation_TX = zeros(params.num_active_BS,3);
    end
    
    % Check RX antenna array (panel) orientation
    if params.activate_array_rotation
        array_rotation_size = size(params.array_rotation_RX);
        assert(array_rotation_size(2) == 3, 'The defined RX antenna array rotation must be 3 dimensional (rotation angles around x-y-z axes)')
        if array_rotation_size(1) ~= params.num_active_BS
            if array_rotation_size(1) == 1
                params_inner.array_rotation_RX = repmat(params.array_rotation_RX, params.num_active_BS, 1);
            else
                error('The defined RX antenna array rotation size must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.')
            end
        else
            params_inner.array_rotation_RX = params.array_rotation_RX;
        end
    else
        params_inner.array_rotation_RX = zeros(params.num_active_BS,3);
    end
       
    % Check TX antenna spacing
    ant_spacing_size = length(params.ant_spacing_TX);
    if ant_spacing_size ~= params.num_active_BS
        if ant_spacing_size == 1
            params_inner.ant_spacing_TX = repmat(params.ant_spacing_TX, params.num_active_BS, 1);
        else
            error('The defined TX antenna spacing must be either a scalar or an N dimensional vector, where N is the number of active BSs.')
        end
    else
        params_inner.ant_spacing_TX = params.ant_spacing_TX;
    end
    
    % Check RX antenna spacing
    ant_spacing_size = length(params.ant_spacing_RX);
    if ant_spacing_size ~= params.num_active_BS
        if ant_spacing_size == 1
            params_inner.ant_spacing_RX = repmat(params.ant_spacing_RX, params.num_active_BS, 1);
        else
            error('The defined RX antenna spacing must be either a scalar or an N dimensional vector, where N is the number of active BSs.')
        end
    else
        params_inner.ant_spacing_RX = params.ant_spacing_RX;
    end
    
end