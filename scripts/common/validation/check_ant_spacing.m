function params_inner = check_ant_spacing(params, params_inner, ant_spacing_str, active_bs_str)
    ant_spacing_size = length(params.(ant_spacing_str));
    if ant_spacing_size ~= params.(active_bs_str)
        if ant_spacing_size == 1
            params_inner.(ant_spacing_str) = repmat(params.(ant_spacing_str), params.(active_bs_str), 1);
        else
            error('The defined antenna spacing (%s) must be either a scalar or an N dimensional vector, where N is the number of active BSs.', ant_spacing_str)
        end
    else
        params_inner.(ant_spacing_str) = params.(ant_spacing_str);
    end
end