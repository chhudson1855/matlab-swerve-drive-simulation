classdef RollingBufferTest < matlab.unittest.TestCase
    methods (Test)
        function startsEmpty(tc)
            b = swerve.util.RollingBuffer(3);
            tc.verifyEqual(b.Count, 0);
            tc.verifyEmpty(b.values());
            tc.verifyFalse(b.isFull());
        end
        function pushIncreasesCount(tc)
            b = swerve.util.RollingBuffer(3);
            b.push(1); b.push(2);
            tc.verifyEqual(b.Count, 2);
        end
        function valuesOldestToNewest(tc)
            b = swerve.util.RollingBuffer(3);
            b.push(1); b.push(2);
            tc.verifyEqual(b.values(), [1 2]);
        end
        function overwritesOldestWhenFull(tc)
            b = swerve.util.RollingBuffer(3);
            for k = 1:5, b.push(k); end
            tc.verifyEqual(b.values(), [3 4 5]);
            tc.verifyEqual(b.Count, 3);
            tc.verifyTrue(b.isFull());
        end
        function latestReturnsNewest(tc)
            b = swerve.util.RollingBuffer(3);
            for k = 1:4, b.push(k); end
            tc.verifyEqual(b.latest(), 4);
        end
        function meanWhilePartiallyFilled(tc)
            b = swerve.util.RollingBuffer(4);
            b.push(2); b.push(4);
            tc.verifyEqual(b.mean(), 3, 'AbsTol', 1e-12);
        end
        function meanOnlyUsesWindow(tc)
            b = swerve.util.RollingBuffer(3);
            for k = [100 1 2 3], b.push(k); end   % 100 should be gone
            tc.verifyEqual(b.mean(), 2, 'AbsTol', 1e-12);
        end
        function resetClears(tc)
            b = swerve.util.RollingBuffer(3);
            b.push(1); b.push(2);
            b.reset();
            tc.verifyEqual(b.Count, 0);
            tc.verifyEmpty(b.values());
            b.push(7);
            tc.verifyEqual(b.values(), 7);
        end
        function handleSemanticsMutateInPlace(tc)
            b = swerve.util.RollingBuffer(2);
            alias = b;
            b.push(5);
            tc.verifyEqual(alias.latest(), 5);
        end
        function emptyMeanErrors(tc)
            b = swerve.util.RollingBuffer(3);
            tc.verifyError(@() b.mean(), 'swerve:RollingBuffer:empty');
        end
        function emptyLatestErrors(tc)
            b = swerve.util.RollingBuffer(3);
            tc.verifyError(@() b.latest(), 'swerve:RollingBuffer:empty');
        end
        function badCapacityErrors(tc)
            tc.verifyError(@() swerve.util.RollingBuffer(0), 'MATLAB:validators:mustBePositive');
        end
    end
end