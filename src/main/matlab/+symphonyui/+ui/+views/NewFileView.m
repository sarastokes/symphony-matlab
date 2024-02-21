classdef NewFileView < aod.app.UIView

% 21Feb2024 - SSP - Updated for UIView

    events
        BrowseLocation
        Ok
        Cancel
    end

    properties (Access = private)
        nameField
        locationField
        browseLocationButton
        descriptionPopupMenu
        spinner
        okButton
        cancelButton
    end

    methods

        function createUi(obj)
            import appbox.*;

            set(obj.figureHandle, ...
                'Name', 'New File', ...
            	'Position', screenCenter(500, 139)); 

            mainLayout = uigridlayout(obj.figureHandle, [2 1],...
                "RowHeight", {"1x", 23},...
                "Padding", 5, "RowSpacing", 11);

            fileLayout = uigridlayout(mainLayout, [3 3],...
                "ColumnWidth", {65, "1x", 23},...
                "RowHeight", {23, 23, 23},...
                "RowSpacing", 7, "ColumnSpacing", 7);
            uilabel(fileLayout, "Text", "Name:",...
                "VerticalAlignment", "center");
            obj.nameField = uieditfield(fileLayout,...
                "HorizontalAlignment", "left");
            uipanel(fileLayout, "BorderType", "none");

            uilabel(fileLayout, "Text", "Location:",...
                "VerticalAlignment", "center");
            obj.locationField = uieditfield(fileLayout,...
                "HorizontalAlignment", "left");
            obj.browseLocationButton = uibutton(fileLayout,...
                "Interruptible", "off",...
                "Text", "...", "Icon", [],...
                "ButtonPushedFcn", @(h,d)notify(obj, 'BrowseLocation'));

            uilabel(fileLayout, "Text", "Description:",...
                "VerticalAlignment", "center");
            obj.descriptionPopupMenu = uidropdown(fileLayout,...
                "Items", {' '});
            uipanel(fileLayout, "BorderType", "none");


            controlsLayout = uigridlayout(mainLayout, [1 4],...
                "ColumnWidth", {16, "1x", 75, 75},...
                "ColumnSpacing", 7, "Padding", 0);
            spinnerLayout = uigridlayout(controlsLayout, [2 1],...
                "ColumnWidth", {4, 30});
            uipanel(spinnerLayout, "BorderType", "none");
            obj.spinner = uibutton(spinnerLayout,...
                "Icon", "spinner.gif",...
                "Text", "", "Enable", "off");
            uipanel(controlsLayout, "BorderType", "none");
            obj.okButton = uibutton(controlsLayout,...
                "Interruptible", "off",...
                "Text", "OK", "Icon", [],...
                "ButtonPushedFcn", @(h,d)notify(obj, 'Ok'));
            obj.cancelButton = uibutton(controlsLayout,...
                "Interruptible", "off",...
                "Text", "Cancel", "Icon", [],...
                "ButtonPushedFcn", @(h,d)notify(obj, 'Cancel'));
        end

        function enableOk(obj, tf)
            set(obj.okButton, 'Enable', appbox.onOff(tf));
        end
        
        function tf = getEnableOk(obj)
            tf = appbox.onOff(get(obj.okButton, 'Enable'));
            obj.requestOkFocus();
        end
        
        function enableCancel(obj, tf)
            set(obj.cancelButton, 'Enable', appbox.onOff(tf));
        end
        
        function enableName(obj, tf)
            set(obj.nameField, 'Enable', appbox.onOff(tf));
        end

        function n = getName(obj)
            n = get(obj.nameField, 'Value');
        end

        function setName(obj, n)
            set(obj.nameField, 'Value', n);
        end

        function requestNameFocus(obj)
            obj.update();
            focus(obj.nameField);
        end

        function requestOkFocus(obj)
            focus(obj.okButton);
        end
        
        function enableLocation(obj, tf)
            set(obj.locationField, 'Enable', appbox.onOff(tf));
        end

        function l = getLocation(obj)
            l = get(obj.locationField, 'Value');
        end

        function setLocation(obj, l)
            set(obj.locationField, 'Value', l);
        end
        
        function enableBrowseLocation(obj, tf)
            set(obj.browseLocationButton, 'Enable', appbox.onOff(tf));
        end

        function enableSelectDescription(obj, tf)
            set(obj.descriptionPopupMenu, 'Enable', appbox.onOff(tf));
        end

        function t = getSelectedDescription(obj)
            t = get(obj.descriptionPopupMenu, 'Value');
        end

        function setSelectedDescription(obj, t)
            set(obj.descriptionPopupMenu, 'Value', t);
        end

        function l = getDescriptionList(obj)
            l = get(obj.descriptionPopupMenu, 'ItemsData');
        end

        function setDescriptionList(obj, names, values)
            set(obj.descriptionPopupMenu, 'Items', names);
            set(obj.descriptionPopupMenu, 'ItemsData', values); 
        end
        
        function startSpinner(obj)
            obj.spinner.Icon = "spinner.gif";
        end
        
        function stopSpinner(obj)
            obj.spinner.Icon = [];
        end

    end

end
