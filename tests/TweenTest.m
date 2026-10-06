classdef TweenTest < matlab.unittest.TestCase
    %TWEENTEST Unit tests for swerve.util.tween.
    %   Run with: runtests('TweenTest')

    properties (Constant)
        Tol = 1e-12;
    end

    methods (Test)

        function reachesTargetWhenWithinStep(tc)
            % distance 0.05 < maxStep 0.2, so it lands exactly on target
            tc.verifyEqual(swerve.util.tween(0.95, 1, 2, 0.1), 1, 'AbsTol', tc.Tol);
        end

        function limitedToRateTimesDt(tc)
            % distance 1, maxStep 0.2
            tc.verifyEqual(swerve.util.tween(0, 1, 2, 0.1), 0.2, 'AbsTol', tc.Tol);
        end

        function movesDownward(tc)
            tc.verifyEqual(swerve.util.tween(0, -1, 2, 0.1), -0.2, 'AbsTol', tc.Tol);
        end

        function noOvershootOverManySteps(tc)
            x = 0;
            for k = 1:100
                x = swerve.util.tween(x, 1, 2, 0.1);
                tc.verifyLessThanOrEqual(x, 1);
            end
            tc.verifyEqual(x, 1, 'AbsTol', tc.Tol);
        end

        function atTargetStaysPut(tc)
            tc.verifyEqual(swerve.util.tween(1, 1, 2, 0.1), 1);
        end

        function worksOnVectors(tc)
            out = swerve.util.tween([0 0], [1 -1], 2, 0.1);
            tc.verifyEqual(out, [0.2 -0.2], 'AbsTol', tc.Tol);
        end

        function zeroRateHolds(tc)
            tc.verifyEqual(swerve.util.tween(0.3, 1, 0, 0.1), 0.3);
        end

        function negativeRateErrors(tc)
            tc.verifyError(@() swerve.util.tween(0, 1, -1, 0.1), ...
                'MATLAB:validators:mustBeNonnegative');
        end

        function zeroDtErrors(tc)
            tc.verifyError(@() swerve.util.tween(0, 1, 2, 0), ...
                'MATLAB:validators:mustBePositive');
        end
    end
end