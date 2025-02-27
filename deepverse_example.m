addpath(genpath('scripts')) %

scenario_name = 'DT31';
parameters = read_deepverse_params(fullfile('scenarios', scenario_name, 'param' ,'config.m'));
dataset = generate_deepverse_dataset(parameters);

dataset.info.radar.params.radar_KPI
