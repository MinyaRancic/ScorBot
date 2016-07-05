classdef ScorBot < matlab.mixin.SetGet
    properties(GetAccess = 'public', SetAccess = 'public')
        MoveTime;
        MoveType;
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
            ScorSetBSEPR(value, 'MoveType', obj.MoveType);
        end
        
        function set.XYZPR(obj, value)
            obj.XYZPR = value;
            ScorSetXYZPR(value, 'MoveType', obj.MoveType);
        end
        
        function set.Pose(obj, value)
            obj.Pose = value;
            ScorSetPose(value);
        end
        
        function set.Gripper(obj, value)
            obj.Gripper = value;
            ScorSetGripper(value);
        end
        
        function set.Speed(obj, value)
            obj.Speed = value;
            ScorSetSpeed(value);
        end
        
        function set.MoveTime(obj, value)
            obj.MoveTime = value;
            ScorSetMoveTime(value);
        end
        
        function set.MoveType(obj, value)
            switch(value)
                case 'LinearJoint'
                    obj.MoveType = 'LinearJoint';
                case 'LinearTask'
                    obj.MoveType = 'LinearTask';
                otherwise
                    error('Move Type must be LinearTask or LinearJoint');
                    
            end
        end
        
    end
end