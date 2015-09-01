classdef DataManagerView < symphonyui.ui.View

    events
        AddSource
        BeginEpochGroup
        EndEpochGroup
        SelectedNodes
        SetSourceLabel
        SetExperimentPurpose
        SetEpochGroupLabel
        SelectedEpochSignal
        SelectedPropertiesPreset
        SetProperty
        AddProperty
        RemoveProperty
        AddKeyword
        RemoveKeyword
        AddNote
        SendEntityToWorkspace
        DeleteEntity
        Refresh
        OpenAxesInNewWindow
    end

    properties (Access = private)
        addSourceButtons
        beginEpochGroupButtons
        endEpochGroupButtons
        refreshButtons
        entityTree
        sourcesFolderNode
        epochGroupsFolderNode
        detailCardPanel
        emptyCard
        sourceCard
        experimentCard
        epochGroupCard
        epochBlockCard
        epochCard
        tabGroup
        propertiesTab
        keywordsTab
        notesTab
        parametersTab
    end

    properties (Constant)
        EMPTY_CARD         = 1
        SOURCE_CARD        = 2
        EXPERIMENT_CARD    = 3
        EPOCH_GROUP_CARD   = 4
        EPOCH_BLOCK_CARD   = 5
        EPOCH_CARD         = 6
    end

    methods

        function createUi(obj)
            import symphonyui.ui.util.*;
            import symphonyui.ui.views.EntityNodeType;

            set(obj.figureHandle, ...
                'Name', 'Data Manager', ...
                'Position', screenCenter(611, 550));

            % Toolbar.
            toolbar = uitoolbar( ...
                'Parent', obj.figureHandle);
            obj.addSourceButtons.tool = uipushtool( ...
                'Parent', toolbar, ...
                'TooltipString', 'Add Source...', ...
                'ClickedCallback', @(h,d)notify(obj, 'AddSource'));
            setIconImage(obj.addSourceButtons.tool, symphonyui.app.App.getResource('icons/source_add.png'));
            obj.beginEpochGroupButtons.tool = uipushtool( ...
                'Parent', toolbar, ...
                'TooltipString', 'Begin Epoch Group...', ...
                'Separator', 'on', ...
                'ClickedCallback', @(h,d)notify(obj, 'BeginEpochGroup'));
            setIconImage(obj.beginEpochGroupButtons.tool, symphonyui.app.App.getResource('icons/group_begin.png'));
            obj.endEpochGroupButtons.tool = uipushtool( ...
                'Parent', toolbar, ...
                'TooltipString', 'End Epoch Group', ...
                'ClickedCallback', @(h,d)notify(obj, 'EndEpochGroup'));
            setIconImage(obj.endEpochGroupButtons.tool, symphonyui.app.App.getResource('icons/group_end.png'));

            mainLayout = uix.HBoxFlex( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 7);

            masterLayout = uix.VBox( ...
                'Parent', mainLayout);

            obj.entityTree = uiextras.jTree.Tree( ...
                'Parent', masterLayout, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'), ...
                'SelectionChangeFcn', @(h,d)notify(obj, 'SelectedNodes'), ...
                'SelectionType', 'discontiguous');

            treeMenu = uicontextmenu('Parent', obj.figureHandle);
            obj.addSourceButtons.menu = uimenu( ...
                'Parent', treeMenu, ...
                'Label', 'Add Source...', ...
                'Callback', @(h,d)notify(obj, 'AddSource'));
            obj.beginEpochGroupButtons.menu = uimenu( ...
                'Parent', treeMenu, ...
                'Label', 'Begin Epoch Group...', ...
                'Separator', 'on', ...
                'Callback', @(h,d)notify(obj, 'BeginEpochGroup'));
            obj.endEpochGroupButtons.menu = uimenu( ...
                'Parent', treeMenu, ...
                'Label', 'End Epoch Group', ...
                'Callback', @(h,d)notify(obj, 'EndEpochGroup'));
            obj.refreshButtons.menu = uimenu( ...
                'Parent', treeMenu, ...
                'Label', 'Refresh', ...
                'Separator', 'on', ...
                'Callback', @(h,d)notify(obj, 'Refresh'));
            set(obj.entityTree, 'UIContextMenu', treeMenu);

            root = obj.entityTree.Root;
            set(root, 'Value', struct('entity', [], 'type', EntityNodeType.EXPERIMENT));
            root.setIcon(symphonyui.app.App.getResource('icons/experiment.png'));
            set(root, 'UIContextMenu', obj.createEntityContextMenu());

            sources = uiextras.jTree.TreeNode( ...
                'Parent', root, ...
                'Name', 'Sources', ...
                'Value', struct('entity', [], 'type', EntityNodeType.FOLDER));
            sources.setIcon(symphonyui.app.App.getResource('icons/folder.png'));
            obj.sourcesFolderNode = sources;

            groups = uiextras.jTree.TreeNode( ...
                'Parent', root, ...
                'Name', 'Epoch Groups', ...
                'Value', struct('entity', [], 'type', EntityNodeType.FOLDER));
            groups.setIcon(symphonyui.app.App.getResource('icons/folder.png'));
            obj.epochGroupsFolderNode = groups;

            detailLayout = uix.VBox( ...
                'Parent', mainLayout);

            obj.detailCardPanel = uix.CardPanel( ...
                'Parent', detailLayout);

            % Empty card.
            emptyLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel);
            uix.Empty('Parent', emptyLayout);
            obj.emptyCard.text = uicontrol( ...
                'Parent', emptyLayout, ...
                'Style', 'text', ...
                'HorizontalAlignment', 'center');
            uix.Empty('Parent',emptyLayout);
            set(emptyLayout, ...
                'Heights', [-1 25 -1], ...
                'UserData', struct('Height', -1));

            % Source card.
            sourceLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            sourceGrid = uix.Grid( ...
                'Parent', sourceLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', sourceGrid, ...
                'String', 'Label:');
            obj.sourceCard.labelField = uicontrol( ...
                'Parent', sourceGrid, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SetSourceLabel'));
            set(sourceGrid, ...
                'Widths', [35 -1], ...
                'Heights', 25);
            obj.sourceCard.annotationsLayout = uix.VBox( ...
                'Parent', sourceLayout);
            set(sourceLayout, ...
                'Heights', [layoutHeight(sourceGrid) -1]);

            % Experiment card.
            experimentLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            experimentGrid = uix.Grid( ...
                'Parent', experimentLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', experimentGrid, ...
                'String', 'Purpose:');
            Label( ...
                'Parent', experimentGrid, ...
                'String', 'Start time:');
            Label( ...
                'Parent', experimentGrid, ...
                'String', 'End time:');
            obj.experimentCard.purposeField = uicontrol( ...
                'Parent', experimentGrid, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SetExperimentPurpose'));
            obj.experimentCard.startTimeField = uicontrol( ...
                'Parent', experimentGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.experimentCard.endTimeField = uicontrol( ...
                'Parent', experimentGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            set(experimentGrid, ...
                'Widths', [60 -1], ...
                'Heights', [25 25 25]);
            obj.experimentCard.annotationsLayout = uix.VBox( ...
                'Parent', experimentLayout);
            set(experimentLayout, ...
                'Heights', [layoutHeight(experimentGrid) -1]);

            % Epoch group card.
            epochGroupLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            epochGroupGrid = uix.Grid( ...
                'Parent', epochGroupLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', epochGroupGrid, ...
                'String', 'Label:');
            Label( ...
                'Parent', epochGroupGrid, ...
                'String', 'Start time:');
            Label( ...
                'Parent', epochGroupGrid, ...
                'String', 'End time:');
            Label( ...
                'Parent', epochGroupGrid, ...
                'String', 'Source:');
            obj.epochGroupCard.labelField = uicontrol( ...
                'Parent', epochGroupGrid, ...
                'Style', 'edit', ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SetEpochGroupLabel'));
            obj.epochGroupCard.startTimeField = uicontrol( ...
                'Parent', epochGroupGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.epochGroupCard.endTimeField = uicontrol( ...
                'Parent', epochGroupGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.epochGroupCard.sourceField = uicontrol( ...
                'Parent', epochGroupGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            set(epochGroupGrid, ...
                'Widths', [60 -1], ...
                'Heights', [25 25 25 25]);
            obj.epochGroupCard.annotationsLayout = uix.VBox( ...
                'Parent', epochGroupLayout);
            set(epochGroupLayout, ...
                'Heights', [layoutHeight(epochGroupGrid) -1]);

            % Epoch block card.
            epochBlockLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            epochBlockGrid = uix.Grid( ...
                'Parent', epochBlockLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', epochBlockGrid, ...
                'String', 'Protocol ID:');
            Label( ...
                'Parent', epochBlockGrid, ...
                'String', 'Start time:');
            Label( ...
                'Parent', epochBlockGrid, ...
                'String', 'End time:');
            obj.epochBlockCard.protocolIdField = uicontrol( ...
                'Parent', epochBlockGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.epochBlockCard.startTimeField = uicontrol( ...
                'Parent', epochBlockGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.epochBlockCard.endTimeField = uicontrol( ...
                'Parent', epochBlockGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            set(epochBlockGrid, ...
                'Widths', [65 -1], ...
                'Heights', [25 25 25]);
            obj.epochBlockCard.annotationsLayout = uix.VBox( ...
                'Parent', epochBlockLayout);
            set(epochBlockLayout, ...
                'Heights', [layoutHeight(epochBlockGrid) -1]);

            % Epoch card.
            epochLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            epochGrid = uix.Grid( ...
                'Parent', epochLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', epochGrid, ...
                'String', 'Plotted signal:');
            obj.epochCard.signalPopupMenu = MappedPopupMenu( ...
                'Parent', epochGrid, ...
                'String', {' '}, ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SelectedEpochSignal'));
            set(epochGrid, ...
                'Widths', [80 -1], ...
                'Heights', 25);
            obj.epochCard.panel = uipanel( ...
                'Parent', epochLayout, ...
                'BorderType', 'line', ...
                'HighlightColor', [130/255 135/255 144/255], ...
                'BackgroundColor', 'w');
            obj.epochCard.axes = axes( ...
                'Parent', obj.epochCard.panel, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'));
            axesMenu = uicontextmenu('Parent', obj.figureHandle);
            uimenu( ...
                'Parent', axesMenu, ...
                'Label', 'Open in new window', ...
                'Callback', @(h,d)notify(obj, 'OpenAxesInNewWindow'));
            set(obj.epochCard.axes, 'UIContextMenu', axesMenu);
            set(obj.epochCard.panel, 'UIContextMenu', axesMenu);
            obj.epochCard.annotationsLayout = uix.VBox( ...
                'Parent', epochLayout);
            set(epochLayout, ...
                'Heights', [layoutHeight(epochGrid) -1 -1]);

            % Tab group.
            obj.tabGroup = TabGroup( ...
                'Parent', obj.experimentCard.annotationsLayout);

            % Properties tab.
            obj.propertiesTab.tab = uitab( ...
                'Parent', [], ...
                'Title', 'Properties');
            obj.tabGroup.addTab(obj.propertiesTab.tab);
            propertiesLayout = uix.VBox( ...
                'Parent', obj.propertiesTab.tab, ...
                'Spacing', 1);
            obj.propertiesTab.grid = uiextras.jide.PropertyGrid(propertiesLayout, ...
                'BorderType', 'none', ...
                'ShowDescription', true, ...
                'Callback', @(h,d)notify(obj, 'SetProperty', symphonyui.ui.UiEventData(d)));

            % Properties toolbar.
            propertiesToolbarLayout = uix.HBox( ...
                'Parent', propertiesLayout, ...
                'Spacing', 2);
            v = uix.VBox( ...
                'Parent', propertiesToolbarLayout);
            uix.Empty('Parent', v);
            obj.propertiesTab.presetPopupMenu = MappedPopupMenu( ...
                'Parent', v, ...
                'String', {' '}, ...
                'HorizontalAlignment', 'left', ...
                'Callback', @(h,d)notify(obj, 'SelectedPropertiesPreset'));
            set(v, 'Heights', [1 -1]);
            propertiesButtonLayout = uix.HBox( ...
                'Parent', propertiesToolbarLayout);
            obj.propertiesTab.addButton = uicontrol( ...
                'Parent', propertiesButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '+', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Callback', @(h,d)notify(obj, 'AddProperty'));
            obj.propertiesTab.removeButton = uicontrol( ...
                'Parent', propertiesButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '-', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Callback', @(h,d)notify(obj, 'RemoveProperty'));
            set(propertiesToolbarLayout, 'Widths', [-1 50]);

            set(propertiesLayout, 'Heights', [-1 25]);

            % Keywords tab.
            obj.keywordsTab.tab = uitab( ...
                'Parent', [], ...
                'Title', 'Keywords');
            obj.tabGroup.addTab(obj.keywordsTab.tab);
            keywordsLayout = uix.VBox( ...
                'Parent', obj.keywordsTab.tab, ...
                'Spacing', 1);
            obj.keywordsTab.table = Table( ...
                'Parent', keywordsLayout, ...
                'ColumnName', {'Keyword'}, ...
                'Editable', false);
            javacomponent('javax.swing.JSeparator', [], keywordsLayout);

            % Keywords toolbar.
            keywordsToolbarLayout = uix.HBox( ...
                'Parent', keywordsLayout, ...
                'Spacing', 2);
            uix.Empty('Parent', keywordsToolbarLayout);
            keywordsButtonLayout = uix.HBox( ...
                'Parent', keywordsToolbarLayout);
            obj.keywordsTab.addButton = uicontrol( ...
                'Parent', keywordsButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '+', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Callback', @(h,d)notify(obj, 'AddKeyword'));
            obj.keywordsTab.removeButton = uicontrol( ...
                'Parent', keywordsButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '-', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Callback', @(h,d)notify(obj, 'RemoveKeyword'));
            set(keywordsToolbarLayout, 'Widths', [-1 50]);

            set(keywordsLayout, 'Heights', [-1 1 25]);

            % Notes tab.
            obj.notesTab.tab = uitab( ...
                'Parent', [], ...
                'Title', 'Notes');
            obj.tabGroup.addTab(obj.notesTab.tab);
            notesLayout = uix.VBox( ...
                'Parent', obj.notesTab.tab, ...
                'Spacing', 1);
            obj.notesTab.table = Table( ...
                'Parent', notesLayout, ...
                'ColumnName', {'Time', 'Text'}, ...
                'ColumnWidth', {80}, ...
                'Editable', false);
            javacomponent('javax.swing.JSeparator', [], notesLayout);

            % Notes toolbar.
            notesToolbarLayout = uix.HBox( ...
                'Parent', notesLayout, ...
                'Spacing', 2);
            uix.Empty('Parent', notesToolbarLayout);
            notesButtonLayout = uix.HBox( ...
                'Parent', notesToolbarLayout);
            obj.notesTab.addButton = uicontrol( ...
                'Parent', notesButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '+', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Callback', @(h,d)notify(obj, 'AddNote'));
            obj.notesTab.removeButton = uicontrol( ...
                'Parent', notesButtonLayout, ...
                'Style', 'pushbutton', ...
                'String', '-', ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize') + 1, ...
                'Enable', 'off');
            set(notesToolbarLayout, 'Widths', [-1 50]);

            set(notesLayout, 'Heights', [-1 1 25]);

            % Parameters tab.
            obj.parametersTab.tab = uitab( ...
                'Parent', [], ...
                'Title', 'Parameters');
            obj.tabGroup.addTab(obj.parametersTab.tab);
            parametersLayout = uix.VBox( ...
                'Parent', obj.parametersTab.tab);
            obj.parametersTab.grid = uiextras.jide.PropertyGrid(parametersLayout, ...
                'BorderType', 'none', ...
                'EditorStyle', 'readonly');

            set(mainLayout, 'Widths', [-1 -1.75]);
        end

        function show(obj)
            show@symphonyui.ui.View(obj);
            drawnow();
            set(obj.keywordsTab.table, 'ColumnHeaderVisible', false);
            set(obj.notesTab.table, 'ColumnHeaderVisible', false);
        end

        function close(obj)
            close@symphonyui.ui.View(obj);
            obj.propertiesTab.grid.Close();
            obj.parametersTab.grid.Close();
        end

        function enableBeginEpochGroup(obj, tf)
            enable = symphonyui.ui.util.onOff(tf);
            set(obj.beginEpochGroupButtons.tool, 'Enable', enable);
            set(obj.beginEpochGroupButtons.menu, 'Enable', enable);
        end

        function enableEndEpochGroup(obj, tf)
            enable = symphonyui.ui.util.onOff(tf);
            set(obj.endEpochGroupButtons.tool, 'Enable', enable);
            set(obj.endEpochGroupButtons.menu, 'Enable', enable);
        end

        function setCardSelection(obj, index)
            set(obj.detailCardPanel, 'Selection', index);

            switch index
                case obj.SOURCE_CARD
                    set(obj.tabGroup, 'Parent', obj.sourceCard.annotationsLayout);
                case obj.EXPERIMENT_CARD
                    set(obj.tabGroup, 'Parent', obj.experimentCard.annotationsLayout);
                case obj.EPOCH_GROUP_CARD
                    set(obj.tabGroup, 'Parent', obj.epochGroupCard.annotationsLayout);
                case obj.EPOCH_BLOCK_CARD
                    set(obj.tabGroup, 'Parent', obj.epochBlockCard.annotationsLayout);
                case obj.EPOCH_CARD
                    set(obj.tabGroup, 'Parent', obj.epochCard.annotationsLayout);
            end

            if index == obj.EPOCH_CARD || index == obj.EPOCH_BLOCK_CARD
                obj.tabGroup.addTab(obj.parametersTab.tab);
            else
                obj.tabGroup.removeTab(obj.parametersTab.tab);
            end
        end

        function setEmptyText(obj, t)
            set(obj.emptyCard.text, 'String', t);
        end

        function n = getSourcesFolderNode(obj)
            n = obj.sourcesFolderNode;
        end

        function n = addSourceNode(obj, parent, name, entity)
            value.entity = entity;
            value.type = symphonyui.ui.views.EntityNodeType.SOURCE;
            n = uiextras.jTree.TreeNode( ...
                'Parent', parent, ...
                'Name', name, ...
                'Value', value);
            n.setIcon(symphonyui.app.App.getResource('icons/source.png'));
            set(n, 'UIContextMenu', obj.createEntityContextMenu());
        end

        function enableSourceLabel(obj, tf)
            set(obj.sourceCard.labelField, 'Enable', symphonyui.ui.util.onOff(tf));
        end

        function l = getSourceLabel(obj)
            l = get(obj.sourceCard.labelField, 'String');
        end

        function setSourceLabel(obj, l)
            set(obj.sourceCard.labelField, 'String', l);
        end

        function setExperimentNode(obj, name, entity)
            value = get(obj.entityTree.Root, 'Value');
            value.entity = entity;
            set(obj.entityTree.Root, ...
                'Name', name, ...
                'Value', value);
        end

        function n = getExperimentNode(obj)
            n = obj.entityTree.Root;
        end

        function enableExperimentPurpose(obj, tf)
            set(obj.experimentCard.purposeField, 'Enable', symphonyui.ui.util.onOff(tf));
        end

        function p = getExperimentPurpose(obj)
            p = get(obj.experimentCard.purposeField, 'String');
        end

        function setExperimentPurpose(obj, p)
            set(obj.experimentCard.purposeField, 'String', p);
        end

        function requestExperimentPurposeFocus(obj)
            obj.update();
            uicontrol(obj.experimentCard.purposeField);
        end

        function setExperimentStartTime(obj, t)
            set(obj.experimentCard.startTimeField, 'String', t);
        end

        function setExperimentEndTime(obj, t)
            set(obj.experimentCard.endTimeField, 'String', t);
        end

        function n = getEpochGroupsFolderNode(obj)
            n = obj.epochGroupsFolderNode;
        end

        function n = addEpochGroupNode(obj, parent, name, entity)
            value.entity = entity;
            value.type = symphonyui.ui.views.EntityNodeType.EPOCH_GROUP;
            n = uiextras.jTree.TreeNode( ...
                'Parent', parent, ...
                'Name', name, ...
                'Value', value);
            n.setIcon(symphonyui.app.App.getResource('icons/group.png'));
            set(n, 'UIContextMenu', obj.createEntityContextMenu());
        end

        function enableEpochGroupLabel(obj, tf)
            set(obj.epochGroupCard.labelField, 'Enable', symphonyui.ui.util.onOff(tf));
        end

        function l = getEpochGroupLabel(obj)
            l = get(obj.epochGroupCard.labelField, 'String');
        end

        function setEpochGroupLabel(obj, l)
            set(obj.epochGroupCard.labelField, 'String', l);
        end

        function setEpochGroupStartTime(obj, t)
            set(obj.epochGroupCard.startTimeField, 'String', t);
        end

        function setEpochGroupEndTime(obj, t)
            set(obj.epochGroupCard.endTimeField, 'String', t);
        end

        function setEpochGroupSource(obj, s)
            set(obj.epochGroupCard.sourceField, 'String', s);
        end

        function setEpochGroupNodeCurrent(obj, node) %#ok<INUSL>
            node.setIcon(symphonyui.app.App.getResource('icons/group_current.png'));
        end

        function setEpochGroupNodeNormal(obj, node) %#ok<INUSL>
            node.setIcon(symphonyui.app.App.getResource('icons/group.png'));
        end

        function n = addEpochBlockNode(obj, parent, name, entity)
            value.entity = entity;
            value.type = symphonyui.ui.views.EntityNodeType.EPOCH_BLOCK;
            n = uiextras.jTree.TreeNode( ...
                'Parent', parent, ...
                'Name', name, ...
                'Value', value);
            n.setIcon(symphonyui.app.App.getResource('icons/block.png'));
            set(n, 'UIContextMenu', obj.createEntityContextMenu());
        end

        function setEpochBlockProtocolId(obj, i)
            set(obj.epochBlockCard.protocolIdField, 'String', i);
        end
        
        function setEpochBlockProtocolParameters(obj, properties)
            set(obj.parametersTab.grid, 'Properties', properties);
        end

        function setEpochBlockStartTime(obj, t)
            set(obj.epochBlockCard.startTimeField, 'String', t);
        end

        function setEpochBlockEndTime(obj, t)
            set(obj.epochBlockCard.endTimeField, 'String', t);
        end

        function n = addEpochNode(obj, parent, name, entity)
            value.entity = entity;
            value.type = symphonyui.ui.views.EntityNodeType.EPOCH;
            n = uiextras.jTree.TreeNode( ...
                'Parent', parent, ...
                'Name', name, ...
                'Value', value);
            n.setIcon(symphonyui.app.App.getResource('icons/epoch.png'));
            set(n, 'UIContextMenu', obj.createEntityContextMenu());
        end
        
        function s = getSelectedEpochSignal(obj)
            s = get(obj.epochCard.signalPopupMenu, 'Value');
        end

        function setSelectedEpochSignal(obj, s)
            set(obj.epochCard.signalPopupMenu, 'Value', s);
        end
        
        function setEpochSignalList(obj, names, values)
            set(obj.epochCard.signalPopupMenu, 'String', names);
            set(obj.epochCard.signalPopupMenu, 'Values', values);
        end

        function clearEpochDataAxes(obj)
            cla(obj.epochCard.axes);
        end

        function setEpochDataAxesLabels(obj, x, y)
            xlabel(obj.epochCard.axes, x, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'));
            ylabel(obj.epochCard.axes, y, ...
                'FontName', get(obj.figureHandle, 'DefaultUicontrolFontName'), ...
                'FontSize', get(obj.figureHandle, 'DefaultUicontrolFontSize'));
        end

        function addEpochDataLine(obj, x, y, color)
            line(x, y, 'Parent', obj.epochCard.axes, 'Color', color);
        end

        function openEpochDataAxesInNewWindow(obj)
            fig = figure( ...
                'MenuBar', 'figure', ...
                'Toolbar', 'figure', ...
                'Visible', 'off');
            axes = copyobj(obj.epochCard.axes, fig);
            set(axes, ...
                'Units', 'normalized', ...
                'Position', get(groot, 'defaultAxesPosition'));
            set(fig, 'Visible', 'on');
        end

        function setEpochProtocolParameters(obj, properties)
            set(obj.parametersTab.grid, 'Properties', properties);
        end

        function n = getNodeName(obj, node) %#ok<INUSL>
            n = get(node, 'Name');
        end

        function setNodeName(obj, node, name) %#ok<INUSL>
            set(node, 'Name', name);
        end

        function e = getNodeEntity(obj, node) %#ok<INUSL>
            v = get(node, 'Value');
            e = v.entity;
        end

        function t = getNodeType(obj, node) %#ok<INUSL>
            v = get(node, 'Value');
            t = v.type;
        end

        function removeNode(obj, node) %#ok<INUSL>
            node.delete();
        end

        function collapseNode(obj, node) %#ok<INUSL>
            node.collapse();
        end

        function expandNode(obj, node) %#ok<INUSL>
            node.expand();
        end

        function nodes = getSelectedNodes(obj)
            nodes = obj.entityTree.SelectedNodes;
        end

        function setSelectedNodes(obj, nodes)
            obj.entityTree.SelectedNodes = nodes;
        end

        function setPropertiesEditorStyle(obj, s)
            set(obj.propertiesTab.grid, 'EditorStyle', s);
        end
        
        function p = getSelectedProperty(obj)
            p = obj.propertiesTab.grid.GetSelectedProperty();
        end
        
        function f = getProperties(obj)
            f = get(obj.propertiesTab.grid, 'Properties');
        end

        function setProperties(obj, fields)
            set(obj.propertiesTab.grid, 'Properties', fields);
        end

        function updateProperties(obj, fields)
            obj.propertiesTab.grid.UpdateProperties(fields);
        end

        function t = getSelectedPropertiesPreset(obj)
            t = get(obj.propertiesTab.presetPopupMenu, 'Value');
        end

        function setSelectedPropertiesPreset(obj, t)
            set(obj.propertiesTab.presetPopupMenu, 'Value', t);
        end

        function setPropertiesPresetList(obj, names, values)
            set(obj.propertiesTab.presetPopupMenu, 'String', names);
            set(obj.propertiesTab.presetPopupMenu, 'Values', values);
        end

        function setKeywords(obj, data)
            set(obj.keywordsTab.table, 'Data', data);
        end

        function addKeyword(obj, keyword)
            obj.keywordsTab.table.addRow(keyword);
        end

        function removeKeyword(obj, keyword)
            keywords = obj.keywordsTab.table.getColumnData(1);
            index = find(cellfun(@(c)strcmp(c, keyword), keywords));
            obj.keywordsTab.table.removeRow(index); %#ok<FNDSB>
        end

        function k = getSelectedKeyword(obj)
            row = get(obj.keywordsTab.table, 'SelectedRow');
            k = obj.keywordsTab.table.getValueAt(row, 1);
        end

        function setNotes(obj, data)
            set(obj.notesTab.table, 'Data', data);
        end

        function addNote(obj, date, text)
            obj.notesTab.table.addRow({date, text});
        end

    end

    methods (Access = private)

        function menu = createEntityContextMenu(obj)
            menu = uicontextmenu('Parent', obj.figureHandle);
            m.sendToWorkspaceMenu = uimenu( ...
                'Parent', menu, ...
                'Label', 'Send to Workspace', ...
                'Callback', @(h,d)notify(obj, 'SendEntityToWorkspace'));
            m.deleteMenu = uimenu( ...
                'Parent', menu, ...
                'Label', 'Delete', ...
                'Callback', @(h,d)notify(obj, 'DeleteEntity'));
            set(menu, 'UserData', m);
        end

    end

end
