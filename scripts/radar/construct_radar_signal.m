% Authors:
% Date: May 05, 2022
% Goal: Encouraging research on ML/DL for sensing applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %


function [IF_signal] = construct_radar_signal(tx_ant_size, tx_rotation, tx_ant_spacing, tx_boresight, rx_ant_size, rx_rotation, rx_ant_spacing, rx_boresight, channel_params, params)

    % These are to be added as variables
    % FoV for comm may be added
    tx_FOV_az = 180; %azimuth FOV in degrees %%%%%%%&&&&%%%%%%%
    tx_FOV_el = 90;  %elevation FOV in degrees %%%%%%%&&&&%%%%%%%
    rx_FOV_az = 180; %azimuth FOV in degrees %%%%%%%&&&&%%%%%%%
    rx_FOV_el = 90;  %elevation FOV in degrees %%%%%%%&&&&%%%%%%%

    % BS_ID_map = params.BS_ID_map;
    % user_ID_map = params.user_ID_map;


    Fs = params.Fs;
    ang_conv=pi/180;
    Ts=1/Fs;
    T_PRI = params.T_PRI;
    N_chirp = params.N_chirp;
    N_samples = params.N_samples;
    num_paths = channel_params.num_paths;
    F0_active = params.carrier_freq;


    % TX antenna parameters for a UPA structure
    M_TX_ind = antenna_channel_map(tx_ant_size(1), tx_ant_size(2), tx_ant_size(3), 0);
    M_TX=prod(tx_ant_size);
    kd_TX=2*pi*tx_ant_spacing;

    % RX antenna parameters for a UPA structure
    M_RX_ind = antenna_channel_map(rx_ant_size(1), rx_ant_size(2), rx_ant_size(3), 0);
    M_RX=prod(rx_ant_size);
    kd_RX=2*pi*rx_ant_spacing;

    if num_paths == 0
        IF_signal = complex(zeros(M_RX, M_TX, N_samples, N_chirp));
        return;
    end


    % Change the DoD and DoA angles based on the panel orientations
    if params.activate_array_rotation
        [DoD_theta, DoD_phi, DoA_theta, DoA_phi] = antenna_rotation(tx_rotation, channel_params.DoD_theta, channel_params.DoD_phi, rx_rotation, channel_params.DoA_theta, channel_params.DoA_phi);
    else
        DoD_theta = channel_params.DoD_theta;
        DoD_phi = channel_params.DoD_phi;
        DoA_theta = channel_params.DoA_theta;
        DoA_phi = channel_params.DoA_phi;
    end

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
    delay_normalized=channel_params.ToA/Ts;
    delay_normalized(delay_normalized>(N_samples-1)) = (N_samples-1);
    
    power = channel_params.power;
    power(delay_normalized>(N_samples-1)) = 0;

    % Filter paths outside of FoV
    path_FoV_filter = antenna_FoV(DoD_phi, DoA_phi, DoD_theta, DoA_theta, tx_boresight, tx_FOV_az, tx_FOV_el, rx_boresight, rx_FOV_az, rx_FOV_el);
    power(~path_FoV_filter) = 0;

    % Received signal calculation
    IF_sampling_mat = zeros(N_samples,num_paths);
    for ll=1:1:num_paths
        IF_sampling_mat((ceil(double(delay_normalized(ll)))+1):1:N_samples,ll) = 1;
    end
    time_fast = Ts*(0:1:(N_samples-1)).';

    if ismember(params.comp_speed, [5, 4, 3]) % Methods 3-5
        time_slow = time_fast + reshape(((0:1:(N_chirp-1))*T_PRI),1,1,[]);
        Tau3_rt = ((double(channel_params.Doppler_acc).*(time_slow.^2))./(2*physconst('LightSpeed')));
        Tau2_rt = ((double(channel_params.Doppler_vel).*time_slow)./physconst('LightSpeed'));
        Tau_rt = (double(delay_normalized).*Ts) + Tau2_rt + Tau3_rt;
        %----- (a) additional traveling distance and (b) Doppler frequency affecting the phase terms
        Extra_phase = exp(sqrt(-1)*double(channel_params.phase).*ang_conv);
        Phase_terms = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt)) -(0.5.*params.S.*(Tau_rt.^2)) +(params.S.*time_fast.*Tau_rt)));
        IF_mat = sqrt(double(power)).*conj(Extra_phase).*Phase_terms.*IF_sampling_mat; %%%% conjugate is based on the derivation we have reached for +sin(.) Quadrature signal as the input to the second mixer.
        
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
            Tau3_rt = ((double(channel_params.Doppler_acc).*(time_slow.^2))./(2*physconst('LightSpeed')));
            Tau2_rt = ((double(channel_params.Doppler_vel).*time_slow)./physconst('LightSpeed'));
            Tau_rt = (double(delay_normalized).*Ts) + Tau2_rt + Tau3_rt;
            Extra_phase = exp(sqrt(-1)*double(channel_params.phase).*ang_conv);
            Phase_terms = exp(sqrt(-1)*2*pi*( (F0_active.*(Tau_rt)) -(0.5.*params.S.*(Tau_rt.^2)) +(params.S.*time_fast.*Tau_rt)));
            IF_mat = sqrt(double(power)).*conj(Extra_phase).*Phase_terms.*IF_sampling_mat; %%%% conjugate is based on the new derivation we have reached for +sin(.) Quadrature carrier signal.
            
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