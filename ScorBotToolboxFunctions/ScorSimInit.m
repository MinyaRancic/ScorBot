function scorSim = ScorSimInit()
% SCORSIMINIT initializes a visualization of the ScorBot
%   scorSim = ScorSimInit initializes a visualization of the ScorBot in a
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

set(scorSim.Axes,'XLim',[-200,700],'YLim',[-700,700],'ZLim',[-50,1000]);
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

%% Home ScorSim
ScorSimGoHome(scorSim);