%% Create simulation
sim = ScorSimInit; % Create wire structure
ScorSimPatch(sim); % Create 3D model

%% Move the simulation to BSEPR = [0,0,0,0,0]
ScorSimSetBSEPR(sim,[0,0,0,0,0]);

%% Move the simulation to BSEPR = [0,pi/2,-pi/2,pi/2,0]
ScorSimSetBSEPR(sim,[0,pi/2,-pi/2,-pi/2,0]);

%% Animate moving Joint 2 from pi/2 to 0 and Joint 3 from -pi/2 to 0
n = 50; % total number of steps between start and finish
theta2 = linspace( pi/2,0,n);
theta3 = linspace(-pi/2,0,n);
for i = 1:n
    ScorSimSetBSEPR(sim,[0,theta2(i),theta3(i),-pi/2,0]);
end

%% Move the simulation home
ScorSimGoHome(sim);