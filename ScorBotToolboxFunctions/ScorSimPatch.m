function ScorSimPatch(scorSim,varargin)
% SCORSIMPATCH creates a patch object a visualization of the ScorBot
%   SCORSIMPATCH(scorSim) 
%
%   (c) M. Kutzer & M. Vetere, 25Sep2015, USNA

% Updates
%   29Sep2015 - Updated to correct link 5 parent/child relationship
%   01Oct2015 - Updated to include error checking

% TODO - finish documentation
% TODO - include moving gripper

%% Error checking
if nargin < 1
    error('The simulation object must be specified. Use "ScorSimPatch(scorSim)".')
end

%% Parse inputs
% TODO - use varargin to specify simple/complex and coarse/fine
complexity = 'Simple';
resolution = 'Coarse';

%% Setup file names
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

%% Load files
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
        
%% Add light
addSingleLight(scorSim.Axes);
        