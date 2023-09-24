function params_inner = check_ant_orientation_random(params, params_inner, array_rot_str, active_ue_str)
    % Check UE antenna array (panel) orientation
    array_rotation_size = size(params.(array_rot_str));
    if array_rotation_size(1) == 1 && array_rotation_size(2) == 3
        params_inner.(array_rot_str) = repmat(params.(array_rot_str), params.(active_ue_str), 1);
    elseif array_rotation_size(1) == 3 && array_rotation_size(2) == 2
        params_inner.(array_rot_str) = zeros(params.(active_ue_str), 3);
        for i = 1:3
            params_inner.(array_rot_str)(:, i) = unifrnd(params.(array_rot_str)(i, 1), params.(array_rot_str)(i, 2), params.(active_ue_str), 1);
        end
    else
        error('The defined antenna array rotation (%s) size must be either 1x3 for fixed, or 3x2 for random generation.', array_rot_str)
    end

end
