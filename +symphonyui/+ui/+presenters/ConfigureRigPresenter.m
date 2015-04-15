classdef ConfigureRigPresenter < symphonyui.ui.Presenter
    
    properties (Access = private)
        rig
    end
    
    methods
        
        function obj = ConfigureRigPresenter(rig, app, view)
            if nargin < 3
                view = symphonyui.ui.views.ConfigureRigView();
            end
            obj = obj@symphonyui.ui.Presenter(app, view);
            obj.rig = rig;
        end
        
    end
    
    methods (Access = protected)
        
        function onGoing(obj)
            
        end
        
        function onBind(obj)
            v = obj.view;
            obj.addListener(v, 'KeyPress', @obj.onViewKeyPress);
            obj.addListener(v, 'Ok', @obj.onViewSelectedOk);
            obj.addListener(v, 'Cancel', @obj.onViewSelectedCancel);
        end
        
    end
    
    methods (Access = private)
        
        function onViewKeyPress(obj, ~, event)
            switch event.key
                case 'return'
                    obj.onViewSelectedOk();
                case 'escape'
                    obj.onViewSelectedCancel();
            end
        end
        
        function onViewSelectedOk(obj, ~, ~)
            obj.view.update();
            
            try
                obj.rig.initialize();
            catch x
                obj.log.debug(x.message, x);
                obj.view.showError(x.message);
                return;
            end
            
            obj.view.hide();
        end
        
        function onViewSelectedCancel(obj, ~, ~)
            obj.view.hide();
        end
        
    end
    
end

