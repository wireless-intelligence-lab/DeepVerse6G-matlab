
mm_count = 0;
for i_sc = 1:length(wv_ds)
    
    % Extract number of objects in WI and SUMO
    n_objects_tr = length(wv_ds{i_sc}.trajectory.objects);
    if isfield(wv_ds{i_sc}.bs1.wireless.channels, 'user')
        n_objects_wi = length(wv_ds{i_sc}.bs1.wireless.channels.user);
    else
        n_objects_wi = 0;
    end
    
    % Compare the number and print the output if there is a mismatch
    if n_objects_tr ~= n_objects_wi
        mm_count = mm_count + 1;
        fprintf('Mismatch in scene %i: Tr/WI - %i/%i\n', i_sc, n_objects_tr, n_objects_wi)
        
        
        traj_loc = [wv_ds{i_sc}.trajectory.objects{n_objects_tr}.x, ...
            wv_ds{i_sc}.trajectory.objects{n_objects_tr}.y,  ...
            wv_ds{i_sc}.trajectory.objects{n_objects_tr}.tx_height];
        
        fprintf('Last user (%i) location: [%.2f, %.2f, %.2f]\n', n_objects_tr, traj_loc); 
    else
        % fprintf('Match in scene %i\n', i_sc);
    end
    
    % Compare the locations
    for i_obj = 1:n_objects_wi
        traj_loc = [wv_ds{i_sc}.trajectory.objects{i_obj}.x, ...
            wv_ds{i_sc}.trajectory.objects{i_obj}.y,  ...
            wv_ds{i_sc}.trajectory.objects{i_obj}.tx_height];
        wireless_loc = wv_ds{i_sc}.bs1.wireless.channels.user{i_obj}.loc;
        if ~compare_locs(traj_loc, wireless_loc)
            fprintf('Object %i\n', i_obj);
        end
    end
end

function location_match = compare_locs(x, y)
    p2p_dist = sqrt(sum((x - y).^2));
    location_match = p2p_dist < 1e-4;
end