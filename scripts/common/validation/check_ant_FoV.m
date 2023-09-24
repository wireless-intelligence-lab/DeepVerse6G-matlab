function params_inner = check_ant_FoV(params, params_inner, ant_FoV_str, active_bs_str) 

    ant_FoV = size(params.(ant_FoV_str));
    assert(ant_FoV(2) == 2, sprintf('The defined antenna orientation (%s) must be 2 dimensional [horizontal, vertical]', ant_FoV_str))
    if ant_FoV(1) ~= params.(active_bs_str)
        if ant_FoV(1) == 1
            params_inner.(ant_FoV_str) = repmat(params.(ant_FoV_str), params.(active_bs_str), 1);
        else
            error('The defined BS antenna FoV (%s) must be either 1x2 or Nx2 dimensional, where N is the number of active BSs.', ant_FoV_str)
        end
    else
        params_inner.(ant_FoV_str) = params.(ant_FoV_str);
    end    
    
end
