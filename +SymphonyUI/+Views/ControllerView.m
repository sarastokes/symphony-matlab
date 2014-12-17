classdef ControllerView < SymphonyUI.View
    
    properties        
        menus
        controls
        controller
    end
    
    methods
        
        function obj = ControllerView(controller)
            obj = obj@SymphonyUI.View(SymphonyUI.Presenters.ControllerPresenter());
            
            obj.controller = controller;
            
            % Set initial GUI state.
            obj.onSetExperiment();
            obj.onSetProtocol();
            
            addlistener(controller, 'experiment', 'PostSet', @obj.onSetExperiment);
            addlistener(controller, 'protocol', 'PostSet', @obj.onSetProtocol);
        end
        
        function createInterface(obj)
            clf(obj.figureHandle);
            
            p = obj.presenter;
            
            set(obj.figureHandle, 'Name', 'Symphony');
            set(obj.figureHandle, 'Position', [778 531 292 129]);
            
            obj.menus.file.root = uimenu(obj.figureHandle, ...
                'Label', 'File');
            obj.menus.file.newExperiment = uimenu(obj.menus.file.root, ...
                'Label', 'New Experiment...', ...
                'Callback', @p.onSelectedNewExperiment);
            obj.menus.file.closeExperiment = uimenu(obj.menus.file.root, ...
                'Label', 'Close Experiment', ...
                'Callback', @p.onSelectedCloseExperiment);
            obj.menus.file.exit = uimenu(obj.menus.file.root, ...
                'Label', 'Exit', ...
                'Separator', 'on', ...
                'Callback', @p.onSelectedClose);
            
            obj.menus.experiment.root = uimenu(obj.figureHandle, ...
                'Label', 'Experiment');
            obj.menus.experiment.beginEpochGroup = uimenu(obj.menus.experiment.root, ...
                'Label', 'Begin Epoch Group...', ...
                'Callback', @p.onSelectedBeginEpochGroup);
            obj.menus.experiment.endEpochGroup = uimenu(obj.menus.experiment.root, ...
                'Label', 'End Epoch Group', ...
                'Callback', @p.onSelectedEndEpochGroup);
            obj.menus.experiment.viewNotes = uimenu(obj.menus.experiment.root, ...
                'Label', 'View Notes', ...
                'Separator', 'on', ...
                'Callback', @p.onSelectedViewNotes);
            obj.menus.experiment.addNote = uimenu(obj.menus.experiment.root, ...
                'Label', 'Add Note...', ...
                'Accelerator', 't', ...
                'Callback', @p.onSelectedAddNote);
            obj.menus.experiment.viewRig = uimenu(obj.menus.experiment.root, ...
                'Label', 'View Rig', ...
                'Separator', 'on', ...
                'Callback', @p.onSelectedViewRig);
                        
            obj.menus.protocol.root = uimenu(obj.figureHandle, ...
                'Label', 'Protocol');
            obj.menus.protocol.run = uimenu(obj.menus.protocol.root, ...
                'Label', 'Run', ...
                'Accelerator', 'r', ...
                'Callback', @p.onSelectedRunProtocol);
            obj.menus.protocol.pause = uimenu(obj.menus.protocol.root, ...
                'Label', 'Pause', ...
                'Callback', @p.onSelectedPauseProtocol);
            obj.menus.protocol.stop = uimenu(obj.menus.protocol.root, ...
                'Label', 'Stop', ...
                'Callback', @p.onSelectedStopProtocol);
            obj.menus.protocol.editParameters = uimenu(obj.menus.protocol.root, ...
                'Label', 'Edit...', ...
                'Accelerator', 'e', ...
                'Callback', @p.onSelectedEditProtocol);
            
            obj.menus.modules.root = uimenu(obj.figureHandle, ...
                'Label', 'Modules');
            
            obj.menus.help.root = uimenu(obj.figureHandle, ...
                'Label', 'Help');
            
            mainLayout = uiextras.VBox( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 5);
            
            obj.controls.protocolsPopup = uicontrol( ...
                'Parent', mainLayout, ...
                'Style', 'popupmenu', ...
                'FontSize', 12, ...
                'String', {'Pulse', 'Pulse Family', 'Seal and Leak'}, ...
                'Callback', @p.onSelectedProtocol);
            
            [i, m] = imread('play.png', 'BackgroundColor', 1);
            playIcon = ind2rgb(i, m);
            [i, m] = imread('pause.png', 'BackgroundColor', 1);
            pauseIcon = ind2rgb(i, m);
            [i, m] = imread('stop.png', 'BackgroundColor', 1);
            stopIcon = ind2rgb(i, m);
            [i, m] = imread('menu.png', 'BackgroundColor', 1);
            menuIcon = ind2rgb(i, m);
            
            controlLayout = uiextras.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            uiextras.Empty('Parent', controlLayout);
            obj.controls.runButton = uicontrol( ...
                'Parent', controlLayout, ...        
                'Style', 'pushbutton', ...
                'CData', playIcon, ...
                'BackgroundColor', 'w', ...
                'TooltipString', 'Run', ...
                'Callback', @p.onSelectedRunProtocol);
            obj.controls.pauseButton = uicontrol( ...
                'Parent', controlLayout, ...
                'Style', 'pushbutton', ...
                'CData', pauseIcon, ...
                'BackgroundColor', 'w', ...
                'TooltipString', 'Pause', ...
                'Callback', @p.onSelectedPauseProtocol);
            obj.controls.stopButton = uicontrol( ...
                'Parent', controlLayout, ...
                'Style', 'pushbutton', ...
                'CData', stopIcon, ...
                'BackgroundColor', 'w', ...
                'TooltipString', 'Stop', ...
                'Callback', @p.onSelectedStopProtocol);
            obj.controls.editParametersButton = uicontrol( ...
                'Parent', controlLayout, ...
                'Style', 'pushbutton', ...
                'CData', menuIcon, ...
                'BackgroundColor', 'w', ...
                'TooltipString', 'Protocol Parameters...', ...
                'Callback', @p.onSelectedEditProtocol);
            uiextras.Empty('Parent', controlLayout);
            set(controlLayout, 'Sizes', [-1 45 45 45 45 -1]);
            
            saveLayout = uiextras.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            obj.controls.saveCheckbox = uicontrol( ...
                'Parent', saveLayout, ...
                'Style', 'checkbox', ...
                'String', 'Save');
            
            set(mainLayout, 'Sizes', [33 45 25]);
        end
        
        function p = getProtocol(obj)
            value = get(obj.controls.protocolsPopup, 'Value');
            string = get(obj.controls.protocolsPopup, 'String');
            p = string{value};
        end
        
        function onSetExperiment(obj, ~, ~)
            import SymphonyUI.Utilities.*;
            set(obj.menus.file.newExperiment, 'Enable', onoff(isempty(obj.controller.experiment)));
            set(obj.menus.file.closeExperiment, 'Enable', onoff(~isempty(obj.controller.experiment)));
            set(obj.menus.experiment.root, 'Enable', onoff(~isempty(obj.controller.experiment)));
            
            if ~isempty(obj.controller.experiment)
                obj.onSetEpochGroup();
                addlistener(obj.controller.experiment, 'epochGroup', 'PostSet', @obj.onSetEpochGroup);
            end
        end
        
        function onSetEpochGroup(obj, ~, ~)
            import SymphonyUI.Utilities.*;
            set(obj.menus.experiment.endEpochGroup, 'Enable', onoff(~isempty(obj.controller.experiment.epochGroup)));
        end
        
        function onSetProtocol(obj, ~, ~)
            import SymphonyUI.Utilities.*;
            set(obj.menus.protocol.root, 'Enable', onoff(~isempty(obj.controller.protocol)));
            %set(findall(obj.controls.protocolPanel, '-property', 'Enable'), 'Enable', onoff(~isempty(obj.controller.protocol)));
        end
        
        function onSetProtocolState(obj, ~, ~)
            import SymphonyUI.Models.*;
            disp('Set Protocol State');
            switch obj.controller.protocol.state
                case ProtocolState.STOPPED
                    disp('Stopped');
                case ProtocolState.RUNNING
                    disp('Running');
                otherwise
                    disp('Unknown');
            end
        end
        
    end
    
end

