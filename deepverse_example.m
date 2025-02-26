addpath(genpath('scripts')) %

parameters = read_deepverse_params('config.m');
dataset = generate_deepverse_dataset(parameters);

dataset.info.radar.params.radar_KPI
%% 1481
for i = 1:length(dataset.scene)

    [range_angle, range_doppler] = generate_radar_maps(dataset, i);
    
    figure;
    imagesc(range_angle)
    set(gca,'YDir','normal')
    xlabel('Angle Bin');
    ylabel('Range Bin');
    title('Range-Angle Map');
    saveas(gcf, ['range-angle-' num2str(i) '.png'])
    
    figure;
    imagesc(range_doppler)
    set(gca,'YDir','normal')
    xlabel('Doppler Bin');
    ylabel('Range Bin');
    title('Range-Doppler Map');
    %sgtitle(['Scene ' num2str(i)])
    saveas(gcf, ['range-doppler-' num2str(i) '.png'])
end

function [range_angle, range_doppler] = generate_radar_maps(dataset, i)
    radar_signal = squeeze(dataset.scene{i}.bs{1}.radar.bs{1}.signal);

    radar_cube = radar_signal;

    radar_cube = fft(radar_cube, 512, 2);
    
    clutter = mean(radar_cube, 3); % Clutter computation
    radar_cube = radar_cube - clutter; % Clutter cleaning
    
    radar_cube = fft(radar_cube, 128, 3);
    radar_cube = fft(radar_cube, 128, 1);
    
    radar_cube = fftshift(radar_cube, 1); % FFTshift Angle Bins
    radar_cube = fftshift(radar_cube, 3); % FFTshift Doppler Bins
    
    % radar_cube = radar_cube - clutter;
    
    radar_cube = abs(radar_cube);
    range_angle = sum(radar_cube, 3)';
    range_doppler = squeeze(sum(radar_cube, 1));
end