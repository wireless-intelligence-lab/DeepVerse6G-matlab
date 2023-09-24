function params_inner = check_ant_orientation(params, params_inner, array_rot_str, active_bs_str)
    array_rotation_size = size(params.(array_rot_str));
    assert(array_rotation_size(2) == 3, sprintf('The defined antenna array rotation (%s) must be 3 dimensional (rotation angles around x-y-z axes)', array_rot_str))
    if array_rotation_size(1) ~= params.(active_bs_str)
        if array_rotation_size(1) == 1
            params_inner.(array_rot_str) = repmat(params.(array_rot_str), params.(active_bs_str), 1);
        else
            error('The defined antenna array rotation (%s) size must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.', array_rot_str)
        end
    else
        params_inner.(array_rot_str) = params.(array_rot_str);
    end
end
