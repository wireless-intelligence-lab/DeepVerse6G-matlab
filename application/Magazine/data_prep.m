addpath(genpath('../scripts')) %

wv_ds = generate_wirelessverse_dataset('wv_params.m');

%% Codebook generation
num_ant = size(wv_ds{1}.bs1.wireless.channels.basestation{1}.channel, 1);
num_beams = 64;
% angles_cb = acos(linspace(-1, 1, num_beams+1)');
angles_cb = linspace(0, pi, num_beams+1)';
angles_cb = angles_cb(1:end-1);
F = squeeze(beamsteering(angles_cb, num_ant));

%% Beams
beams = zeros(2000, 20, 4);
los = zeros(2000, 20, 4)-2;
c = 0;
for bs_idx=1:4
    for i=1:length(wv_ds) % For each scene
        for j=1:length(wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user) % Number of users in the scene
            ch = squeeze(wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user{j}.channel);
            [~, beam_idx] = max(abs(F*ch'));
            beams(i, j, bs_idx) = beam_idx;
            los(i, j, bs_idx) = wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user{j}.LoS_status;
%             if (wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user{j}.LoS_status == 1) && (bs1_beams(i, j) ~= beam_idx) && (bs_idx == 1)
%                 user_data = wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user{j};
%                 dist = user_data.loc(1:2)-pos_bs(1, :);
%                 angle = atan(dist(:, 2)/dist(:, 1)) ;
%                 
%                 disp([num2str(i), '-', num2str(j)])
%                 c = c+1;
%             end
        end
    end
end

%%
b = [];
for bs_idx=1:4
    b = [b, nonzeros(beams(:, :, bs_idx))];
end
figure;
hist(b, 32)
hold on
xlabel('Beam Index')
ylabel('Count')
legend('BS1', 'BS2', 'BS3', 'BS4')
grid on;

%% Positions
max_vehicles = 20;
scenes = 2000;
wir_pos = zeros(scenes, max_vehicles, 2);
for i=1:scenes
    users = wv_ds{i}.bs1.wireless.channels.user;
    for j=1:length(users)
        wir_pos(i, j, :) = [users{j}.loc(1:2)];
    end
end

%% Basestation Positions 2D
pos_bs = [wv_ds{1}.bs1.wireless.channels.loc
          wv_ds{1}.bs2.wireless.channels.loc
          wv_ds{1}.bs3.wireless.channels.loc
          wv_ds{1}.bs4.wireless.channels.loc];
pos_bs = pos_bs(:, 1:2);

%% Angles
pos_rs = reshape(wir_pos, 2000*20, []);
nonzero_ind = sum(pos_rs~=0, 2)>0;
pos_rs = pos_rs(nonzero_ind, :);
dist = pos_rs-pos_bs(1, :);
angle = atan2(dist(:, 2), dist(:, 1)) ;

bs1_beams = beams(:, :, 1);
bs1_beams_rs = reshape(bs1_beams, 2000*20, []);
bs1_beams_nonzero = bs1_beams_rs(nonzero_ind);
beam_angle = angles_cb(bs1_beams_nonzero);
[~, los_beam_map] = min(abs(angle-angles_cb'), [], 2);
los_beam_map = round(angle/pi*num_beams)+1; % Alternative way for finding beams
plot(los_beam_map, bs1_beams_nonzero, 'x')
grid on;
xlabel('Beam of LoS Angle')
ylabel('Optimal Beam')
mean(abs(bs1_beams_nonzero - los_beam_map)<=0)
mean(abs(bs1_beams_nonzero - los_beam_map)<=1)
mean(abs(bs1_beams_nonzero - los_beam_map)<=2)

%% IDs
all_pos = [];
max_vehicles = 20;
scenes = 2000;
ids = zeros(scenes, max_vehicles)-1;
for i=1:scenes
    vehicles = wv_ds{i}.trajectory.objects;
    for j=1:length(vehicles)
        ids(i, j) = vehicles{j}.id;
    end
end

%%
output.beams = beams;
output.pos = wir_pos;
output.ids = ids;
images_c1 = {};
images_c2 = {};
images_c3 = {};
lidar = {};
for i = 1:2000
    images_c1{i} = wv_ds{i}.bs1.image.cam1.data;
    images_c2{i} = wv_ds{i}.bs1.image.cam2.data;
    images_c3{i} = wv_ds{i}.bs1.image.cam3.data;
    lidar{i} = wv_ds{i}.bs1.lidar.data;
end
output.images_c1 = images_c1;
output.images_c2 = images_c2;
output.images_c3 = images_c3;
output.lidar = lidar;
output.pos_bs = pos_bs;
% save('output1paths.mat', 'output');