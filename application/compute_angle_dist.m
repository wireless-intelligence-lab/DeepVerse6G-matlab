function [angle, euc_dist] = compute_angle_dist(pos1, pos2)
    a = pos2';
    a = a(:)';
    b = repmat(pos1, 1, size(pos2, 1));
    dist_vec = b-a;
    
    % Following distance and angle computations are to be 
    % replaced with efficient reshape by (U * M_t) x 2,
    % computation and reshaping again to (U x M_t).
    x_dist = dist_vec(:, 1:2:end);
    y_dist = dist_vec(:, 2:2:end);
    euc_dist = sqrt(x_dist.^2 + y_dist.^2);
    
    angle = atan2(y_dist, x_dist); 
    % Angle quadrant problem is fixed with atan2, 
    % i.e., x pos y neg still returns pos angle at 90+.
end

