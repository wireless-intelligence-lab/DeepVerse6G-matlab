% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %


function [IF_signal] = construct_radar_signal(tx_ant_size, tx_rotation, tx_FoV, tx_ant_spacing, rx_ant_size, rx_rotation, rx_FoV, rx_ant_spacing, path_params, params)

    Fs = params.Fs;
    ang_conv=pi/180;
    Ts=1/Fs;
    T_PRI = params.T_PRI;
    N_chirp = params.N_chirp;
    N_samples = params.N_samples;
    T_active = N_samples*Ts;
    num_paths = path_params.num_paths;
    F0_active = params.carrier_freq;
    T_pause_normalized = (T_PRI - T_active)/Ts;

    % TX antenna parameters for a UPA structure
    M_TX_ind = antenna_channel_map(1, tx_ant_size(1), tx_ant_size(2), 0);
    M_TX=prod(tx_ant_size);
    kd_TX=2*pi*tx_ant_spacing;

    % RX antenna parameters for a UPA structure
    M_RX_ind = antenna_channel_map(1, rx_ant_size(1), rx_ant_size(2), 0);
    M_RX=prod(rx_ant_size);
    kd_RX=2*pi*rx_ant_spacing;

    if num_paths == 0
        IF_signal = complex(zeros(M_RX, M_TX, N_samples, N_chirp));
        return;
    end


    % Change the DoD and DoA angles based on the panel orientations
    [DoD_theta, DoD_phi, DoA_theta, DoA_phi] = antenna_rotation(tx_rotation, path_params.DoD_theta, path_params.DoD_phi, rx_rotation, path_params.DoA_theta, path_params.DoA_phi);

    % TX Array Response - BS
    gamma_TX=+1j*kd_TX*[sind(DoD_theta).*cosd(DoD_phi);
                        sind(DoD_theta).*sind(DoD_phi);
                        cosd(DoD_theta)];
    array_response_TX = exp(M_TX_ind*gamma_TX);

    % RX Array Response - BS
    gamma_RX=+1j*kd_RX*[sind(DoA_theta).*cosd(DoA_phi);
                        sind(DoA_theta).*sind(DoA_phi);
                        cosd(DoA_theta)];
    array_response_RX = exp(M_RX_ind*gamma_RX);

    % Account only for the channel within the user-specific channel tap length
    delay_normalized=path_params.ToA/Ts;
    delay_normalized(delay_normalized>(N_samples-1)) = (N_samples-1);
    
    power = path_params.power;
    power(delay_normalized>(N_samples-1)) = 0;

    % Filter paths outside of FoV
    FoV_TX = antenna_FoV(DoD_theta, DoD_phi, tx_FoV);
    FoV_RX = antenna_FoV(DoA_theta, DoA_phi, rx_FoV);
    
    %% LoS status computation
    FoV = FoV_TX & FoV_RX;
    if sum(FoV) > 0
        channel_LoS_status = sum(path_params.LoS_status & FoV)>0;
    else
        channel = complex(zeros(M_RX, M_TX, num_sampled_subcarriers));
        channel_LoS_status = -1;
    end
    path_FoV_filter = FoV;
    power(~path_FoV_filter) = 0;

    % Received signal calculation
    IF_sampling_mat = zeros(N_samples,num_paths); IF_sampling_mat2= IF_sampling_mat;
    for ll=1:1:num_paths
        IF_sampling_mat((ceil(double(delay_normalized(ll)))+1):1:N_samples,ll) = 1;
        if delay_normalized(ll) > T_pause_normalized %To model the interchirp interference in the cases where the delay is greater than (T_PRI - T_active)
            IF_sampling_mat2(1:1:(floor( double(delay_normalized(ll)) - T_pause_normalized )+1),ll) = 1;
        end
    end
    time_fast = Ts*(0:1:(N_samples-1)).';

    if ismember(params.comp_speed, [5, 4, 3]) % Methods 3-5
        time_slow = time_fast + reshape(((0:1:(N_chirp-1))*T_PRI),1,1,[]);
        Tau3_rt = ((double(path_params.Doppler_acc).*(time_slow.^2))./(2*physconst('LightSpeed')));
        Tau2_rt = ((double(path_params.Doppler_vel).*time_slow)./physconst('LightSpeed'));
        Tau_rt = (double(delay_normalized).*Ts) + Tau2_rt + Tau3_rt;
        %----- (a) additional traveling distance and (b) Doppler frequency affecting the phase terms
        Extra_phase = exp(sqrt(-1)*double(path_params.phase).*ang_conv);
        Phase_terms  = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt)) -(0.5.*params.S.*(Tau_rt.^2)) +(params.S.*time_fast.*Tau_rt)));
        Phase_terms2 = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt-T_PRI)) -(0.5.*params.S.*((Tau_rt-T_PRI).^2)) +(params.S.*time_fast.*(Tau_rt-T_PRI)))); %Phase_Terms for the case of interchirp interference
        IF_mat = sqrt(double(power)).*conj(Extra_phase).*((Phase_terms.*IF_sampling_mat)+(Phase_terms2.*IF_sampling_mat2)); %%%% conjugate is based on the derivation we have reached for +sin(.) Quadrature signal as the input to the second mixer.
        
        if params.comp_speed == 5 %----- faster calculation with higher memory requirement (5D matrix calculation and 4D matrix output)
            
            IF_signal = sum(reshape(array_response_RX, M_RX, 1, 1, num_paths, 1) .* reshape(array_response_TX, 1, M_TX, 1, num_paths, 1) .* reshape(IF_mat, 1, 1, N_samples, num_paths, N_chirp), 4);
            IF_signal = reshape(IF_signal, M_RX, M_TX, N_samples, N_chirp);
            
        elseif params.comp_speed == 4 %----- slower calculation with lower memory requirement (4D matrix calculation and 4D matrix output)
            
            IF_signal = complex(zeros(M_RX, M_TX, N_samples, N_chirp));
            for ll = 1:1:N_chirp
                IF_signal(:,:,:,ll)=sum(reshape(array_response_RX, M_RX, 1, 1, num_paths) .* reshape(array_response_TX, 1, M_TX, 1, num_paths) .* reshape(IF_mat(:,:,ll), 1, 1, N_samples, num_paths), 4);
            end
            
        else
            
            IF_signal = complex(zeros(M_RX, M_TX, N_samples, N_chirp));
            for aa = 1:1:N_samples
                for ll=1:1:N_chirp
                    IF_signal(:,:,aa,ll)=sum(reshape(array_response_RX, M_RX, 1, num_paths) .* reshape(array_response_TX, 1, M_TX, num_paths) .* reshape(IF_mat(aa,:,ll), 1, 1, num_paths), 3);
                end
            end
            
        end
    else % Methods 1-2
        
        IF_signal = complex(zeros(M_RX, M_TX, N_samples, N_chirp));
        
        for ll = 1:1:N_chirp
            time_slow = time_fast + ((ll-1)*T_PRI) ;
            Tau3_rt = ((double(path_params.Doppler_acc).*(time_slow.^2))./(2*physconst('LightSpeed')));
            Tau2_rt = ((double(path_params.Doppler_vel).*time_slow)./physconst('LightSpeed'));
            Tau_rt = (double(delay_normalized).*Ts) + Tau2_rt + Tau3_rt;
            Extra_phase = exp(sqrt(-1)*double(path_params.phase).*ang_conv);
            Phase_terms  = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt)) -(0.5.*params.S.*(Tau_rt.^2)) +(params.S.*time_fast.*Tau_rt)));
            Phase_terms2 = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt-T_PRI)) -(0.5.*params.S.*((Tau_rt-T_PRI).^2)) +(params.S.*time_fast.*(Tau_rt-T_PRI)))); %Phase_Terms for the case of interchirp interference
            IF_mat = sqrt(double(power)).*conj(Extra_phase).*((Phase_terms.*IF_sampling_mat)+(Phase_terms2.*IF_sampling_mat2)); %%%% conjugate is based on the new derivation we have reached for +sin(.) Quadrature carrier signal.

            if params.comp_speed == 2
                IF_signal(:,:,:,ll)=sum(reshape(array_response_RX, M_RX, 1, 1, num_paths) .* reshape(array_response_TX, 1, M_TX, 1, num_paths) .* reshape(IF_mat, 1, 1, N_samples, num_paths), 4);
            else
                for aa = 1:1:N_samples
                    IF_signal(:,:,aa,ll)=sum(reshape(array_response_RX, M_RX, 1, num_paths) .* reshape(array_response_TX, 1, M_TX, num_paths) .* reshape(IF_mat(aa,:), 1, 1, num_paths), 3);
                end
            end
        end
    end
end