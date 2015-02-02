classdef AppPreferences < handle
    
    properties (SetObservable, AbortSet)
        rigSearchPaths
        protocolSearchPaths
    end
    
    properties (SetAccess = private)
        experimentPreferences
        epochGroupPreferences
    end
    
    methods
        
        function obj = AppPreferences()
            import symphonyui.preferences.*;
            
            obj.experimentPreferences = ExperimentPreferences();
            obj.epochGroupPreferences = EpochGroupPreferences();
        end
        
        function setToDefaults(obj)
            packageDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'Examples', '+io', '+github', '+symphony_das');
            
            obj.rigSearchPaths = { ...
                fullfile(packageDir, '+rigs')};
            obj.protocolSearchPaths = { ...
                fullfile(packageDir, '+protocols')};
            
            obj.experimentPreferences.setToDefaults();
            obj.epochGroupPreferences.setToDefaults();
        end
        
    end
    
end

