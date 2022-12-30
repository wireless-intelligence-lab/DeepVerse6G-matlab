addpath(genpath('../../scripts')) %
addpath('./functions');
%% Generate a dataset
dataset = generate_deepverse_dataset('params.m');

%% Codebook generation
num_ant = size(dataset{1}.bs{1}.comm.bs{1}.channel, 1);
num_beams = 64;
% angles_cb = acos(linspace(-1, 1, num_beams+1)'); % DFT Codebook
angles_cb = linspace(0, pi, num_beams+1)'; % Uniform Codebook
angles_cb = angles_cb(1:end-1);
F = squeeze(beamsteering(angles_cb, num_ant));

%% Optimal Beams
n_max_UE = 20; % Maximum number of UEs
n_scenes = 2000; % Number of Scenes
n_BS = 1;

beams = zeros(n_scenes, n_max_UE, n_BS);
c = 0;
for bs_idx = 1:n_BS % For each BS
    for i = 1:n_scenes % For each scene
        n_UE = length(dataset{i}.bs{bs_idx}.comm.ue); % Number of users in the scene
        for j = 1:n_UE 
            H = squeeze(dataset{i}.bs{bs_idx}.comm.ue{j}.channel);
            [~, opt_beam_idx] = max(abs(F*H'));
            beams(i, j, bs_idx) = opt_beam_idx;
        end
    end
end

%% UE Positions
position = zeros(n_scenes, n_max_UE, 2); % 2D Cartesian
for i = 1:n_scenes
    users = dataset{i}.bs{1}.comm.ue;
    for j=1:length(users)
        position(i, j, :) = [users{j}.loc(1:2)];
    end
end

%% BS Positions
pos_bs = zeros(n_BS, 2); % 2D Cartesian
for bs_idx = 1:n_BS % For each BS
    pos_bs(bs_idx, :) =  dataset{1}.bs{bs_idx}.comm.loc(1:2);
end

%% Unique UE IDs
ids = zeros(n_scenes, n_max_UE)-1;
for i = 1:n_scenes
    users = dataset{i}.ue;
    for j = 1:length(users)
        ids(i, j) = users{j}.id;
    end
end

%% Camera Images
images_c1 = {};
images_c2 = {};
images_c3 = {};
for i = 1:2000
    images_c1{i} = dataset{i}.bs{1}.camera{1}.data;
    images_c2{i} = dataset{i}.bs{1}.camera{2}.data;
    images_c3{i} = dataset{i}.bs{1}.camera{3}.data;
end

%%
output.beams = beams;
output.pos = position;
output.ids = ids;
output.images_c1 = images_c1;
output.images_c2 = images_c2;
output.images_c3 = images_c3;
output.pos_bs = pos_bs;
save('data/revised_output5paths.mat', 'output');