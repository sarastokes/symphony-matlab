classdef ConfigureDevicesView < appbox.View

    events
        SelectedDevice
    end

    properties (Access = private)
        deviceListBox
        detailCardPanel
        deviceCard
    end

    methods

        function createUi(obj)
            import appbox.*;

            set(obj.figureHandle, ...
                'Name', 'Configure Devices', ...
                'Position', screenCenter(500, 300));

            mainLayout = uix.HBoxFlex( ...
                'Parent', obj.figureHandle, ...
                'Padding', 11, ...
                'Spacing', 7);
            
            masterLayout = uix.VBox( ...
                'Parent', mainLayout);
            
            obj.deviceListBox = MappedListBox( ...
                'Parent', masterLayout, ...
                'Callback', @(h,d)notify(obj, 'SelectedDevice'));
            
            detailLayout = uix.VBox( ...
                'Parent', mainLayout);
            
            obj.detailCardPanel = uix.CardPanel( ...
                'Parent', detailLayout);
            
            % Device card.
            deviceLayout = uix.VBox( ...
                'Parent', obj.detailCardPanel, ...
                'Spacing', 7);
            deviceGrid = uix.Grid( ...
                'Parent', deviceLayout, ...
                'Spacing', 7);
            Label( ...
                'Parent', deviceGrid, ...
                'String', 'Name:');
            Label( ...
                'Parent', deviceGrid, ...
                'String', 'Manufacturer:');
            Label( ...
                'Parent', deviceGrid, ...
                'String', 'Background:');
            obj.deviceCard.nameField = uicontrol( ...
                'Parent', deviceGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.deviceCard.manufacturerField = uicontrol( ...
                'Parent', deviceGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            obj.deviceCard.backgroundField = uicontrol( ...
                'Parent', deviceGrid, ...
                'Style', 'edit', ...
                'Enable', 'off', ...
                'HorizontalAlignment', 'left');
            set(deviceGrid, ...
                'Widths', [80 -1], ...
                'Heights', [23 23 23]);
            
            
            obj.deviceCard.configurationGrid = uiextras.jide.PropertyGrid(deviceLayout);
            set(deviceLayout, ...
                'Heights', [layoutHeight(deviceGrid) -1]);
            
            set(mainLayout, 'Widths', [-1 -1.75]);
        end
        
        function d = getSelectedDevice(obj)
            d = get(obj.deviceListBox, 'Value');
        end
        
        function setDeviceList(obj, names, values)
            set(obj.deviceListBox, 'String', names);
            set(obj.deviceListBox, 'Values', values);
        end
        
        function setDeviceName(obj, n)
            set(obj.deviceCard.nameField, 'String', n);
        end
        
        function setDeviceManufacturer(obj, m)
            set(obj.deviceCard.manufacturerField, 'String', m);
        end
        
        function enableDeviceBackground(obj, tf)
            set(obj.deviceCard.backgroundField, 'Enable', appbox.onOff(tf));
        end
        
        function setDeviceBackground(obj, b)
            set(obj.deviceCard.backgroundField, 'String', b);
        end

    end

end