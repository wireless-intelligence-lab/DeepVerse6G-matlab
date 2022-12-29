
function params_inner = check_ant_size(params, params_inner, ant_dim_str, active_bs_str) 
    ant_size = size(params.(ant_dim_str));
    assert(ant_size(2) == 3, sprintf('The defined antenna panel size (%s) must be 3 dimensional (in x-y-z)', ant_dim_str))
    if ant_size(1) ~= params.(active_bs_str)
        if ant_size(1) == 1
            params_inner.(ant_dim_str) = repmat(params.(ant_dim_str), params.(active_bs_str), 1);
        else
            error('The defined antenna panel size (%s) must be either 1x3 or Nx3 dimensional, where N is the number of active BSs.', ant_dim_str)
        end
    else
        params_inner.(ant_dim_str) = params.(ant_dim_str);
    end    
end
