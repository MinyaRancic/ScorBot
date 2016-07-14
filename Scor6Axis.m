classdef Scor6Axis
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Simulation
        BSEPR
        prevSpot
    end
    
    methods(Access = 'public')
        function obj = Scor6Axis(COM)
            Scor6AxisSim(COM);
        end
        
        function ScorRead(COM, time)
            Scor6AxisReadSerial(COM, time);
        end
        
        function ScorWrite(COM)
            Scor6AxisWrite(COM);
        end
    end
    
end