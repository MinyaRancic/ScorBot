classdef ScorBot < matlab.mixin.SetGet
    properties(GetAccess = 'public', SetAccess = 'public')
        BSEPR;       %Joint angles
        XYZPR;       %Task Space
        Pose;        %Task Space (SE3)
        Gripper;
        Speed;
    end
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
        end
        
        function delete(obj)
            ScorSafeShutdown;
        end            
    end
    
    methods
        function BSEPR = ScorGetBSEPR(obj)
            BSEPR = obj.ScorGetBSEPR;
        end
        
        function XYZPR = ScorGetXYZPR(obj)
            XYZPR = obj.ScorGetXYZPR;
        end
        
        function Pose = ScorGetPose(obj)
            Pose = obj.ScorGetPose;
        end
        
        function Gripper = ScorGetGripper(obj)
            Gripper = obj.ScorGetGripper;
        end
        
        function Speed = ScorGetSpeed(obj)
            Speed = obj.ScorGetSpeed;
        end
    end
end