function scorSim = ScorSimInit(varargin)
% SCORSIMINIT initializes a visualization of the ScorBot
%   scorSim = SCORSIMINIT initializes a visualization of the ScorBot in a
%   new figure window, and returns the scorSim structured array.
%       scorSim.Figure - figure handle of ScorBot visualization
%       scorSim.Axes   - axes handle of ScorBot visualization
%       scorSim.Joints - 1x5 array containing joint handles for ScorBot
%           visulization (hgtransform objects, use 
%           set(scorSim.Joints(i),'Matrix',Rz(angle)) to change a specific
%           joint angle)
%       scorSim.Frames - 1x5 array containing reference frame handles for
%           ScorBot (hgtransform objects with triad.m decendants)
%
%   See also ScorSimGoHome ScorSimSetBSEPR ScorSimGetBSEPR ScorSimSetXYZPR
%       ScorSimGetXYZPR etc
%
%   (c) M. Kutzer, 13Aug2015, USNA

% Updates
%   25Sep2015 - Updated to adjust default view angle to match student view
%   03Oct2015 - Updated to include gripper functionality
%   15Oct2015 - Updated to include global for keypress movements
%   20Oct2015 - Updated to include teach indicator
%   23Oct2015 - Updated field of view (xlim)

%% Initialize output
scorSim.Figure = [];
scorSim.Axes   = [];
scorSim.Joints = [];
scorSim.Frames = [];

%% Setup figure
scorSim.Figure = figure;
scorSim.Axes   = axes('Parent',scorSim.Figure);

set(scorSim.Figure,'Name','ScorBot Visualization','MenuBar','none',...
    'NumberTitle','off','ToolBar','Figure');
set(scorSim.Figure,'Units','Normalized','Position',[0.30,0.25,0.40,0.60]);
% Set tag to help confirm validity of global variable
set(scorSim.Figure,'Tag','ScorBot Visualization Figure, Do Not Change');

set(scorSim.Axes,'XLim',[-700,700],'YLim',[-700,700],'ZLim',[-50,1000]);
daspect([1 1 1]);
hold on

xlabel(scorSim.Axes,'x (mm)');
ylabel(scorSim.Axes,'y (mm)');
zlabel(scorSim.Axes,'z (mm)');

%% Create visualization
DHtable = ScorDHtable;
scorSim.Frames = plotDHtable(scorSim.Axes,DHtable,'LinkLabels','Off');
view(scorSim.Axes,[-127,30]);

%% Hide unwanted triad labels
hideTriadLabels(scorSim.Frames);

%% Make intermittent frames
for i = 2:numel(scorSim.Frames)
    scorSim.Joints(i-1) = hgtransform('Parent',scorSim.Frames(i-1));
    set(scorSim.Frames(i),'Parent',scorSim.Joints(i-1));
end

%% Setup gripper
% Finger Base coordinates
n = 4;
v(1,:) = zeros(1,n);
v(2,:) = [44.83, 31.85,-31.85,-44.83];
v(3,:) = repmat(-66.19,1,n);
for i = 1:n
    h(i) = hgtransform('Parent',scorSim.Frames(6),...
        'Matrix',Tx(v(1,i))*Ty(v(2,i))*Tz(v(3,i)),...
        'Tag',sprintf('FingerLinkBaseFrame%d',i));
    g(i) = hgtransform('Parent',h(i),...
        'Tag',sprintf('FingerLinkFrame%d',i));
    f(i) = hgtransform('Parent',g(i),...
        'Matrix',Tz(47.22),...
        'Tag',sprintf('FingerTipBaseFrame%d',i));
    d(i) = hgtransform('Parent',f(i),...
        'Tag',sprintf('FingerTipFrame%d',i));
end

for i = 1:n
    scorSim.Finger(i) = g(i);
end

idx = [1,4];
for i = 1:2
    scorSim.FingerTip(i) = d(idx(i));
end

%% Close gripper
ScorSimSetGripper(scorSim,'Close');

%% Home ScorSim
ScorSimGoHome(scorSim);

%% Set default view
view([(-37.5+180),30]);

%% Set callback function
set(scorSim.Figure,'WindowKeyPressFcn',@ScorSimTeachCallback);

%% Setup Indicator Axes
axs = axes('Parent',scorSim.Figure,'Position',[0.84,0.0,0.16,0.08],...
           'xlim',[0,2],'ylim',[0,1],'Visible','Off');
scorSim.TeachFlag = patch([0,2,2,0,0],[0,0,1,1,0],'w');
set(scorSim.TeachFlag,'FaceColor','w','EdgeColor','k','FaceAlpha',0.5,'Parent',axs);
scorSim.TeachText = text(1,0.5,sprintf('Inactive.'),...
    'VerticalAlignment','Middle',...
    'HorizontalAlignment','Center');
set([scorSim.TeachFlag,scorSim.TeachText],'Visible','off');