addpath(genpath('scripts')) %

parameters = read_deepverse_params('radar_data_params.m');
radar_folder = 'D:\abhilash\video_data_1\radar';

jump = 5;
for i = 1:jump:2000
    parameters.scenes = [i:i+jump-1];
    disp(parameters.scenes)
    dataset = generate_deepverse_dataset(parameters);
    for j = 1:jump
        disp(i+j-1)
        data = squeeze(dataset.scene{j}.bs{1}.radar.bs{1}.signal);
        data_file = fullfile(radar_folder, [num2str(i+j-2) '.mat']); % data starts from 0
        save(data_file, 'data')
    end
end