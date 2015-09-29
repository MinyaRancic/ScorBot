function ScorUpdate
% SCORUPDATE download an update the ScorBot Toolbox. 
%
%   (c) M. Kutzer 26Aug2015, USNA

% Updates
%   27Aug2015 - Updated to include check for multiple the newest update on
%               MATLAB Central (currently looks 25 versions ahead).
%   03Sep2015 - Updated to download from GitHub

% TODO - Find a location for "ScorBotToolbox Example SCRIPTS"
% TODO - update function for general operation

%% Check current version
A = ScorVer;

%% Setup temporary file directory
fprintf('Downloading the ScorBot Toolbox...');
tmpFolder = 'ScorBotToolbox';
pname = fullfile(tempdir,tmpFolder);

%% Download and unzip toolbox (GitHub)
url = 'https://github.com/kutzer/ScorBotToolbox/archive/master.zip';
try
    fnames = unzip(url,pname);
    fprintf('SUCCESS\n');
    confirm = true;
catch
    confirm = false;
    return
end

%% Check for successful download
if ~confirm
    error('Failed to download updated version of ScorBot Toolbox.');
end

%% Find base directory
install_pos = strfind(fnames,'installScorBotToolbox.m');
sIdx = cell2mat( install_pos );
cIdx = ~cell2mat( cellfun(@isempty,install_pos,'UniformOutput',0) );

pname_star = fnames{cIdx}(1:sIdx-1);

%% Get current directory and temporarily change path
cpath = cd;
cd(pname_star);

%% Install ScorBot Toolbox
installScorBotToolbox(true);

%% Test ScorBot functionality
if ispc
    switch computer
        case 'PCWIN'
            SCRIPT_Basic_Test
    end
end

%% Move back to current directory and remove temp file
cd(cpath);
[ok,msg] = rmdir(pname,'s');
if ~ok
    warning('Unable to remove temporary download folder. %s',msg);
end

%% Test simulation functionality
sim = ScorSimInit;
ScorSimPatch(sim);
lims = ScorBSEPRLimits;
for i = 1:5
    theta{i} = linspace(lims(i,1),lims(i,2),100);
end

for i = 1:5
    BSEPR = [0,pi/2,-pi/2,0,0];
    for j = 1:numel(theta{i})
        BSEPR(i) = theta{i}(j);
        ScorSimSetBSEPR(sim,BSEPR);
        drawnow;
    end
end

end
