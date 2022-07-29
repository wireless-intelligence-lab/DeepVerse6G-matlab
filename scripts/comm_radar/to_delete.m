
%% Construct_COMM_channel changes

light_speed = physconst('LightSpeed');
%Assuming the pulse shaping as a dirac delta function and no receive LPF
if ~params.activate_RX_filter
    if ~params.doppler
        path_const=sqrt(power/params.num_OFDM).*exp(1j*params_user.phase*ang_conv).*exp(-1j*2*pi*(k/params.num_OFDM)*delay_normalized);
    else %Include Doppler information
        delay = delay_normalized.*Ts;
        Doppler_phase_shift = exp(-1j*2*pi*params.carrier_freq*( ((params_user.Doppler_vel.*delay)./light_speed) + ((params_user.Doppler_acc.*(delay.^2))./(2*light_speed)) ));
        path_const=sqrt(power/params.num_OFDM).*exp(1j*params_user.phase*ang_conv).*exp(-1j*2*pi*(k/params.num_OFDM)*delay_normalized).*Doppler_phase_shift;
    end
    channel = sum(reshape(array_response_RX, M_RX, 1, 1, []) .* reshape(array_response_TX, 1, M_TX, 1, []) .* reshape(path_const, 1, 1, num_sampled_subcarriers, []), 4);
else
    d_ext = [0:(params.num_OFDM-1)]; %extended d domain
    delay_d_conv = exp(-1j*(2*pi.*k/params.num_OFDM).*d_ext);

    % Generate the pulse function
    LP_fn = pulse_sinc(d_ext.'-delay_normalized);
    if ~params.doppler
        conv_vec = exp(1j*params_user.phase*ang_conv).*sqrt(power/params.num_OFDM) .* LP_fn; %Power of the paths and phase
    else %Include Doppler information
        d_time = Ts*(d_ext.');
        Doppler_phase_shift = exp(-1j*2*pi*params.carrier_freq*( ((params_user.Doppler_vel.*d_time)./light_speed) + ((params_user.Doppler_acc.*(d_time.^2))./(2*light_speed)) ));
        conv_vec = exp(1j*params_user.phase*ang_conv).*sqrt(power/params.num_OFDM) .* LP_fn.*Doppler_phase_shift; %Power of the paths and phase
    end
    channel = sum(reshape(array_response_RX, M_RX, 1, 1, []) .* reshape(array_response_TX, 1, M_TX, 1, []) .* reshape(conv_vec, 1, 1, [], params_user.num_paths), 4);
    channel = sum(reshape(channel, M_RX, M_TX, 1, []) .* reshape(delay_d_conv, 1, 1, num_sampled_subcarriers, []), 4);
end
