addpath(genpath('scripts')) %

dataset = generate_deepverse_dataset('video_params.m');

%%
ue_idx = zeros(2000, 50);

for s=1:length(dataset.scene)
    scene_data = dataset.scene{s};
    if isfield(scene_data, 'ue')
        for u=1:length(scene_data.ue)
            user_data = scene_data.ue{u};
            ue_idx(s, user_data.id+1) = 1;
        end
    end
end

%% Select Users
s_user = zeros(1, 2000);
s_user(41:457) = 1;
s_user(458:762)  = 7;
s_user(763:1044) = 20;
s_user(1045:1404) = 27;
s_user(1405:1703) = 35;
s_user(1704:1995) = 44;
s_user(1996:2000) = 47;

%% Data Generation
location = zeros(2000, 3)-1;
beam_power = zeros(2000, 64);
for s=1:length(dataset.scene)
    scene_data = dataset.scene{s};
    if isfield(scene_data, 'ue')
        for u=1:length(scene_data.ue)
            user_data = scene_data.ue{u};
            if s_user(s) == user_data.id+1
                location(s, :) = user_data.location;
                beam_power(s, :) = sum(abs(fftshift(fft(squeeze(dataset.scene{s}.bs{1}.comm.ue{u}.channel), 64, 1), 1)).^2, 2);
            end
        end
    end
end

bs_location = dataset.scene{s}.bs{1}.location;

for s=1:length(dataset.scene)
    writematrix(location(s, :)', sprintf('video_data/gps/%i.txt', s-1));
    writematrix(beam_power(s, :)', sprintf('video_data/power/%i.txt', s-1));
end

%%
figure;
hold on;
for s=1:2000
    clf;
    subplot(2, 1, 1);
    plot(beam_power(s, :)/max(beam_power(s, :)));
    subplot(2, 1, 2);
    plot(bs_location(1), bs_location(2), 'ro'); 
    hold on
    plot(location(s, 1), location(s, 2), 'bx'); 
    pause(0.05);
end

%%

% csv_file = table(location(:, 1), location(:, 2), location(:, 3), );
% csv_file.Properties.VariableNames = ["x", "y", "z", "user_idx", "scene", "los", "channel", "cam_right", "cam_mid", "cam_left", "cam_select", "radar"];
% writetable(csv_file, 'challenge_data/dataset.csv')