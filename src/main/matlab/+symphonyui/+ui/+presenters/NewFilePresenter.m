classdef NewFilePresenter < appbox.Presenter

% 21Feb2024 - SSP - Updated for UIView
% TODO: showGetDirectory seems to be running twice 

    properties (Access = private)
        log
        options
        settings
        enables
        documentationService
    end

    methods

        function obj = NewFilePresenter(documentationService, options, view)
            if nargin < 3
                view = symphonyui.ui.views.NewFileView();
            end
            obj = obj@appbox.Presenter(view);

            obj.log = log4m.LogManager.getLogger(class(obj));
            obj.options = options;
            obj.settings = symphonyui.ui.settings.NewFileSettings();
            obj.enables = symphonyui.ui.util.trueStruct('name', 'location', 'browseLocation', 'selectDescription', ...
                'ok', 'cancel');
            obj.documentationService = documentationService;

            obj.go();
        end

    end

    methods (Access = protected)

        function willGo(obj)
            obj.populateName();
            obj.populateLocation();
            obj.populateDescriptionList();
            try
                obj.loadSettings();
            catch x
                obj.log.debug(['Failed to load presenter settings: ' x.message], x);
            end
            obj.updateStateOfControls();
        end

        function didGo(obj)
            obj.view.requestNameFocus();
        end

        function bind(obj)
            bind@appbox.Presenter(obj);

            v = obj.view;
            obj.addListener(v, 'KeyPress', @obj.onViewKeyPress);
            obj.addListener(v, 'BrowseLocation', @obj.onViewSelectedBrowseLocation);
            obj.addListener(v, 'Ok', @obj.onViewSelectedOk);
            obj.addListener(v, 'Cancel', @obj.onViewSelectedCancel);
        end

    end

    methods (Access = private)

        function populateName(obj)
            name = obj.options.fileDefaultName;
            try
                obj.view.setName(name());
            catch x
                obj.log.debug(['Unable to populate name: ' x.message], x);
            end
        end

        function populateLocation(obj)
            location = obj.options.fileDefaultLocation;
            try
                obj.view.setLocation(location());
            catch x
                obj.log.debug(['Unable to populate location: ' x.message], x);
            end
        end

        function populateDescriptionList(obj)
            classNames = obj.documentationService.getAvailableExperimentDescriptions();
            displayNames = appbox.class2display(classNames);

            [displayNames, i] = sort(displayNames);
            classNames = classNames(i);

            if numel(classNames) > 0
                obj.view.setDescriptionList(displayNames, classNames);
            else
                obj.view.setDescriptionList({'(None)'}, {[]});
            end
            
            obj.enables.selectDescription = ~isempty(classNames);
            obj.view.enableSelectDescription(obj.enables.selectDescription);
        end

        function onViewKeyPress(obj, ~, event)
            switch event.data.Key
                case 'return'
                    if obj.view.getEnableOk()
                        obj.onViewSelectedOk();
                    end
                case 'escape'
                    obj.onViewSelectedCancel();
            end
        end

        function onViewSelectedBrowseLocation(obj, ~, ~)
            location = obj.view.showGetDirectory('Select Location');
            if isempty(location)
                return;
            end
            obj.view.setLocation(location);
        end

        function onViewSelectedOk(obj, ~, ~)
            obj.view.update();

            name = obj.view.getName();
            location = obj.view.getLocation();
            description = obj.view.getSelectedDescription();
            try
                path = obj.documentationService.getFilePath(name, location);
                if exist(path, 'file')
                    result = obj.view.showMessage(['''' path ''' already exists. Overwrite?'], 'Overwrite File', ...
                        'button1', 'Cancel', ...
                        'button2', 'Overwrite');
                    if ~strcmp(result, 'Overwrite')
                        return;
                    end
                    delete(path);
                    if exist(path, 'file')
                        error(['Unable to delete ''' path '''']);
                    end
                end

                obj.disableControls();
                obj.view.startSpinner();
                obj.view.update();

                obj.documentationService.newFile(name, location, description);
            catch x
                obj.log.debug(x.message, x);
                obj.view.showError(x.message);
                obj.view.stopSpinner();
                obj.updateStateOfControls();
                return;
            end

            try
                obj.saveSettings();
            catch x
                obj.log.debug(['Failed to save presenter settings: ' x.message], x);
            end

            obj.result = true;
            obj.stop();
        end

        function onViewSelectedCancel(obj, ~, ~)
            obj.stop();
        end

        function disableControls(obj)
            obj.view.enableName(false);
            obj.view.enableLocation(false);
            obj.view.enableBrowseLocation(false);
            obj.view.enableSelectDescription(false);
            obj.view.enableOk(false);
            obj.view.enableCancel(false);
        end

        function updateStateOfControls(obj)
            descriptionList = obj.view.getDescriptionList();
            hasDescription = ~isempty(descriptionList{1});
            
            obj.view.enableName(obj.enables.name);
            obj.view.enableLocation(obj.enables.location);
            obj.view.enableBrowseLocation(obj.enables.browseLocation);
            obj.view.enableSelectDescription(obj.enables.selectDescription);
            obj.view.enableOk(hasDescription && obj.enables.ok);
            obj.view.enableCancel(obj.enables.cancel);
        end

        function loadSettings(obj)
            if any(strcmp(obj.settings.selectedDescription, obj.view.getDescriptionList()))
                obj.view.setSelectedDescription(obj.settings.selectedDescription);
            end
        end

        function saveSettings(obj)
            obj.settings.selectedDescription = obj.view.getSelectedDescription();
            obj.settings.save();
        end

    end

end
