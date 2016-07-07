function extractCrashLogs(nDays,logDir)
% function extractCrashLogs(nDays,logDir)
% 
% This function will search for any crash logs MATLAB generated
% in the last nDays and create a ZIP file with these logs.  
%
%   extractCrashLogs() extracts any crash logs MATLAB generated 
%   in the last 60 days found within the default temporary directory.
%
%   extractCrashLogs(nDays)extracts any crash logs MATLAB generated 
%   in the last nDays found within the default temporary directory.
%   
%   extractCrashLogs(nDays,rootDir)extracts any crash logs MATLAB generated 
%   in the last nDays found within the rootDir directory.
%
% The default temporary directory is found according to the following article:
%
% http://www.mathworks.com/matlabcentral/answers/100816-how-do-i-locate-the-crash-dump-files-generated-by-matlab
% 

% Copyright 2014 The MathWorks, Inc. 


%% Check for inputs
if nargin < 1
    % Define number of days to go back
    nDays = 60;
end
if nargin < 2
    % Determine log directory
    logDir = determineLogDir();
end

%% Extract recent files that match "matlab_crash_dump.XXXX", "java.log.XXXX", or "hs_error_pidXXXX.log"

% Extract directory file names and identify files created in last n days
listing         = dir(logDir);
fileNames       = arrayfun(@(l)l.name,listing,'UniformOutput',false);
fileDates       = arrayfun(@(l)l.datenum,listing);

% Define dates
endDate         = now;
startDate       = endDate-nDays;

% Select recent files
areRecent       = fileDates >= startDate;
recentFileNames = fileNames(areRecent);

% Extract matches to file name keywords
fprintf('Collecting information...')
matchFiles = findLogFiles(recentFileNames);

%% ZIP files together
noneFound = isempty(matchFiles);
if noneFound
    fprintf('\nNo crash logs found since %s',datestr(startDate,'dd-mmm-yyyy'))
    fprintf('\nConsider searching further back in time\n');
    return
else
    fprintf('\nFound %d files.\nCreating ZIP file...',size(matchFiles,1))
end
% Create ZIP file
startDateStr = datestr(startDate,'dd_mm_yy');
endDateStr = datestr(endDate,'dd_mm_yy');
filename = sprintf('Crash_logs_%s_%s.zip',startDateStr,endDateStr);
zip(filename,matchFiles,logDir)

fprintf('\nDone, please send "%s" to MathWorks Tech Support.\n',filename)


function matchFiles = findLogFiles(files)
% Finds filenames matching known crash log names

% Find file names that match "matlab_crash_dump."
rightMatchML = strncmpi(files,'matlab_crash_dump',17);
% Remove those that have ".dmp" extension
[~,ext] = strtok(files,'.');
wrongMatchML = strncmpi(ext,'.dmp',4);
matchML = rightMatchML & ~wrongMatchML;

% Find file names that match "java.log."
matchJava = strncmpi(files,'java.log',8);

% Find file names that match "hs_error_pid"
matchHs = strncmpi(files,'hs_error_pid',12);

% Extract filenames that match any
anyMatch = matchML | matchJava | matchHs;
matchFiles = files(anyMatch);


function logDir = determineLogDir()
% Determines log directory from OS

if isunix
    % Ask OS for it
    [status,result] = system('$HOME');
    okStatus = status == 1;
    if okStatus
        
        % Split result based on ":" in case of permission issues
        logDir = strsplit(result,':');
        logDir = logDir{1};
        
        % Check directory exists
        validDir = exist(logDir,'dir') ~= 0;
        if ~validDir
            % Ask for it
            logDir = uigetdir(pwd,'Identify your Home Directory');
        end
        
    else 
        
        % Ask for it
        logDir = uigetdir(pwd,'Identify your Home Directory');
        
    end
    
elseif ispc
    
    logDir = tempdir;
    
else
    
    errordlg('Error determining platform type.');
    return
end
