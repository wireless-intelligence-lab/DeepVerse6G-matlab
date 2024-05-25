%% Add the DeepVerse scripts to the path 
addpath(genpath('../../scripts')) % DeepVerse Scripts

%% Generate a Dataset
dataset = generate_deepverse_dataset('params.m');

%% Prepare Variables
scenario_folder = dataset.info.scenario_folder; % Folder of the scenario
scene_id = 1; % Select a scene
bs_id = 1; % Select a BS
ue_id = 3; % Select a UE

%% Plot 2D UE and BS positions
figure;
hold on;
for bs_idx = 1:length(dataset.scene{scene_id}.bs)
    x = dataset.scene{scene_id}.bs{bs_idx}.location(1);
    y = dataset.scene{scene_id}.bs{bs_idx}.location(2);
    plot(x, y, 'bo');
    text(x-14, y-1.2, strcat('BS ', num2str(bs_idx)));
end
for ue_idx = 1:length(dataset.scene{scene_id}.ue)
    x = dataset.scene{scene_id}.ue{ue_idx}.location(1);
    y = dataset.scene{scene_id}.ue{ue_idx}.location(2);
    plot(x, y, 'rx');
    text(x-7, y-1.2, strcat('UE ', num2str(ue_idx)));
end
grid on;
xlabel('x (m)');
ylabel('y (m)');

%% Show Camera Images
figure;
hold on;
for cam_id=1:3
    subplot(3, 1, cam_id);
    im_path = fullfile(scenario_folder, dataset.scene{scene_id}.bs{bs_id}.cam{cam_id});
    imshow(im_path)
    title(sprintf('Basestation Camera %i', cam_id))
end

%% Lidar PCD (Requires computer vision toolbox)
figure;
pcd_path = fullfile(scenario_folder, dataset.scene{scene_id}.bs{bs_id}.lidar{1});
ptCloud = pcread(pcd_path);
pcshow(ptCloud);

%% Radar
y = dataset.scene{scene_id}.bs{bs_id}.radar.bs{bs_id}.signal; % Radar signal from BS2 to BS2
y = squeeze(y);

% Radar Signal Processing
y = fft(y, 256, 2); % Range FFT
z = sum(sum(y, 1), 2); % Clutter computation
y = y - z; % Clutter cleaning
y = fft(y, 128, 3); % Doppler FFT
y = fft(y, 128, 1); % 128-point Angle FFT
y = fftshift(y, 1); % FFTshift Angle Bins
y = fftshift(y, 3); % FFTshift Doppler Bins

% Plot Range-Angle Map
figure;
imagesc(squeeze(sum(abs(y), 3))')
set(gca,'YDir','normal') 
xlabel('Angle Bin');
ylabel('Range Bin');
title('Range-Angle Map');

%% BS-UE Channel
for ue_id = 1:length(dataset.scene{scene_id}.bs{bs_id}.comm.ue)
    figure;
    h = dataset.scene{scene_id}.bs{bs_id}.comm.ue{ue_id}.channel;
    angles = linspace(0, 180, 128)';
    bf_codebook = exp(-j*pi*[0:31].*cosd(angles));
    plot(pow2db(abs(flip(fftshift(fft(h, 128))).^2)));
    hold on
    plot(pow2db(squeeze(abs(bf_codebook*h.').^2)))
    ylabel('Channel Gain (dB)')
    xlabel('Beam Index');
    title(['UE ID: ' num2str(ue_id)])
    grid on;
end