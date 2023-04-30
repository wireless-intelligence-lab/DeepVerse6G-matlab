addpath(genpath('scripts')) %
%%
jump = 5;
for scene_list = [1:jump:2000]
    
    fid =fopen('combined_params.m');
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    C{1}{6}=sprintf("dv.scenes=[%i:%i];", scene_list, scene_list+jump-1);
    fid = fopen('combined_params.m','w');            % Open the file
    for k=1:numel(C{1,1}) 
      fprintf(fid,'%s\r\n',C{1,1}{k,1}); 
    end
    fclose(fid);
    
    dataset = generate_deepverse_dataset('combined_params.m');
    for s=1:length(dataset.scene)
        scene_data = dataset.scene{s};

        y = dataset.scene{s}.bs{1}.radar.bs{1}.signal;
        data = squeeze(y);

        save(sprintf("./video_data/radar/%i.mat", scene_list+s-2), 'data')
    end
end
%     channel_paths{data_counter} = sprintf("./wireless/%i.mat", data_counter);
%     channel_path = sprintf("challenge_data/wireless/%i.mat", data_counter);
%     save(channel_path, 'channel');
%             
% end