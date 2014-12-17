classdef View < handle
    
    properties
        figureHandle
        presenter
    end
    
    methods
        
        function obj = View(presenter)
            obj.presenter = presenter;
            obj.presenter.view = obj;
            
            obj.figureHandle = figure( ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'Toolbar', 'none', ...
                'HandleVisibility', 'off', ...
                'Visible', 'off', ...
                'DefaultUicontrolFontName', 'Segoe UI', ...
                'DefaultUicontrolFontSize', 9, ...
                'DockControls', 'off', ...
                'CloseRequestFcn', @presenter.onSelectedClose);
            
            obj.createInterface();
            
%             % Restore figure position.
%             pref = [strrep(class(obj), '.', '_') '_Position'];
%             if ispref('SymphonyUI', pref)
%                 set(obj.figureHandle, 'Position', getpref('SymphonyUI', pref));
%             end
        end
        
        function show(obj)
            figure(obj.figureHandle);
        end
        
        function hide(obj)
            set(obj.figureHandle, 'Visible', 'off');
        end
        
        function close(obj)
%             % Save figure position.
%             pref = [strrep(class(obj), '.', '_') '_Position'];
%             setpref('SymphonyUI', pref, get(obj.figureHandle, 'Position'));
            
            delete(obj.figureHandle);
        end
        
    end
    
    methods (Abstract)
        createInterface(obj);
    end
    
end

