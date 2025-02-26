num_angles = 64;
x_angles = 0:180/(num_angles):180;
x_angles = x_angles(2:end);
x_angles = flip(x_angles);
z_angles = 90 * ones(1, num_angles);
beam_angles = [z_angles', x_angles'];
codebook = beam_steering_codebook(beam_angles, 1, 16);

num_scene = size(dataset.scene, 2);
num_ue = 1;
bs_idx = 1;
bs_loc = dataset.scene{1, 1}.bs{1, bs_idx}.location;

% load all channels for bs_idx
channel_size = size(dataset.scene{1, 1}.bs{1, bs_idx}.comm.ue{1, 1}.channel);
all_channel = single(zeros([num_scene, num_ue, channel_size]));
all_ue_loc = zeros([num_scene, num_ue, 3]);
for s=1:num_scene
    for u=1:num_ue
        channel = dataset.scene{1, s}.bs{1, bs_idx}.comm.ue{1, u}.channel;
        all_channel(s,u,:,:,:) = single(channel);
        all_ue_loc(s,u,:) = dataset.scene{1, s}.bs{1, bs_idx}.comm.ue{1, u}.loc;
    end
end

%% Initialize video
myVideo = VideoWriter('comm_beam_power', 'MPEG-4'); %open video file
myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
open(myVideo);
%% Plot in a loop and grab frames
ue_idx = 1;
for scene_idx=1:1:num_scene
    subplot(1,2,1);    
    scatter(bs_loc(1), bs_loc(2), 'bo');
    hold on;
    scatter(all_ue_loc(scene_idx, ue_idx, 1), all_ue_loc(scene_idx, ue_idx, 2), 'gx');
    hold off;
    grid on;
    xlabel('x (m)');
    ylabel('y (m)');
    xlim([-100, 0]);
    ylim([0, 120]);
%     axis equal;
    legend('BS', 'UE');
    
    subplot(1,2,2);
    channel_tmp = squeeze(all_channel(scene_idx,ue_idx,:,:,:));
    beam_power = sum(abs(codebook.' * channel_tmp).^2, 2);
    plot(1:num_angles, 10*log10(beam_power));
    xlabel('Beam index');
    ylabel('Beam power (dB)');
    xlim([1, num_angles]);
    ylim([-120, -80]);
    grid on;

    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo);


function codebook = beam_steering_codebook(angles, num_z, num_x)
d = 0.5;
k_z = 0:num_z-1;
k_x = 0:num_x-1;

codebook = [];

for beam_idx=1:size(angles, 1)
    z_angle = angles(beam_idx, 1);
    x_angle = angles(beam_idx, 2);
    bf_vector_z = exp(1j*2*pi*k_z*d*cosd(z_angle));
    bf_vector_x = exp(1j*2*pi*k_x*d*cosd(x_angle));
    bf_vector = bf_vector_z.' * bf_vector_x;
    bf_vector = bf_vector(:);
    codebook = [codebook, bf_vector];
end

end