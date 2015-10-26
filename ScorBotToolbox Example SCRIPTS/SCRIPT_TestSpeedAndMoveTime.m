%% Initialize and home ScorBot
% Note: You only need to run this once! If you already ran ScorInit and 
% ScorHome, you do not need to run them again.
ScorInit; 
ScorHome;
 
%% Define desired waypoints as end-point XYZPR positions/orientations
XYZPRs(1,:) = [500.000,-200.000,570.000,0.000,-2*pi/2];
XYZPRs(2,:) = [500.000, 200.000,570.000,0.000,-1*pi/2];
XYZPRs(3,:) = [500.000, 200.000,270.000,0.000, 0*pi/2];
XYZPRs(4,:) = [500.000,-200.000,270.000,0.000, 1*pi/2];
XYZPRs(5,:) = [500.000,-200.000,570.000,0.000, 2*pi/2];

%% Convert joint positions to BSEPR
for i = 1:size(XYZPRs,1)
    BSEPRs(i,:) = ScorXYZPR2BSEPR(XYZPRs(i,:));
end

%% Initialize arm configuration
ScorSetSpeed(100);
ScorSetXYZPR(XYZPRs(1,:));
ScorWaitForMove;
 
%% Move through end-point positions (xyzpr)
h = []; % initialize variable for plot handle
fprintf('XYZPR Speed test (with speed reset in loop).\n');
for i = 1:size(XYZPRs,1)
    t = tic;
    ScorSetSpeed(20);
    ScorSetXYZPR(XYZPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (xyzpr)
h = []; % initialize variable for plot handle
fprintf('XYZPR Speed test (without speed reset in loop).\n');
ScorSetSpeed(20);
for i = 1:size(XYZPRs,1)
    t = tic;
    ScorSetXYZPR(XYZPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end


%% Move through end-point positions (bsepr)
h = []; % initialize variable for plot handle
fprintf('BSEPR Speed test (with speed reset in loop).\n');
for i = 1:size(BSEPRs,1)
    t = tic;
    ScorSetSpeed(100);
    ScorSetBSEPR(BSEPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (bsepr)
h = []; % initialize variable for plot handle
fprintf('BSEPR Speed test (without speed reset in loop).\n');
ScorSetSpeed(100);
for i = 1:size(BSEPRs,1)
    t = tic;
    ScorSetBSEPR(BSEPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (xyzpr)
h = []; % initialize variable for plot handle
fprintf('XYZPR Move Time test (with speed reset in loop).\n');
for i = 1:size(XYZPRs,1)
    t = tic;
    ScorSetMoveTime(10);
    ScorSetXYZPR(XYZPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (xyzpr)
h = []; % initialize variable for plot handle
fprintf('XYZPR Move Time test (without speed reset in loop).\n');
ScorSetMoveTime(10);
for i = 1:size(XYZPRs,1)
    t = tic;
    ScorSetXYZPR(XYZPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (bsepr)
h = []; % initialize variable for plot handle
fprintf('BSEPR move time test (with move time reset in loop).\n');
for i = 1:size(BSEPRs,1)
    t = tic;
    ScorSetMoveTime(10);
    ScorSetBSEPR(BSEPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

%% Move through end-point positions (bsepr)
h = []; % initialize variable for plot handle
fprintf('BSEPR Speed test (without move time reset in loop).\n');
ScorSetMoveTime(10);
for i = 1:size(BSEPRs,1)
    t = tic;
    ScorSetBSEPR(BSEPRs(i,:));
    [~,h] = ScorWaitForMove('RobotAnimation','On','PlotHandle',h);
    ScorSetGripper(i);
    [~] = ScorWaitForMove;
    toc(t)
end

