% Add the DeepVerse scripts to the path 
addpath(genpath('../../scripts'))
addpath(genpath('./functions'))

%% Generate a Dataset
dataset = generate_deepverse_dataset('general_params.m');


%% Show Camera Images
scenario_folder = dataset{1}.bs1.image.folder; 
% Folder of the scenario

figure;
hold on;
for i=1:3
    subplot(3, 1, i);
    im_path = fullfile(scenario_folder, dataset{1}.bs2.image.(sprintf('cam%i',i)).data);
    imshow(im_path)
    title(sprintf('Basestation Camera %i', i))
end

%% Lidar PCD (Requires computer vision toolbox)

figure;
pcd_path = fullfile(scenario_folder, dataset{1}.bs3.lidar.data);
ptCloud = pcread(pcd_path);
pcshow(ptCloud);

%% Radar
y = dataset{1}.bs2.radar.channels.basestation{2}.IF_signal;
y = squeeze(y);

% Radar Signal Processing
y = fft(y, 512, 2); % Range FFT
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
h = dataset{1}.bs2.wireless.channels.user{2}.channel;
figure;
plot(pow2db(abs(fft(h, 128))));
ylabel('Channel Gain (dB)')
xlabel('Beam Index');
grid on;
