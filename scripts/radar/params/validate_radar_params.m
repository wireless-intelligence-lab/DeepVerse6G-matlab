% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [params, params_inner] = validate_radar_params(params)

    [params] = compare_default_params(params, 'default_radar_params.m', 'radar');
    
    [params, params_inner] = add_additional_params(params, 'radar');

    params_inner = validate_params(params, params_inner);
    
end


function [params_inner] = validate_params(params, params_inner)

    params_inner = check_ant_size(params, params_inner, 'num_ant_TX', 'num_active_BS');
    params_inner = check_ant_orientation(params, params_inner, 'array_rotation_TX', 'num_active_BS');
    params_inner = check_ant_spacing(params, params_inner, 'ant_spacing_TX', 'num_active_BS');
    params_inner = check_ant_FoV(params, params_inner, 'ant_FoV_TX', 'num_active_BS');
    
    params_inner = check_ant_size(params, params_inner, 'num_ant_RX', 'num_active_BS');
    params_inner = check_ant_orientation(params, params_inner, 'array_rotation_RX', 'num_active_BS');
    params_inner = check_ant_spacing(params, params_inner, 'ant_spacing_RX', 'num_active_BS');
    params_inner = check_ant_FoV(params, params_inner, 'ant_FoV_RX', 'num_active_BS');
       
    assert(ismember(params.comp_speed, [1:5]), ...
            "The parameter params.comp_speed is defined from 1 to 5. Please set a valid value.")
end
