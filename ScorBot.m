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
        function BSEPR = get.BSEPR(obj)
            BSEPR = obj.ScorGetBSEPR;
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = obj.ScorGetXYZPR;
        end
        
        function Pose = get.Pose(obj)
            Pose = obj.ScorGetPose;
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = obj.ScorGetGripper;
        end
        
        function Speed = get.Speed(obj)
            Speed = obj.ScorGetSpeed;
        end
        
        function set.BSEPR(obj, value)
            obj.BSEPR = value;
        end
        
        function set.XYZPR(obj, value)
            obj.XYZPR = value;
        end
        
        function set.Pose(obj, value)
            obj.Pose = value;
        end
        
        function set.Gripper(obj, value)
            obj.Gripper = value;
        end
        
        function set.Speed(obj, value)
            obj.Speed = value;
        end
    end
end