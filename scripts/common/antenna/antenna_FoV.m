% --------- DeepMIMO: A Generic Dataset for mmWave and massive MIMO ------%
% Authors: Ahmed Alkhateeb, Umut Demirhan, Abdelrahman Taha 
% Date: March 17, 2022
% Goal: Encouraging research on ML/DL for MIMO applications and
% providing a benchmarking tool for the developed algorithms
% ---------------------------------------------------------------------- %

function [path_FoV_filter] = antenna_FoV(DoD_phi, DoA_phi, DoD_theta, DoA_theta, tx_boresight, tx_FOV_az, tx_FOV_el, rx_boresight, rx_FOV_az, rx_FOV_el)
    
    % Account only for the channel paths within the field of view
    tx_boresight = wrapTo180(tx_boresight([4 5])); %Select only the az and el boresight angles
    rx_boresight = wrapTo180(rx_boresight([4 5])); %Select only the az and el boresight angles

    tx_FOV_limit = [tx_boresight(1)-(tx_FOV_az/2) tx_boresight(1)+(tx_FOV_az/2) tx_boresight(2)-(tx_FOV_el/2) tx_boresight(2)+(tx_FOV_el/2)];
    rx_FOV_limit = [rx_boresight(1)-(rx_FOV_az/2) rx_boresight(1)+(rx_FOV_az/2) rx_boresight(2)-(rx_FOV_el/2) rx_boresight(2)+(rx_FOV_el/2)];
    DoD_cond = (DoD_phi>=tx_FOV_limit(1) & DoD_phi<=tx_FOV_limit(2)) & (DoD_theta>=tx_FOV_limit(3) & DoD_theta<=tx_FOV_limit(4));
    DoA_cond = (DoA_phi>=rx_FOV_limit(1) & DoA_phi<=rx_FOV_limit(2)) & (DoA_theta>=rx_FOV_limit(3) & DoA_theta<=rx_FOV_limit(4));
    
    path_FoV_filter = DoD_cond & DoA_cond;

end