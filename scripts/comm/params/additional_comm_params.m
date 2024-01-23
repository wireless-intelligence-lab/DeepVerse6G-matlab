% Communication specific parameters to be calculated
function params = additional_comm_params(params)
        params.symbol_duration = (params.num_OFDM) / (params.bandwidth*1e9);
end