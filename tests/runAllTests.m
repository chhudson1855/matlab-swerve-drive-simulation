function results = runAllTests(varargin)
    %RUNALLTESTS Run every non-empty test class in the tests folder
    %   runAllTests                  run everything, print a summary
    %   results = runAllTests        also return the TestResult array
    %   runAllTests('Strict')        error if any test fails
    
    strict = any(strcmpi(varargin, 'Strict'));
    
    testsDir = fileparts(mfilename('fullpath'));
    files = dir(fullfile(testsDir, '*Test.m'));
    
    % Skip empty files
    files = files([files.bytes] > 0);
    
    if isempty(files)
        warning('runAllTests:noTests', 'No non-empty test files found in %s.', testsDir);
        results = matlab.unittest.TestResult.empty;
        return
    end
    
    [~, classNames] = cellfun(@fileparts, {files.name}, 'UniformOutput', false);
    
    fprintf('Running %d test file(s):\n', numel(classNames));
    fprintf('  %s\n', classNames{:});
    fprintf('\n');
    
    results = runtests(classNames);
    
    nPassed = nnz([results.Passed]);
    nFailed = nnz([results.Failed]);
    nIncomplete = nnz([results.Incomplete]);
    fprintf('\nTotal: %d passed, %d failed, %d incomplete.\n', ...
        nPassed, nFailed, nIncomplete);
    
    if strict && (nFailed > 0 || nIncomplete > 0)
        error('runAllTests:failures', '%d test(s) failed or were incomplete.', ...
            nFailed + nIncomplete);
    end
end