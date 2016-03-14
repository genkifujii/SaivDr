function testRes = mytest(testCaseStr,isProfiling)
%MYTEST Script of unit testing for SaivDr Package
%
% This test script works with unit testing framework 
% See the following site:
%
% http://www.mathworks.co.jp/jp/help/matlab/matlab-unit-test-framework.html
%
% SVN identifier:
% $Id: mytest.m 868 2015-11-25 02:33:11Z sho $
%
% Requirements: MATLAB R2013a
%
% Copyright (c) 2014-2015, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%    Faculty of Engineering, Niigata University,
%    8050 2-no-cho Ikarashi, Nishi-ku,
%    Niigata, 950-2181, JAPAN
%
% LinedIn: https://www.linkedin.com/in/shogo-muramatsu-627b084b
%

%%
import matlab.unittest.TestSuite

if nargin > 0
    isTestCase = true;
else
    clear classes %#ok
    isTestCase = false;
end

if nargin < 2
    isProfiling = false;
end

%% Package list
packageList = { ...
    'saivdr.testcase.dictionary.olpprfb',...
    'saivdr.testcase.dictionary.udhaar',...
    'saivdr.testcase.dictionary.nsoltx',...
    'saivdr.testcase.dictionary.nsoltx.design',...
    'saivdr.testcase.dictionary.nsgenlotx',...
    'saivdr.testcase.dictionary.nsgenlotx.design',...    
    'saivdr.testcase.dictionary.generalfb',...
    ...%'saivdr.testcase.dictionary.nsolt',...
    ...%'saivdr.testcase.dictionary.nsolt.design',...
    ...%'saivdr.testcase.dictionary.nsgenlot',...
    ...%'saivdr.testcase.dictionary.nsgenlot.design',...
    'saivdr.testcase.dictionary.mixture',...
    'saivdr.testcase.dictionary.utility',...
    'saivdr.testcase.utility',...
    'saivdr.testcase.sparserep',...
    'saivdr.testcase.degradation',...
    'saivdr.testcase.degradation.noiseprocess',...
    'saivdr.testcase.degradation.linearprocess',...
    'saivdr.testcase.restoration.ista',...
    'saivdr.testcase.embedded' };

%% Set path
setpath

%% Open matlabpool or parpool
%{
isOpeningPct = false;
isPctAvailable = license('checkout','distrib_computing_toolbox');
if isPctAvailable 
    if exist('matlabpool','file') == 2 && ... % Before R2013b
            ~verLessThan('distcomp','4.0') && verLessThan('distcomp','6.4')
        if matlabpool('size') < 1 %#ok 
            matlabpool %#ok
            isOpeningPct = true;
        end
    elseif exist('parpool','file') == 2 && isempty(gcp('nocreate'))
        poolobj = parpool;
        isOpeningPct = true;
    end
end
%}

%% Run test cases
if isProfiling
    profile on
end
if isTestCase
    testCase = eval(testCaseStr);
    testRes = run(testCase);
else
    testRes = cell(length(packageList),2);
    for idx = 1:length(packageList)
        if verLessThan('matlab','8.2.0.701') && ...
                strcmp(packageList{idx},'saivdr.testcase.embedded')
            disp('Package +embedded is available for R2013b or later.')
        else
            packageSuite = TestSuite.fromPackage(packageList{idx});
            testRes{idx,1} = packageList{idx};
            testRes{idx,2} = run(packageSuite);
        end
    end
end
if isProfiling
    profile off
    profile viewer
end

%% Close matlabpool or parpool
%{
if isPctAvailable && isOpeningPct
    if exist('matlabpool','file') == 2 && ... % Before R2013b
            ~verLessThan('distcomp','4.0') && verLessThan('distcomp','6.4')
        if matlabpool('size') > 0 %#ok
            matlabpool close %#ok
        end
    elseif exist('parbpool','file') == 2 
        p = gcp('nocreate');
        if p.NumWorkers > 0 
            delete(poolobj)
        end
    end
        
end
%}

%% License check
license('inuse')