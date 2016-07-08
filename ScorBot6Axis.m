classdef ScorBot6Axis < matlab.mixin.SetGet
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BSEPR
        XYZPR
        Pose
        Simulation
        Gripper
    end
    
    methods (Access = 'public')
        function obj = ScorBot6Axis(COM)
            Scor6AxisSim(COM);
        end
    end
    
    methods
        function setGripper(value)
            wrapGrip(value);
        end
    end
    
end

