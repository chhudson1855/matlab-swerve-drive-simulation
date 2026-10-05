function y = deadband(x, db, maxMag)
    %DEADBAND Zero out |x| <= db, rescale the remainder to span [0, maxMag].
    %   y = swerve.util.deadband(x, db)          % maxMag = 1
    %   y = swerve.util.deadband(x, db, maxMag)
    arguments
        x double
        db (1,1) double {mustBeNonnegative}
        maxMag (1,1) double {mustBePositive} = 1
    end
    if db >= maxMag
        error('swerve:util:deadband:badBand', 'db must be < maxMag.');
    end
    mag = max(abs(x) - db, 0);
    y = sign(x) .* mag .* (maxMag / (maxMag - db));
end