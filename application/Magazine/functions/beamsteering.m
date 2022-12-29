function [a_theta] = beamsteering(varargin) 
    % inputs are in the shape of beamsteering(theta, num_ant, %optional% lambda)
    % theta in radians, can be any shape
    % lambda is a ratio that needs to be set as 1/2 for lambda/2 antenna spacing
    % Returns beamsteering vector a(theta) expanded into the last dimension
    % i.e., the output has the shape (size(theta) x num_ant)
    
    if nargin == 2
        theta = varargin{1};
        num_ant = varargin{2};
    end
    if nargin > 2
        lambda = varargin{3};
    else
        lambda = 1/2;
    end
    
    dim = length(size(theta));
    k = reshape([0:num_ant-1], [ones(1, dim), num_ant]);
    
    a_theta = exp(1j*2*pi*lambda*k.*cos(theta));
    
end

