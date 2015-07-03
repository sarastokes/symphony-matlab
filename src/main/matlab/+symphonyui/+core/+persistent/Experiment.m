classdef Experiment < symphonyui.core.persistent.TimelineEntity
    
    properties (SetAccess = private)
        purpose
        devices
        sources
        epochGroups
    end
    
    methods
        
        function obj = Experiment(cobj)
            obj@symphonyui.core.persistent.TimelineEntity(cobj);
        end
        
        function p = get.purpose(obj)
            p = char(obj.cobj.Purpose);
        end
        
        function d = get.devices(obj)
            d = obj.cellArrayFromEnumerable(obj.cobj.Devices, @symphonyui.core.persistent.Device);
        end
        
        function s = get.sources(obj)
            s = obj.cellArrayFromEnumerable(obj.cobj.Sources, @symphonyui.core.persistent.Source);
        end
        
        function g = get.epochGroups(obj)
            g = obj.cellArrayFromEnumerable(obj.cobj.EpochGroups, @symphonyui.core.persistent.EpochGroup);
        end
        
    end
    
end
