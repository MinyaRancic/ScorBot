function installScorBotToolbox(replaceExisting)
% INSTALLSCORBOTTOOLBOX installs ScorBot Toolbox for MATLAB.
%   INSTALLSCORBOTTOOLBOX installs ScorBot Toolbox into the following 
%   locations:
%                        Source: Destination
%       ScorBotToolboxFunctions: matlabroot\toolbox\scorbot
%         ScorBotToolboxSupport: matlabroot\bin\win32 
%
%   INSTALLSCORBOTTOOLBOX(true) installs ScorBot Toolbox regardless of
%   whether a copy of the ScorBot toolbox exists in the MATLAB root.
%
%   INSTALLSCORBOTTOOLBOX(false) installs ScorBot Toolbox only if no copy 
%   of the ScorBot toolbox exists in the MATLAB root.
%
%   NOTE: This toolbox requires a 32-bit Windows Operating System.
%
%   (c) M. Kutzer 10Aug2015, USNA

% Updates
%   26Aug2015 - Updated to include replaceExisting to support
%               "ScorUpdate.m"
%   26Aug2015 - Updated to include rehash of toolbox cache
%   26Aug2015 - Updated to include drawnow before rehash of toolbox cache

%% Check inputs
if nargin == 0
    replaceExisting = [];
end

%% Installation error solution(s)
adminSolution = sprintf(...
    ['Possible solution:\n',...
     '\t(1) Close current instance of MATLAB\n',...
     '\t(2) Open a new instance of MATLAB "as administrator"\n',...
     '\t\t(a) Locate MATLAB shortcut\n',...
     '\t\t(b) Right click\n',...
     '\t\t(c) Select "Run as administrator"\n']);

%% Check operating system info and compiler
if ispc
    switch computer
        case 'PCWIN'
            fprintf('32-bit Windows Operating System detected.\n');
            cc = mex.getCompilerConfigurations('C');
            switch cc.Name
                case 'lcc-win32'
                    fprintf('Mex compiler: "%s"\n',cc.Name);
                otherwise
                    fprintf('Unexpected Mex compiler: "%s"\n',cc.Name);
            end
        case 'PCWIN64'
            fprintf('64-bit Windows Operating System detected.\n');
            error('ScorBot Toolbox is not currently supported on 64-bit OS.');
        otherwise
            error('ScorBot Toolbox is only supported on 32-bit Windows OS.');
    end
end
%% Check for directories
win32binRoot = fullfile(matlabroot,'bin','win32');
toolboxRoot  = fullfile(matlabroot,'toolbox','scorbot');

isWin32bin = exist(win32binRoot,'file');
if isWin32bin == 7
    %bin\win32 exists as expected
else
    error('MATLAB root does not contain the directory:\n\t"%s"\n',isWin32bin);
end

isToolbox = exist(toolboxRoot,'file');
if isToolbox == 7
    % Apply replaceExisting argument
    if isempty(replaceExisting)
        choice = questdlg(sprintf(...
            ['MATLAB Root already contains the ScorBot Toolbox.\n',...
            'Would you like to replace the existing toolbox?']),...
            'Yes','No');
    elseif replaceExisting
        choice = 'Yes';
    else
        choice = 'No';
    end
    % Replace existing or cancel installation
    switch choice
        case 'Yes'
            if libisloaded('RobotDll')
                unloadlibrary('RobotDll');
            end
            [isRemoved, msg, msgID] = rmdir(toolboxRoot,'s');
            if isRemoved
                fprintf('Previous version of ScorBot Toolbox removed successfully.\n');
            else
                fprintf('Failed to remove old ScorBot Toolbox folder:\n\t"%s"\n',toolboxRoot);
                fprintf(adminSolution);
                error(msgID,msg);
            end
        case 'No'
            fprintf('ScorBot Toolbox currently exists, installation cancelled.\n');
            return
        case 'Cancel'
            fprintf('Action cancelled.');
            return
        otherwise
            error('Unexpected response.');
    end
end

%% Create Scorbot Toolbox Path
[isDir,msg,msgID] = mkdir(toolboxRoot);
if isDir
    fprintf('ScorBot toolbox folder created successfully:\n\t"%s"\n',toolboxRoot);
else
    fprintf('Failed to create Scorbot Toolbox folder:\n\t"%s"\n',toolboxRoot);
    fprintf(adminSolution);
    error(msgID,msg);
end

