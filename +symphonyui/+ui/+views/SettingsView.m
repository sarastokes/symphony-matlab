classdef SettingsView < symphonyui.ui.View

    events
        SelectedNode
        Ok
        Cancel
    end

    properties (Access = private)
        nodeList
        cardPanel
        generalCard
        experimentCard
        epochGroupCard
        okButton
        cancelButton
    end

    methods

        function obj = SettingsView(parent)
            obj = obj@symphonyui.ui.View(parent);
        end

        function createUI(obj)
            import symphonyui.util.*;
            import symphonyui.util.ui.*;

            set(obj.figureHandle, 'Name', 'Settings');
            set(obj.figureHandle, 'Position', screenCenter(467, 356));

            mainLayout = uiextras.VBox( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 7);

            preferencesLayout = uiextras.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);

            obj.nodeList = uicontrol( ...
                'Parent', preferencesLayout, ...
                'Style', 'list', ...
                'String', {'General', 'Experiment', 'Epoch Group', 'Source'}, ...
                'Callback', @(h,d)notify(obj, 'SelectedNode'));

            obj.cardPanel = uix.CardPanel( ...
                'Parent', preferencesLayout);

            % General card.
            generalLabelSize = 120;
            generalLayout = uiextras.VBox( ...
                'Parent', obj.cardPanel, ...
                'Spacing', 7);
            obj.generalCard.rigSearchPathsField = createLabeledTextField(generalLayout, 'Rig search paths:', [generalLabelSize -1]);
            obj.generalCard.protocolSearchPathsField = createLabeledTextField(generalLayout, 'Protocol search paths:', [generalLabelSize -1]);
            set(generalLayout, 'Sizes', [25 25]);

            % Experiments card.
            experimentLabelSize = 100;
            experimentLayout = uiextras.VBox( ...
                'Parent', obj.cardPanel, ...
                'Spacing', 7);
            obj.experimentCard.defaultNameField = createLabeledTextField(experimentLayout, 'Default name:', [experimentLabelSize -1]);
            obj.experimentCard.defaultPurposeField = createLabeledTextField(experimentLayout, 'Default purpose:', [experimentLabelSize -1]);
            obj.experimentCard.defaultLocationField = createLabeledTextField(experimentLayout, 'Default location:', [experimentLabelSize -1]);
            set(experimentLayout, 'Sizes', [25 25 25]);

            % Epoch group card.
            epochGroupLabelSize = 115;
            epochGroupLayout = uiextras.VBox( ...
                'Parent', obj.cardPanel, ...
                'Spacing', 7);
            obj.epochGroupCard.labelListField = createLabeledTextField(epochGroupLayout, 'Label list:', [epochGroupLabelSize -1]);
            obj.epochGroupCard.recordingListField = createLabeledTextField(epochGroupLayout, 'Recording list:', [epochGroupLabelSize -1]);
            obj.epochGroupCard.defaultKeywordsField = createLabeledTextField(epochGroupLayout, 'Default keywords:', [epochGroupLabelSize -1]);
            obj.epochGroupCard.externalSolutionListField = createLabeledTextField(epochGroupLayout, 'External solution list:', [epochGroupLabelSize -1]);
            obj.epochGroupCard.internalSolutionListField = createLabeledTextField(epochGroupLayout, 'Internal solution list:', [epochGroupLabelSize -1]);
            obj.epochGroupCard.otherListField = createLabeledTextField(epochGroupLayout, 'Other list:', [epochGroupLabelSize -1]);
            set(epochGroupLayout, 'Sizes', [25 25 25 25 25 25]);

            % Sources card.
            sourceLabelSize = 100;
            sourceLayout = uiextras.VBox( ...
                'Parent', obj.cardPanel, ...
                'Spacing', 7);

            set(obj.cardPanel, 'Selection', 1);

            set(preferencesLayout, 'Sizes', [110 -1]);

            % Ok/Cancel controls.
            controlsLayout = uiextras.HBox( ...
                'Parent', mainLayout, ...
                'Spacing', 7);
            uiextras.Empty('Parent', controlsLayout);
            obj.okButton = uicontrol( ...
                'Parent', controlsLayout, ...
                'Style', 'pushbutton', ...
                'String', 'OK', ...
                'Callback', @(h,d)notify(obj, 'Ok'));
            obj.cancelButton = uicontrol( ...
                'Parent', controlsLayout, ...
                'Style', 'pushbutton', ...
                'String', 'Cancel', ...
                'Callback', @(h,d)notify(obj, 'Cancel'));
            set(controlsLayout, 'Sizes', [-1 75 75]);

            set(mainLayout, 'Sizes', [-1 25]);

            % Set OK button to appear as the default button.
            try %#ok<TRYNC>
                h = handle(obj.figureHandle);
                h.setDefaultButton(obj.okButton);
            end
        end

        function n = getNode(obj)
            n = symphonyui.util.ui.getSelectedValue(obj.nodeList);
        end

        function setCard(obj, c)
            list = get(obj.nodeList, 'String');
            selection = find(strcmp(list, c));
            set(obj.cardPanel, 'Selection', selection);
        end

        function p = getRigSearchPaths(obj)
            p = get(obj.generalCard.rigSearchPathsField, 'String');
        end

        function setRigSearchPaths(obj, p)
            set(obj.generalCard.rigSearchPathsField, 'String', p);
        end

        function p = getProtocolSearchPaths(obj)
            p = get(obj.generalCard.protocolSearchPathsField, 'String');
        end

        function setProtocolSearchPaths(obj, p)
            set(obj.generalCard.protocolSearchPathsField, 'String', p);
        end

        function n = getDefaultName(obj)
            n = get(obj.experimentCard.defaultNameField, 'String');
        end

        function setDefaultName(obj, n)
            set(obj.experimentCard.defaultNameField, 'String', n);
        end

        function p = getDefaultPurpose(obj)
            p = get(obj.experimentCard.defaultPurposeField, 'String');
        end

        function setDefaultPurpose(obj, p)
            set(obj.experimentCard.defaultPurposeField, 'String', p);
        end

        function l = getDefaultLocation(obj)
            l = get(obj.experimentCard.defaultLocationField, 'String');
        end

        function setDefaultLocation(obj, l)
            set(obj.experimentCard.defaultLocationField, 'String', l);
        end

        function s = getSpeciesList(obj)
            s = get(obj.experimentCard.speciesListField, 'String');
        end

        function setSpeciesList(obj, s)
            set(obj.experimentCard.speciesListField, 'String', s);
        end

        function p = getPhenotypeList(obj)
            p = get(obj.experimentCard.phenotypeListField, 'String');
        end

        function setPhenotypeList(obj, p)
            set(obj.experimentCard.phenotypeListField, 'String', p);
        end

        function g = getGenotypeList(obj)
            g = get(obj.experimentCard.genotypeListField, 'String');
        end

        function setGenotypeList(obj, g)
            set(obj.experimentCard.genotypeListField, 'String', g);
        end

        function p = getPreparationList(obj)
            p = get(obj.experimentCard.preparationListField, 'String');
        end

        function setPreparationList(obj, p)
            set(obj.experimentCard.preparationListField, 'String', p);
        end

        function l = getLabelList(obj)
            l = get(obj.epochGroupCard.labelListField, 'String');
        end

        function setLabelList(obj, s)
            set(obj.epochGroupCard.labelListField, 'String', s);
        end

        function r = getRecordingList(obj)
            r = get(obj.epochGroupCard.recordingListField, 'String');
        end

        function setRecordingList(obj, r)
            set(obj.epochGroupCard.recordingListField, 'String', r);
        end

        function k = getDefaultKeywords(obj)
            k = get(obj.epochGroupCard.defaultKeywordsField, 'String');
        end

        function setDefaultKeywords(obj, k)
            set(obj.epochGroupCard.defaultKeywordsField, 'String', k);
        end

        function s = getExternalSolutionList(obj)
            s = get(obj.epochGroupCard.externalSolutionListField, 'String');
        end

        function setExternalSolutionList(obj, s)
            set(obj.epochGroupCard.externalSolutionListField, 'String', s);
        end

        function s = getInternalSolutionList(obj)
            s = get(obj.epochGroupCard.internalSolutionListField, 'String');
        end

        function setInternalSolutionList(obj, s)
            set(obj.epochGroupCard.internalSolutionListField, 'String', s);
        end

        function o = getOtherList(obj)
            o = get(obj.epochGroupCard.otherListField, 'String');
        end

        function setOtherList(obj, o)
            set(obj.epochGroupCard.otherListField, 'String', o);
        end

    end

end