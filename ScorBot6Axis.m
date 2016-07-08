classdef ScorBot6Axis < matlab.mixin.SetGet
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BSEPR
        XYZPR
        Pose
        Simulation
        Gripper
        PrevSpot
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
    
    methods
        function BSEPR = getBSEPR(obj) %Returns BSEPR
            BSEPR = ScorSimGetBSEPR(obj.Simulation);
        end
        
        function XYZPR = getXYZPR(obj) %Returns XYZPR
            XYZPR = ScorSimGetXYZPR(obj.Simulation);
        end
        
        function Pose = getPose(obj) %Returns Pose
            Pose = ScorSimGetPose(obj.Simulation);
        end
        
        function Gripper = getGripper(obj) %Returns Gripper
            Gripper = ScorSimGetGripper(obj.Simulation);
        end
        
        function setBSEPR(obj, value) %Sets BSEPR to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = obj.BSEPR;
            obj.BSEPR = value;
            ScorSimSetBSEPR(obj.Simulation, value);
            obj.XYZPR = ScorBSEPR2XYZPR(obj.BSEPR);
            obj.Pose = ScorBSEPR2Pose(obj.BSEPR);
        end
        
        function setXYZPR(obj, value) %Sets XYZPR to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.XYZPR = value;
            ScorSimSetXYZPR(obj.Simulation, value);
            obj.BSEPR = ScorXYZPR2BSEPR(obj.XYZPR);
            obj.Pose = ScorXYZPR2Pose(obj.XYZPR);
        end
        
        function setPose(obj, value) %Sets Pose to value and sets
            %             PrevSpot to most recent BSEPR
            obj.PrevSpot = ScorPose2BSEPR(obj.Pose);
            obj.Pose = value;
            ScorSimSetPose(obj.Simulation, value);
            obj.BSEPR = ScorPose2BSEPR(obj.Pose);
            obj.XYZPR = ScorPose2XYZPR(obj.Pose);
        end
    end
end