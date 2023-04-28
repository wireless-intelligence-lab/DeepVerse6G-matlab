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
        y = squeeze(y);

        % Radar Signal Processing
        y = fft(y, 512, 2); % Range FFT
        z = sum(sum(y, 1), 2); % Clutter computation
        y = y - z; % Clutter cleaning
        y = fft(y, 128, 3); % Doppler FFT
        y = fft(y, 128, 1); % 128-point Angle FFT
        y = fftshift(y, 1); % FFTshift Angle Bins
        y = fftshift(y, 3); % FFTshift Doppler Bins
        ra = squeeze(sum(abs(y), 3))';
        save(sprintf("./challenge_data/radar/%i.mat", scene_list+s-2),'ra')
    end
end
%     channel_paths{data_counter} = sprintf("./wireless/%i.mat", data_counter);
%     channel_path = sprintf("challenge_data/wireless/%i.mat", data_counter);
%     save(channel_path, 'channel');
%             
% end