%% Migrate toolbox folder contents
toolboxContent = 'ScorBotToolboxFunctions';
if ~isdir(toolboxContent)
    error(sprintf(...
        ['Change your working directory to the location of "installScorBotToolbox.m".\n',...
         '\n',...
         'If this problem persists:\n',...
         '\t(1) Unzip your original download of "ScorBotToolbox" into a new directory\n',...
         '\t(2) Open a new instance of MATLAB "as administrator"\n',...
         '\t\t(a) Locate MATLAB shortcut\n',...
         '\t\t(b) Right click\n',...
         '\t\t(c) Select "Run as administrator"\n',...
         '\t(3) Change your "working directory" to the location of "installScorBotToolbox.m"\n',...
         '\t(4) Enter "installScorBotToolbox" (without quotes) into the command window\n',...
         '\t(5) Press Enter.']));
end
files = dir(toolboxContent);
wb = waitbar(0,'Copying ScorBot Toolbox toolbox contents...');
n = numel(files);
fprintf('Copying ScorBot Toolbox contents:\n');
for i = 1:n
    % source file location
    source = fullfile(toolboxContent,files(i).name);
    % destination location
    destination = toolboxRoot;
    if files(i).isdir
        switch files(i).name
            case '.'
                %Ignore
            case '..'
                %Ignore
            otherwise
                fprintf('\t%s...',files(i).name);
                nDestination = fullfile(destination,files(i).name);
                [isDir,msg,msgID] = mkdir(nDestination);
                if isDir
                    [isCopy,msg,msgID] = copyfile(source,nDestination,'f');
                    if isCopy
                        fprintf('[Complete]\n');
                    else
                        bin = msg == char(10);
                        msg(bin) = [];
                        bin = msg == char(13);
                        msg(bin) = [];
                        fprintf('[Failed: "%s"]\n',msg);
                    end
                else
                    bin = msg == char(10);
                    msg(bin) = [];
                    bin = msg == char(13);
                    msg(bin) = [];
                    fprintf('[Failed: "%s"]\n',msg);
                end
        end
    else
        fprintf('\t%s...',files(i).name);
        [isCopy,msg,msgID] = copyfile(source,destination,'f');
        if isCopy
            fprintf('[Complete]\n');
        else
            bin = msg == char(10);
            msg(bin) = [];
            bin = msg == char(13);
            msg(bin) = [];
            fprintf('[Failed: "%s"]\n',msg);
        end
    end
    waitbar(i/n,wb);
end
set(wb,'Visible','off');

%% Save toolbox path
addpath(genpath(toolboxRoot),'-end');
savepath;
    
%% Migrate binary folder contents
win32binContent = 'ScorBotToolboxSupport';
if ~isdir(win32binContent)
    error(sprintf(...
        ['Change your working directory to the location of "installScorBotToolbox.m".\n',...
         '\n',...
         'If this problem persists:\n',...
         '\t(1) Unzip your original download of "ScorBotToolbox" into a new directory\n',...
         '\t(2) Open a new instance of MATLAB "as administrator"\n',...
         '\t\t(a) Locate MATLAB shortcut\n',...
         '\t\t(b) Right click\n',...
         '\t\t(c) Select "Run as administrator"\n',...
         '\t(3) Change your "working directory" to the location of "installScorBotToolbox.m"\n',...
         '\t(4) Enter "installScorBotToolbox" (without quotes) into the command window\n',...
         '\t(5) Press Enter.']));
end
files = dir(win32binContent);
waitbar(0,wb,'Copying win32bin contents...');
set(wb,'Visible','on');
n = numel(files);
fprintf('Copying win32bin contents:\n');
for i = 1:n
    % source file location
    source = fullfile(win32binContent,files(i).name);
    % destination location
    destination = win32binRoot;
    if files(i).isdir
        switch files(i).name
            case '.'
                %Ignore
            case '..'
                %Ignore
            otherwise
                fprintf('\t%s...',files(i).name);
                nDestination = fullfile(destination,files(i).name);
                [isDir,msg,msgID] = mkdir(nDestination);
                if isDir
                    [isCopy,msg,msgID] = copyfile(source,nDestination,'f');
                    if isCopy
                        fprintf('[Complete]\n');
                    else
                        bin = msg == char(10);
                        msg(bin) = [];
                        bin = msg == char(13);
                        msg(bin) = [];
                        fprintf('[Failed: "%s"]\n',msg);
                    end
                else
                    bin = msg == char(10);
                    msg(bin) = [];
                    bin = msg == char(13);
                    msg(bin) = [];
                    fprintf('[Failed: "%s"]\n',msg);
                end
        end
    else
        fprintf('\t%s...',files(i).name);
        [isCopy,msg,msgID] = copyfile(source,destination,'f');
        if isCopy
            fprintf('[Complete]\n');
        else
            bin = msg == char(10);
            msg(bin) = [];
            bin = msg == char(13);
            msg(bin) = [];
            fprintf('[Failed: "%s"]\n',msg);
        end
    end
    waitbar(i/n,wb);
end
close(wb);
drawnow

%% Rehash toolbox cache
fprintf('Rehashing Toolbox Cache...');
rehash TOOLBOXCACHE
fprintf('[Complete]\n');