classdef App < handle

    methods (Static)
        
        function n = name()
            n = 'Symphony';
        end
        
        function d = description()
            d = 'Data Acquisition System';
        end

        function v = version()
            v = '2.6.3.0'; % i.e. 2.6-r
        end
        
        function o = owner()
            o = 'Symphony-DAS';
        end
        
        function r = repo()
            r = 'symphony-matlab';
        end

        function u = documentationUrl()
            u = symphonyui.app.App.getResource('docs', 'README.html');
        end

        function u = userGroupUrl()
            u = 'https://groups.google.com/forum/#!forum/symphony-das';
        end

        function p = getResource(varargin)
            resourcesPath = fullfile(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))), 'resource');
            p = fullfile(resourcesPath, varargin{:});
        end

    end

end
