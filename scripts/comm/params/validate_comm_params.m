% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [params, params_inner] = validate_comm_params(params)

    [params] = compare_default_params(params, 'default_comm_params.m', 'comm');
    
    [params, params_inner] = add_additional_params(params, 'comm');

    params_inner = validate_params(params, params_inner);
end


function [params_inner] = validate_params(params, params_inner)
    % Check UE antenna
    assert(size(params.num_ant_UE, 2) == 2, 'The defined user antenna panel size must be 2 dimensional (in horizontal-vertical)')
    params_inner = check_ant_orientation_random(params, params_inner, 'array_rotation_UE', 'num_active_users');
    assert(isscalar(params.ant_spacing_UE), 'The UE antenna spacing must be a scalar.');
    assert(size(params.ant_FoV_UE, 2) == 2, 'The defined user antenna FoV size must be 2 dimensional (in horizontal-vertical)')

    % Check BS antenna
    params_inner = check_ant_size(params, params_inner, 'num_ant_BS', 'num_active_BS');
    params_inner = check_ant_orientation(params, params_inner, 'array_rotation_BS', 'num_active_BS');
    params_inner = check_ant_spacing(params, params_inner, 'ant_spacing_BS', 'num_active_BS');
    params_inner = check_ant_FoV(params, params_inner, 'ant_FoV_BS', 'num_active_BS');
    
end