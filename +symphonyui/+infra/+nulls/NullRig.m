classdef NullRig < symphonyui.core.Rig

    methods

        function setup(obj) %#ok<MANU>

        end

        function [tf, msg] = isValid(obj) %#ok<MANU>
            tf = false;
            msg = 'Empty rig';
        end

    end

end
