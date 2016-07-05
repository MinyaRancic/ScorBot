classdef ScorBot
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
        end
      
    methods(Access = 'public')
        function delete obj
            ScorSafeShutdown;
        end
          
end
