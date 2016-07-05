classdef ScorBot < matlab.mixin.SetGet
    properties(GetAccess = 'public', SetAccess = 'public')
        BSEPR = ScorGetBSEPR;       %Joint angles
        XYZPR = ScorGetXYZPR;       %Task Space
        Pose = ScorGetPose;        %Task Space (SE3)
        Gripper = ScorGetGripper;
        Speed = ScorGetSpeed;

    end
    methods(Access = 'public')
        function obj = ScorBot
            obj = ScorInit;
            ScorHome;
        end
        
        function delete(obj)
            ScorSafeShutdown;
        end            
    end
    
    methods
       function BSEPR = get.BSEPR(obj)
           BSEPR = ScorGetBSEPR(obj);
       end   


    end
end