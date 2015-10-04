%%SCRIPT Basic Hardware Test
fprintf('Testing ScorBot Toolbox hardware tools...');

%% Initialize and home ScorBot hardware
ScorInit;
ScorHome;

%% Define two joint configurations
BSEPR(1,:) = [-pi/8, pi/2,-pi/2,-pi/2, pi/2];
BSEPR(2,:) = [ pi/8, pi/2,-0.10,-pi/2,-pi/2];

%% Test manipulator movements
ScorSetSpeed(100);
for i = 1:size(BSEPR,1)
    ScorSetBSEPR(BSEPR(i,:));
    ScorWaitForMove;
end

%% Return to home configuration
ScorGoHome;
ScorWaitForMove;

%% Test gripper
ScorSetGripper('Open');
ScorWaitForMove;
ScorSetGripper('Close');
ScorWaitForMove

%% Safe shutdown
ScorSafeShutdown;

%% End test
fprintf('[Complete]\n');