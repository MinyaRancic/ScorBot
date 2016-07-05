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
           BSEPR = ScorGetBSEPR;
       end   


    end
end