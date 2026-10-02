classdef UtilTest < matlab.unittest.TestCase
    %UTILTEST Unit tests for swerve.util functions.
    %   Run with: runtests('UtilTest')

    properties (Constant)
        Tol = 1e-12;
    end

    methods (Test)

        % ---------------- wrapToPi ----------------
        function wrapToPi_insideRangeUnchanged(tc)
            x = [-3, -1, 0, 1, 3];
            tc.verifyEqual(swerve.util.wrapToPi(x), x, 'AbsTol', tc.Tol);
        end

        function wrapToPi_wrapsPastPositive(tc)
            tc.verifyEqual(swerve.util.wrapToPi(pi + 0.1), -pi + 0.1, 'AbsTol', tc.Tol);
        end

        function wrapToPi_wrapsPastNegative(tc)
            tc.verifyEqual(swerve.util.wrapToPi(-pi - 0.1), pi - 0.1, 'AbsTol', tc.Tol);
        end

        function wrapToPi_multipleRevolutions(tc)
            tc.verifyEqual(swerve.util.wrapToPi(10*pi + 0.5), 0.5, 'AbsTol', 1e-10);
            tc.verifyEqual(swerve.util.wrapToPi(-10*pi - 0.5), -0.5, 'AbsTol', 1e-10);
        end

        function wrapToPi_boundaries(tc)
            tc.verifyEqual(swerve.util.wrapToPi(pi), pi);
            tc.verifyEqual(swerve.util.wrapToPi(-pi), -pi);
            tc.verifyEqual(swerve.util.wrapToPi(3*pi), pi);
        end

        function wrapToPi_preservesShape(tc)
            x = rand(3, 4) * 20 - 10;
            tc.verifySize(swerve.util.wrapToPi(x), size(x));
        end

        function wrapToPi_resultAlwaysInRange(tc)
            x = linspace(-50, 50, 1001);
            y = swerve.util.wrapToPi(x);
            tc.verifyGreaterThanOrEqual(y, -pi);
            tc.verifyLessThanOrEqual(y, pi);
        end

        function wrapToPi_shortestErrorAcrossSeam(tc)
            % Target 179 deg, current -179 deg: shortest error is -2 deg.
            err = swerve.util.wrapToPi(deg2rad(179) - deg2rad(-179));
            tc.verifyEqual(err, deg2rad(-2), 'AbsTol', tc.Tol);
        end

        function wrapToPi_smallGapAcrossZero(tc)
            err = swerve.util.wrapToPi(deg2rad(1) - deg2rad(359));
            tc.verifyEqual(err, deg2rad(2), 'AbsTol', tc.Tol);
        end

        % ---------- clamp ----------
        function clampInsideRangeUnchanged(tc)
            tc.verifyEqual(swerve.util.clamp(0.5, 0, 1), 0.5);
        end
        function clampBelowAndAbove(tc)
            tc.verifyEqual(swerve.util.clamp(-3, -1, 1), -1);
            tc.verifyEqual(swerve.util.clamp(3, -1, 1), 1);
        end
        function clampBoundaryValues(tc)
            tc.verifyEqual(swerve.util.clamp([-1 1], -1, 1), [-1 1]);
        end
        function clampIsElementwise(tc)
            tc.verifyEqual(swerve.util.clamp([-2 0 2], -1, 1), [-1 0 1]);
        end
        function clampBadRangeErrors(tc)
            tc.verifyError(@() swerve.util.clamp(0, 1, -1), 'swerve:util:clamp:badRange');
        end
    end
end