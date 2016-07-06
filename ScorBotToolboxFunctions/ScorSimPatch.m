function ScorSimPatch(varargin)
% SCORSIMPATCH creates a patch object a visualization of the ScorBot
%   SCORSIMPATCH(scorSim) creates a patch object a visualization of the 
%   ScorBot.
%
%   See also ScorSimInit ScorSimTeachXYZPR ScorSimTeachBSEPR
%
%   (c) M. Kutzer & M. Vetere, 25Sep2015, USNA

% Updates
%   29Sep2015 - Updated to correct link 5 parent/child relationship
%   01Oct2015 - Updated to include error checking
%   03Oct2015 - Updated to include gripper functionality
%   16Oct2015 - Update to documentation
%   23Oct2015 - Updates to status indicator
%   30Dec2015 - Updates see also
%   30Dec2015 - Updated error checking

% TODO - finish documentation

%% Check inputs
% Check for zero inputs
if nargin < 1
    error('ScorSim:NoSimObj',...
        ['A valid ScorSim object must be specified.',...
        '\n\t-> Use "scorSim = ScorSimInit;" to create a ScorSim object',...
        '\n\t-> and "%s(scorSim);" to execute this function.'],mfilename)
end
% Check scorSim
if nargin >= 1
    scorSim = varargin{1};
    if ~isScorSim(scorSim)
        if isempty(inputname(1))
            txt = 'The specified input';
        else
            txt = sprintf('"%s"',inputname(1));
        end
        error('ScorSet:BadSimObj',...
            ['%s is not a valid ScorSim object.',...
            '\n\t-> Use "scorSim = ScorSimInit;" to create a ScorSim object',...
            '\n\t-> and "%s(scorSim);" to execute this function.'],txt,mfilename);
    end
end
% Check for too many inputs
% TODO - use varargin to specify simple/complex and coarse/fine
if nargin > 1
    warning('Too many inputs specified. Ignoring additional parameters.');
end

%% Check scorSim
if ~ishandle(scorSim.Figure)
    error('Invalid simulation object. Run "ScorSimInit" to create a valid simulation object.');
else
    set(scorSim.TeachFlag,'FaceColor','r');
    set(scorSim.TeachText,'String',sprintf('Adding patch\ndata...'));
    set([scorSim.TeachFlag,scorSim.TeachText],'Visible','on');
end

%% Parse inputs
% TODO - use varargin to specify simple/complex and coarse/fine
complexity = 'Simple';
resolution = 'Coarse';

%% Setup file names for links
fname = 'ScorLink%d';
switch lower(complexity)
    case 'simple'
        mname{1} = '';
    case 'complex'
        mname{1} = 'Black';
        mname{2} = 'Blue';
        mname{3} = 'Gold';
    otherwise
        error('Unspecified complexity');
end

switch lower(resolution)
    case 'coarse'
        lname = '_Coarse.fig';
    case 'fine'
        lname = '_Fine.fig';
    otherwise
        error('Unspecified resolution.');
end

%% Load link files
for i = 0:5
    for j = 1:numel(mname)
        filename = sprintf(sprintf('%s%s%s',fname,mname{j},lname),i);
        open(filename);
        fig = gcf;
        set(fig,'Visible','off');
        % TODO - Add error checking
        axs = get(fig,'Children');
        body = get(axs,'Children');
        
        set(body,'Parent',scorSim.Frames(i+1));
        close(fig);
    end
end

%% Load finger files
for i = 1:4
    filename = sprintf('%s%s','ScorFinger',lname);
    open(filename);
    fig = gcf;
    set(fig,'Visible','off');
    % TODO - Add error checking
    axs = get(fig,'Children');
    body = get(axs,'Children');
    
    set(body,'Parent',scorSim.Finger(i));
    close(fig);
end

%% Load fingertip files
tname = 'ScorFingerTip';
for i = 1:2
    filename = sprintf('%s%d%s',tname,i,lname);
    open(filename);
    fig = gcf;
    set(fig,'Visible','off');
    % TODO - Add error checking
    axs = get(fig,'Children');
    body = get(axs,'Children');
    
    set(body,'Parent',scorSim.FingerTip(i));
    close(fig);
end

%% Add light
addSingleLight(scorSim.Axes);

%% Update status
set(scorSim.TeachFlag,'FaceColor','w');
set(scorSim.TeachText,'String',sprintf('Inactive.'));
set([scorSim.TeachFlag,scorSim.TeachText],'Visible','off');
drawnow