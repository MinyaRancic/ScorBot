function Scor6AxisExampleFunction(COM)

%% Initialize simulation and visualize Scor6Axis
% Note - You will need 2 COM ports available and another instance of Matlab
% running Scor6AxisSim(COM)

obj = Scor6Axis(COM);
Scor6AxisInfo(obj);

%% Set and send random joint position data points to the simulation

Scor6AxisSetPos(obj, rand(100, 6));
writePos(obj);
pause(2);
Scor6AxisInfo(obj);

%% Set and send random joint velocity data points to the simulation

Scor6AxisSetVel(obj, rand(100, 6));
Scor6AxisSetDt(obj, .1);
writeVel(obj);
Scor6AxisInfo(obj);
end