%% Add the DeepVerse scripts to the path 
addpath(genpath('../../scripts')) % DeepVerse Scripts

%% Generate a Dataset
dataset = generate_deepverse_dataset('params.m');

%% Plot 2D UE and BS positions
% set(0,'defaultLineMarkerSize',10)
% set(0,'defaultLineLineWidth', 2)
% set(0,'defaultAxesFontSize',12)
% set(0,'defaultAxesFontName','Arial')
% set(0,'defaultAxesLineWidth', 1)
% set(0,'defaultTextFontSize', 12)
% set(0,'defaultTextFontWeight', 'bold')
figure;
hold on;
for bs_id = 1:length(dataset{1}.bs)
    x = dataset{1}.bs{bs_id}.comm.loc(1);
    y = dataset{1}.bs{bs_id}.comm.loc(2);
    plot(x, y, 'bo');
    text(x-14, y-1.2, strcat('BS ', num2str(bs_id)));
end
for ue_id = 1:length(dataset{1}.bs{bs_id}.comm.ue)
    x = dataset{1}.bs{bs_id}.comm.ue{ue_id}.loc(1);
    y = dataset{1}.bs{bs_id}.comm.ue{ue_id}.loc(2);
    plot(x, y, 'rx');
    text(x-7, y-1.2, strcat('UE ', num2str(ue_id)));
end
grid on;
xlabel('x (m)');
ylabel('y (m)');
%% Prepare Variables
scenario_folder = dataset{1}.bs{1}.comm.parameters.scenario_folder; % Folder of the scenario
scene_id = 1; % Select a scene
bs_id = 3; % Select a BS
ue_id = 1; % Select a UE

%% Show Camera Images
figure;
hold on;
for cam_id=1:3
    subplot(3, 1, cam_id);
    im_path = fullfile(scenario_folder, dataset{scene_id}.bs{bs_id}.camera{cam_id}.data);
    imshow(im_path)
    title(sprintf('Basestation Camera %i', cam_id))
end

%% Lidar PCD (Requires computer vision toolbox)
figure;
pcd_path = fullfile(scenario_folder, dataset{scene_id}.bs{bs_id}.lidar{1}.data);
ptCloud = pcread(pcd_path);
pcshow(ptCloud);

%% Radar
y = dataset{scene_id}.bs{bs_id}.radar.bs{bs_id}.IF_signal; % Radar signal from BS2 to BS2
y = squeeze(y);

% Radar Signal Processing
y = fft(y, 256, 2); % Range FFT
z = sum(sum(y, 1), 2); % Clutter computation
y = y - z; % Clutter cleaning
y = fft(y, 128, 3); % Doppler FFT
y = fft(y, 128, 1); % 128-point Angle FFT
y = flip(fftshift(y, 1)); % FFTshift Angle Bins
y = fftshift(y, 3); % FFTshift Doppler Bins

% Plot Range-Angle Map
figure;
imagesc(squeeze(sum(abs(y), 3))')
set(gca,'YDir','normal') 
xlabel('Angle Bin');
ylabel('Range Bin');
title('Range-Angle Map');

%% BS-UE Channel
h = dataset{scene_id}.bs{bs_id}.comm.ue{ue_id}.channel;
figure;
plot(pow2db(flip(abs(fft(h, 128)).^2)));
ylabel('Channel Gain (dB)')
xlabel('Beam Index');
grid on;
