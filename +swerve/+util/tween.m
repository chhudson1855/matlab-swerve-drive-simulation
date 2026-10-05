function y = tween(current, target, rate, dt)
%TWEEN Move current toward target, limited to rate*dt per call.
%   rate in units/second, dt in seconds.
arguments
    current double
    target double
    rate (1,1) double {mustBeNonnegative}
    dt (1,1) double {mustBePositive}
end
maxStep = rate * dt;
y = current + swerve.util.clamp(target - current, -maxStep, maxStep);
end