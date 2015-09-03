%% Initialize and home ScorBot
% Note: You only need to run this once! If you already ran ScorInit and 
% ScorHome, you do not need to run them again.
ScorInit; 
ScorHome;
 
%% Define joint positions in XYZPR
XYZPRs(1,:) = [500.000,-200.000,570.000,0.000,0.000];
XYZPRs(2,:) = [500.000, 200.000,570.000,0.000,0.000];
XYZPRs(3,:) = [500.000, 200.000,270.000,0.000,0.000];
XYZPRs(4,:) = [500.000,-200.000,270.000,0.000,0.000];
XYZPRs(5,:) = XYZPRs(1,:);

%% Convert joint positions to BSEPR
for i = 1:size(XYZPRs,1)
    BSEPRs(i,:) = ScorXYZPR2BSEPR(XYZPRs(i,:));
end

%% Initialize arm configuration
ScorSetSpeed(100);
ScorSetXYZPR(XYZPRs(1,:));
ScorWaitForMove;
 
%% Move through end-point positions
h = []; % initialize variable for plot handle
fprintf('Demonstrating XYZPR move with Animation Plots.\n');
for i = 1:size(XYZPRs,1)
    ScorSetXYZPR(XYZPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
end
plot3(h.RobotAnimation.Sim.Axes,XYZPRs(1:4,1),XYZPRs(1:4,2),XYZPRs(1:4,3),'*k');
title(h.RobotAnimation.Sim.Axes,'Movements using ScorSetXYZPR');

%% Move through joint positions
h = []; % initialize variable for plot handle
fprintf('Demonstrating BSEPR move with Animation Plots.\n');
for i = 1:size(BSEPRs,1)
    ScorSetBSEPR(BSEPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
end
plot3(h.RobotAnimation.Sim.Axes,XYZPRs(1:4,1),XYZPRs(1:4,2),XYZPRs(1:4,3),'*k');
title(h.RobotAnimation.Sim.Axes,'Movements using ScorSetBSEPR');

%% Safe shutdown
% Note: You only need to run this when you are finished using MATLAB or 
% finished using ScorBot! If you run ScorSafeShutdown and still need to use
% ScorBot, you will need to reinitialize using ScorInit, and rehome using 
% ScorHome.
ScorSafeShutdown;
