function y = clamp(x, lo, hi)
    arguments
        x double
        lo double
        hi double
    end

    if any(lo(:) > hi(:))
        error('swerve:util:clamp:badRange', 'lo must be <= hi.');
    end
    y = min(max(x, lo), hi);
end