%%SCRIPT Basic Example

%% Initialize and home ScorBot
ScorInit;
ScorHome;

%% Define two joint positions
BSEPR(1,:) = [0,pi/2,-pi/2,-pi/2,0];
BSEPR(2,:) = [0,pi/2,-0.10,-pi/2,0];

%% Initialize arm configuration
ScorSetSpeed(100);
ScorSetBSEPR(BSEPR(2,:));
ScorWaitForMove;

%% Evaluate various speeds
for PercentSpeed = 10:10:100
    tic;
    ScorSetSpeed(PercentSpeed);
    fprintf('Moving at %d%% of max speed.\n',PercentSpeed);
    for i = 1:size(BSEPR,1)
        ScorSetBSEPR(BSEPR(i,:));
        ScorWaitForMove;
    end
    toc
end

%% Wait with all plots
h = []; % initialize variable for plot handle
fprintf('Demonstrating XYZPR, BSEPR, and Animation Plots.\n');
for i = 1:size(BSEPR,1)
    ScorSetBSEPR(BSEPR(i,:));
    [~,h] = ScorWaitForMove(...
        'XYZPRPlot','On',...
        'BSEPRPlot','On',...
        'RobotAnimation','On',...
        'PlotHandle',h);
    pause(1);
end

%% Safe shutdown
ScorSafeShutdown;