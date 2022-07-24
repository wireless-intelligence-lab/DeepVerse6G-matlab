% ID map generator for the first test scenario



%% Basestations
BS_ID_map_struct = struct('ID',[],'sub_ID',[],'boresight_phi',[],'boresight_theta',[]);

% The developer will set these values from the Wireless InSite setup file
BS_ID_map_struct(1).ID = 2;
BS_ID_map_struct(1).sub_ID = 1;
BS_ID_map_struct(1).boresight_azimuth_angle = 270;
BS_ID_map_struct(1).boresight_elevation_angle = 90;

BS_ID_map_struct(2).ID = 5;
BS_ID_map_struct(2).sub_ID = 1;
BS_ID_map_struct(2).boresight_azimuth_angle = 90;
BS_ID_map_struct(2).boresight_elevation_angle = 90;

BS_ID_map_struct(3).ID = 6;
BS_ID_map_struct(3).sub_ID = 1;
BS_ID_map_struct(3).boresight_azimuth_angle = 90;
BS_ID_map_struct(3).boresight_elevation_angle = 90;

BS_ID_map_struct(4).ID = 7;
BS_ID_map_struct(4).sub_ID = 1;
BS_ID_map_struct(4).boresight_azimuth_angle = 270;
BS_ID_map_struct(4).boresight_elevation_angle = 90;

% An auto-generated part of the code
BS_ID_map = zeros(numel(BS_ID_map_struct),5);
for cc=1:1:numel(BS_ID_map_struct)
    BS_ID_map(cc,:) = [cc, BS_ID_map_struct(cc).ID, BS_ID_map_struct(cc).sub_ID, BS_ID_map_struct(cc).boresight_azimuth_angle, BS_ID_map_struct(cc).boresight_elevation_angle];
end
%First column is the BS index published on the website
%Second and third columns are the BS index and sub index from WI
%Fourth and Fifth columns are the BS boresight azimuth and elevation angles

%% Users
user_ID_map_struct = struct('ID',[],'sub_ID',[]);

% The developer will set these values from the Wireless InSite setup file
for dd=1:1:12
    user_ID_map_struct(dd).ID = 3;
    user_ID_map_struct(dd).sub_ID = dd;
end

% An auto-generated part of the code
user_ID_map = zeros(numel(user_ID_map_struct),6);
for cc=1:1:numel(user_ID_map_struct)
    user_ID_map(cc,:) = [cc, user_ID_map_struct(cc).ID, user_ID_map_struct(cc).sub_ID, cc, cc, 1]; %%%% the last three columns are for old user_grids variable
end

%First column is the BS index published on the website
%Second and third columns are the BS index and sub index from Wireless InSite
%Fourth to sixth columns are the BS boresight azimuth and elevation angles

%% save data
save scenario_params2.mat BS_ID_map user_ID_map BS_ID_map_struct user_ID_map_struct