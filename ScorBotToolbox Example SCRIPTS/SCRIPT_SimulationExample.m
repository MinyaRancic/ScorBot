%% Initialize simulation and visualize ScorBot
% Note: Each time you run this, you will create a new simulation figure
simObj = ScorSimInit;
ScorSimPatch(simObj);

%% Define desired waypoints as end-point XYZPR positions/orientations
XYZPRs(1,:) = [500.000,-200.000,570.000,0.000,-2*pi/2];
XYZPRs(2,:) = [500.000, 200.000,570.000,0.000,-1*pi/2];
XYZPRs(3,:) = [500.000, 200.000,270.000,0.000, 0*pi/2];
XYZPRs(4,:) = [500.000,-200.000,270.000,0.000, 1*pi/2];
XYZPRs(5,:) = [500.000,-200.000,570.000,0.000, 2*pi/2];

%% Convert XYZPR waypoints to BSEPR joint configurations
for wpnt = 1:size(XYZPRs,1)
    ScorXYZPR2BSEPR(XYZPRs(wpnt,:))
    BSEPRs(wpnt,:) = ScorXYZPR2BSEPR(XYZPRs(wpnt,:));
end

%% Interpolate between waypoints for animation
n = 50;
XYZPR_all = [];
BSEPR_all = [];
for jnt = 1:size(XYZPRs,2)
    for wpnt = 1:size(XYZPRs,1)-1
        XYZPR_all(n*(wpnt-1)+1:n*(wpnt-1)+n,jnt) = ...
            linspace(XYZPRs(wpnt,jnt),XYZPRs(wpnt+1,jnt),n);
        BSEPR_all(n*(wpnt-1)+1:n*(wpnt-1)+n,jnt) = ...
            linspace(BSEPRs(wpnt,jnt),BSEPRs(wpnt+1,jnt),n);
    end
end
 
%% Move through end-point XYZPR positions/orientations
plt = plot3(simObj.Axes,0,0,0,'.m'); % initialize waypoint plot handle
clear xData yData zData
fprintf('Demonstrating simulated XYZPR move.\n');
title(simObj.Axes,'Movements using ScorSimSetXYZPR (Magenta)');
for ipnt = 1:size(XYZPR_all,1)
    ScorSimSetXYZPR(simObj,XYZPR_all(ipnt,:));
    XYZPR = ScorSimGetXYZPR(simObj);
    xData(ipnt) = XYZPR(1);
    yData(ipnt) = XYZPR(2);
    zData(ipnt) = XYZPR(3);
    set(plt,'xData',xData,'yData',yData,'zData',zData);
end
plot3(simObj.Axes,XYZPRs(1:4,1),XYZPRs(1:4,2),XYZPRs(1:4,3),'ok');

%% Open Gripper
for grip = 0:0.5:70
    ScorSimSetGripper(simObj,grip);
end

%% Move through BSEPR joint configurations
plt = plot3(simObj.Axes,0,0,0,'.c'); % initialize waypoint plot handle
clear xData yData zData
fprintf('Demonstrating simulated BSEPR move.\n');
title(simObj.Axes,'Movements using ScorSimSetBSEPR (Cyan)');
for ipnt = 1:size(BSEPR_all,1)
    ScorSimSetBSEPR(simObj,BSEPR_all(ipnt,:));
    XYZPR = ScorSimGetXYZPR(simObj);
    xData(ipnt) = XYZPR(1);
    yData(ipnt) = XYZPR(2);
    zData(ipnt) = XYZPR(3);
    set(plt,'xData',xData,'yData',yData,'zData',zData);
end
plot3(simObj.Axes,XYZPRs(1:4,1),XYZPRs(1:4,2),XYZPRs(1:4,3),'+k');

%% Close Gripper
for grip = 70:-0.5:0
    ScorSimSetGripper(simObj,grip);
end