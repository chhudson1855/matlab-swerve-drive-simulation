function out = rotate2D(v, theta)
%ROTATE2D Rotate 2xN column vectors CCW by theta (radians).
arguments
    v (2,:) double
    theta (1,1) double
end
c = cos(theta);
s = sin(theta);
out = [c -s; s c] * v;
end