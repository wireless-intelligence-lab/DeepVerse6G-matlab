addpath(genpath('../scripts')) %

wv_ds = generate_wirelessverse_dataset('wv_params.m');

%% Extract trajectory data
all_pos = [];
max_vehicles = 20;
scenes = 2000;
pos = zeros(scenes, max_vehicles, 2);
ids = zeros(scenes, max_vehicles)-1;
speed = zeros(scenes, max_vehicles);
for i=1:scenes
    vehicles = wv_ds{i}.trajectory.objects;
    for j=1:length(vehicles)
        pos(i, j, :) = [vehicles{j}.x vehicles{j}.y];
        ids(i, j) = vehicles{j}.id;
        speed(i, j) = vehicles{j}.speed;
    end
end

%% Extract Wireless Data
all_pos = [];
max_vehicles = 20;
scenes = 2000;
wir_pos = zeros(scenes, max_vehicles, 2);
for i=1:scenes
    users = wv_ds{i}.bs1.wireless.channels.user;
    for j=1:length(users)
        wir_pos(i, j, :) = [users{j}.loc(1:2)];
    end
end

%%
% Number of vehicles on the scene in each time-step
figure;
plot(sum(pos(:, :, 1)~=0, 2))
xlabel('Time-Step')
ylabel('# of Vehicles')

figure;
plot(speed(:, 1))
xlabel('Time-Step')
ylabel('Speed (m/s)')

figure;
plot(pos(:, 1, 1))
xlabel('Time-Step')
ylabel('x-position')
% The order of the vehicles is broken, it needs to be fixed

%% Channel position
figure;
plot(sum(wir_pos(:, :, 1)~=0, 2))
xlabel('Time-step')
ylabel('# of Vehicles')
grid on;

%% Number of Vehicles
figure;
grid on;
plot(wir_pos(:, 1, 1))
xlabel('Time-step')
ylabel('x-position')

%% By ID sorting
figure;
num_vehicles = max(ids, [], 'all');
for vehicle_id = 0:num_vehicles
    veh_sel = ids'==vehicle_id';
    [val, ~] = max(veh_sel, [], 1);
    veh_idx = find(veh_sel);
    pos_x = pos(:, :, 1)';
    pos_y = pos(:, :, 2)';
    plot(find(val), pos_x(veh_idx), '-')
    hold on
end
grid on
xlabel('Time-step')
ylabel('x (m)')

%% Speed
figure;
for vehicle_id = 0:num_vehicles
    veh_sel = ids'==vehicle_id';
    [val, ~] = max(veh_sel, [], 1);
    veh_idx = find(veh_sel);
    speed_t = speed';
    % plot(find(val), speed_t(veh_idx), '-x')
    plot(speed_t(veh_idx), '-')
    hold on
end
grid on
xlabel('Time-step from the entry of the vehicle')
ylabel('Speed (m/s)')

%% Distance to Closest Basestation
pos_bs = [wv_ds{1}.bs1.wireless.channels.loc
          wv_ds{1}.bs2.wireless.channels.loc
          wv_ds{1}.bs3.wireless.channels.loc
          wv_ds{1}.bs4.wireless.channels.loc];
pos_bs = pos_bs(:, 1:2);

%% By ID sorting
perscene_counter = zeros(2000, 4);
num_vehicles = max(ids, [], 'all');
angles = zeros(2000, num_vehicles+1, 4);
for vehicle_id = 0:num_vehicles
    veh_sel = ids'==vehicle_id';
    [val, ~] = max(veh_sel, [], 1);
    veh_idx = find(veh_sel);
    pos_x = pos(:, :, 1)';
    pos_y = pos(:, :, 2)';
    pos_v = [pos_x(veh_idx) pos_y(veh_idx)];
    [ang, dist] = compute_angle_dist(pos_v, pos_bs);
    [~, bs_idx] = min(dist, [], 2);
    scenes = find(val)';
    angles(scenes, vehicle_id+1, :) = rad2deg(ang);
    index = sub2ind(size(perscene_counter), scenes, bs_idx);
    perscene_counter(index) = perscene_counter(index) + 1;
end
figure;
c = lines(5);
area(perscene_counter)
colororder(c);
grid on;
xlabel('Time-step')
ylabel('# of vehicles closest to the basestations')
legend('BS1', 'BS2', 'BS3', 'BS4')

%% LoS collection
los = zeros(2000, 20, 4)-2;
for bs_idx=1:4
    for i=1:length(wv_ds) % For each scene
        for j=1:length(wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user) % Number of users in the scene
            los(i, j, bs_idx) = wv_ds{i}.(['bs' num2str(bs_idx)]).wireless.channels.user{j}.LoS_status;
        end
    end
end
%% LoS histogram
l = [];
for bs_idx=1:4
    sel_l = los(:, :, bs_idx);
    l = [l, sel_l(sel_l~=-2)];
end

figure;
label = categorical({'NLoS', 'LoS'});
hist(label(l+1))
xlabel('LoS Status')
ylabel('Number of Channels')
legend('BS1', 'BS2', 'BS3', 'BS4')
grid on;

%% Angle distribution
angles_reversed = angles;
angles_reversed(angles_reversed<0) = 180+angles_reversed(angles_reversed<0);

for veh_idx = 1:40
    figure;
    set(gca,'ColorOrderIndex',1)
    for bs_idx = 1:4
        plot(angles_reversed(:, veh_idx, bs_idx), 'x')
        hold on;
    end
end
ylabel('Angle (deg)')
xlabel('Time-steps')
legend('BS1', 'BS2', 'BS3', 'BS4')
grid on;

figure;
hdata = reshape(angles_reversed, 2000*48, 4);
hist(hdata(hdata~=0), 350);
grid on;
xlabel('Angle (deg)');
ylabel('Count');