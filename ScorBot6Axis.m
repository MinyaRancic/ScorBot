classdef ScorBot6Axis < matlab.mixin.SetGet
    %ScorBot6Axis Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BSEPR
        XYZPR
        Pose
        Simulation
        Gripper
        PrevSpot
        COM
    end

    methods (Access = 'public')
        function obj = ScorBot6Axis(COM)
            obj.COM = COM;
            Scor6AxisSim(obj);
        end
        
        function delete(obj)
            delete(obj);
            clear;
        end
        
        function read(COM)
            out = fscanf(COM,'!T%fP%f,%f,%f,%f,%f,%fV%f,%f,%f,%f,%f,%fS%d,%d,%d,%d,%d,%d',[1,190]);
            T = out(1); % Time stamp
            P = out(2:7); % Axis positions
            V = out(8:13); % Axis velocities
            S = out(14:19); % Axis states
        end
    end
    
    methods
        function getBSEPR(obj)
            ScorSimGetBSEPR(obj);
        end
        
        function getXYZPR(obj)
            ScorSimGetXYZPR(obj);
        end
        
        function getGripper(obj)
            ScorSimGetGripper(obj);
        end
        
        function getPose(obj)
            ScorSimGetPose(obj)
        end
    end
end