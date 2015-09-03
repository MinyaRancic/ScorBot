function ScorUpdate
% SCORUPDATE download an update the ScorBot Toolbox. 
%
%   (c) M. Kutzer 26Aug2015, USNA

% Updates
%   27Aug2015 - Updated to include check for multiple the newest update on
%               MATLAB Central (currently looks 25 versions ahead).

% TODO - Find a location for "ScorBotToolbox Example SCRIPTS"
% TODO - update function for general operation

%% Check current version
A = ScorVer;

%% Setup temporary file directory
fprintf('Downloading the ScorBot Toolbox...');
pname = fullfile(tempdir,'ScorBotToolbox');

%% Download and unzip toolbox
% % This cell is specific to the MATLAB central versioning
% ver_offset = 25; % check for 25 updates ahead of current version
% i0 = A.URLVer;
% iN = A.URLVer + ver_offset;
% for i = iN:-1:i0
%     url = sprintf('http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/52684/versions/%d/download/zip',i);
%     try
%         fnames = unzip(url,pname);
%         fprintf('Update %d Downloaded\n',i);
%         confirm = true;
%     catch
%         % Ignore bad version
%         confirm = false;
%     end
% end

%% Download directly from USNA site
% url = 'https://www.usna.edu/Users/weapsys/kutzer/matlab/ScorBotToolbox.zip';
% [pathname,filename] = downloadFile(url);
% fnames = unzip(fullfile(pathname,filename),pname);
% % try
% %     fnames = unzip(url,pname);
% %     fprintf('SUCCESS\n');
% %     confirm = true;
% % catch
% %     confirm = false;
% % end

%% Download from network drive
url = 'W:\Mid_Lib\ES450\ScorBotToolbox.zip';
try
    fnames = unzip(url,pname);
    fprintf('SUCCESS\n');
    confirm = true;
catch
    fprintf('FAILED\n');
    confirm = false;
end

%% Check for successful download
if ~confirm
    error('Failed to download updated version of ScorBot Toolbox.');
end

%% Get current directory and temporarily change path
cpath = cd;
cd(pname);

%% Install ScorBot Toolbox
installScorBotToolbox(true);

%% Test functionality
SCRIPT_Basic_Test

%% Move back to current directory and remove temp file
cd(cpath);
[ok,msg] = rmdir(pname,'s');
if ~ok
    warning('Unable to remove temporary download folder. %s',msg);
end

end

%% Internal function
function [pathname,filename] = downloadFile(url)
% Based on:
%   Subject: Download a File from the internet
%   From: Kirill
%   Date: 12 Nov, 2010 18:04:44
%   Message: 2 of 2

pathname = tempdir;

%% create local file
[~,name,ext] = fileparts(url);
filename = [name,ext];
fname = fullfile(pathname,filename);

fprintf('Downloading: "%s"...',filename);

%% open local file
fh = fopen(fname, 'wb');

if fh == -1
    msg = 'Unable to open file %s';
    msg = sprintf(msg, fname);
    error(msg);
end

% open remote file via Java net.URL class
jurl = java.net.URL(url);
is = jurl.openStream;
b = 0;
iter = 0;
while true
    b = is.read;
    if b == -1
        % end-of-file
        break
    end
    fwrite(fh, b, 'uint8'); %!!! doesn't work with 'char';
    if mod(iter,4) == 0
        fprintf(char([8,8,8]));
    else
        fprintf('.');
    end
    iter = iter+1;
end
is.close; % close java stream
fprintf( char(repmat(8,1,mod(iter,4))) );
fprintf('...');
fprintf('SUCCESS\n');

fh = fclose(fh);
if fh == -1
    msg = 'Unable to close file %s';
    msg = sprintf(msg, fname);
    error(msg);
end

disp('Done')
end