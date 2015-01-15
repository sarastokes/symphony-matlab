classdef NewExperimentView < SymphonyUI.View
    
    events
        BrowseLocation
        Open
        Cancel
    end
    
    properties (Access = private)
        nameEdit
        locationEdit
        browseLocationButton
        rigPopup
        purposeEdit
        openButton
        cancelButton
    end
    
    methods
        
        function obj = NewExperimentView(parent)
            obj = obj@SymphonyUI.View(parent);
        end
        
        function createUI(obj)
            import SymphonyUI.Utilities.*;
            
            set(obj.figureHandle, 'Name', 'New Experiment');
            set(obj.figureHandle, 'Position', screenCenter(518, 276));
            
            mainLayout = uiextras.VBox( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 7);
            
            parametersLayout = uiextras.VBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            
            % Name input.
            layout = uiextras.HBox( ...
                'Parent', parametersLayout, ...
                'Spacing', 7);
            uiLabel(layout, 'Name:');
            obj.nameEdit = uicontrol( ...
                'Parent', layout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            uiextras.Empty('Parent', layout);
            set(layout, 'Sizes', [60 -1 75]);
            
            % Location input.
            layout = uiextras.HBox( ...
                'Parent', parametersLayout, ...
                'Spacing', 7);
            uiLabel(layout, 'Location:');
            obj.locationEdit = uicontrol( ...
                'Parent', layout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            obj.browseLocationButton = uicontrol( ...
                'Parent', layout, ...
                'Style', 'pushbutton', ...
                'String', 'Browse...', ...
                'Callback', @(h,d)notify(obj, 'BrowseLocation'));
            set(layout, 'Sizes', [60 -1 75]);
            
            % Rig input.
            layout = uiextras.HBox( ...
                'Parent', parametersLayout, ...
                'Spacing', 7);
            uiLabel(layout, 'Rig:');
            obj.rigPopup = uicontrol( ...
                'Parent', layout, ...
                'Style', 'popupmenu', ...
                'String', {' '}, ...
                'HorizontalAlignment', 'left');
            uiextras.Empty('Parent', layout);
            set(layout, 'Sizes', [60 -1 75]);
            
            % Purpose input.
            layout = uiextras.HBox( ...
                'Parent', parametersLayout, ...
                'Spacing', 7);
            uiLabel(layout, 'Purpose:');
            obj.purposeEdit = uicontrol( ...
                'Parent', layout, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left');
            uiextras.Empty('Parent', layout);
            set(layout, 'Sizes', [60 -1 75]);
            
            % Source input.
            layout = uiextras.HBox( ...
                'Parent', parametersLayout, ...
                'Spacing', 7);
            sourcePanel = uix.Panel( ...
                'Parent', layout, ...
                'Title', 'Source', ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'));
            
            set(parametersLayout, 'Sizes', [25 25 25 25 -1]);
            
            % Open/Cancel controls.
            controlLayout = uiextras.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            uiextras.Empty('Parent', controlLayout);
            obj.openButton = uicontrol( ...
                'Parent', controlLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Open', ...
                'Callback', @(h,d)notify(obj, 'Open'));
            obj.cancelButton = uicontrol( ...
                'Parent', controlLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Cancel', ...
                'Callback', @(h,d)notify(obj, 'Cancel'));
            set(controlLayout, 'Sizes', [-1 75 75]);
            
            set(mainLayout, 'Sizes', [-1 25]);       
            
            % Set open button to appear as the default button.
            try %#ok<TRYNC>
                h = handle(obj.figureHandle);
                h.setDefaultButton(obj.openButton);
            end
        end
        
        function n = getName(obj)
            n = get(obj.nameEdit, 'String');
        end
        
        function setName(obj, n)
            set(obj.nameEdit, 'String', n);
        end
        
        function l = getLocation(obj)
            l = get(obj.locationEdit, 'String');
        end
        
        function setLocation(obj, l)
            set(obj.locationEdit, 'String', l);
        end
        
        function r = getRig(obj)
            r = SymphonyUI.Utilities.getSelectedUIValue(obj.rigPopup);
        end
        
        function p = getPurpose(obj)
            p = get(obj.purposeEdit, 'String');
        end
        
        function setPurpose(obj, p)
            set(obj.purposeEdit, 'String', p);
        end
        
    end
    
end

