function wrapped = wrapToPi(angle)
% WRAPTOPI Wrap angles in radians to the interval [-pi, pi].
%
%   wrapped = swerve.util.wrapToPi(angle)
%
%   Works per element on scalars, vectors, and matrices.
%   +pi stays +pi, -pi stays -pi

wrapped = mod(angle + pi, 2*pi) - pi;

% mod() maps odd positive multiples of pi to -pi; restore them to +pi.
wrapped((wrapped == -pi) & (angle > 0)) = pi;

end