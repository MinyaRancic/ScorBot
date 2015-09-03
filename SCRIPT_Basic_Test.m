%%SCRIPT Basic Example
ScorVer;

%% Initialize and home ScorBot
ScorInit;
ScorHome;

%% Define two joint positions
BSEPR(1,:) = [0,pi/2,-pi/2,-pi/2,0];
BSEPR(2,:) = [0,pi/2,-0.10,-pi/2,0];

%% Initialize arm configuration
ScorSetSpeed(100);
ScorSetBSEPR(BSEPR(1,:));
ScorWaitForMove;
ScorSetBSEPR(BSEPR(2,:));
ScorWaitForMove;
ScorGoHome;
ScorWaitForMove;

%% Safe shutdown
ScorSafeShutdown;