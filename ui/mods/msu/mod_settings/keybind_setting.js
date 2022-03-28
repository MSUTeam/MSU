var KeybindSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="string-container outline"/>');
	this.setting = _setting;
	this.parent = _parentDiv;
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title outline">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.input = $('<input type="text" class="title-font-big font-bold font-color-brother-name string-input"/>');
	this.input.val(_setting.value);
	this.input.on("change", function(){
		self.setting.value = self.input.val();
	});

	this.input.on("click", function(){
		this.blur();
		self.createPopup(_parentDiv);
	});


	this.layout.append(this.input);

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.input.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
};

KeybindSetting.prototype.createPopup = function ()
{
	var self = this;
	this.parent.mPopupDialog = $('.msu-settings-screen').createPopupDialog('Change Keybind', this.setting.name, null, 'change-keybind-popup');
	var result = this.parent.mPopupDialog.addPopupDialogContent($('<div class="change-keybind-container"/>'));
	//need to do this separately or the list won't render
	this.createChangeKeybindScrollContainer(result);
	this.parent.mPopupDialog.addPopupDialogButton('Cancel', 'l-cancel-keybind-button', function (_dialog)
	{
		_dialog.destroyPopupDialog();
	});
	this.parent.mPopupDialog.addPopupDialogButton('Add', 'l-add-keybind-button', function (_dialog)
	{
		self.createChangeKeybindRow("");
	});
	this.parent.mPopupDialog.addPopupDialogButton('OK', 'l-ok-keybind-button', function (_dialog)
	{
		var buttons = $(".change-keybind-button");
		var result = "";
		for(var idx = 0; idx < buttons.length; idx++)
		{
			var text = $(buttons[idx]).findButtonText().html();
			if(text.length > 0)
			{
				result += text + "/";
			}
		}
		result = result.slice(0, -1);
		self.input.val(result);
		self.setting.value = result;
		self.parent.mPopupDialog = null;
		_dialog.destroyPopupDialog();
	});

	 this.parent.mPopupDialog.addPopupDialogCancelButton(function (_dialog)
	 {
		self.parent.mPopupDialog = null;
		_dialog.destroyPopupDialog();
	 });
};

KeybindSetting.prototype.createChangeKeybindScrollContainer = function(_dialog)
{
	this.mButtonContainer = _dialog.createList(2);
	var keybindArray = this.setting.value.split("/");
	for (var x = 0; x < keybindArray.length; x++)
	{
		this.createChangeKeybindRow(keybindArray[x]);
	}
};

KeybindSetting.prototype.createChangeKeybindRow = function(_name)
{
	var row = $('<div class="row"/>');
	this.mButtonContainer.findListScrollContainer().append(row);

	var buttonLayout = $('<div class="keybind-button-container"/>');
	row.append(buttonLayout);
	var button = buttonLayout.createTextButton(_name, null, 'change-keybind-button', 4);
	button.css('margin-top', '-0.4rem'); // not sure why this is necessary but apparently it is for alignment
	button.findButtonText().css('margin-top', '0.8rem');

	var selectedButton = null;

	var callbackKeyboard = function(_event)
	{
		var key = MSU.Key.KeyMapJS[_event.keyCode];
		if (key === undefined || key === null)
		{
			return;
		}
		setButton(key);
	};

	var callbackMouse = function(_event)
	{
		var key = MSU.Key.MouseMapJS[_event.button];
		if (key === undefined || key === null)
		{
			return;
		}
		setButton(key);
	};

	var setButton = function(_key)
	{
		var pressedKeys = MSU.Keybinds.getPressedKeysAsString(_key) + _key;
		selectedButton.changeButtonText(MSU.Key.sortKeyString(pressedKeys));
		toggle(selectedButton, true);
	};

	var toggle = function(_button, _forcedOff)
	{
		if (_forcedOff === true || _button.data("Selected") === true)
		{
			document.removeEventListener("keyup", callbackKeyboard, true);
			document.removeEventListener("mouseup", callbackMouse, true);
			_button.data("Selected", false);
			_button.removeClass('is-selected');
			_button.css('pointer-events', 'auto');
			selectedButton = null;
		}
		else
		{
			document.addEventListener("keyup", callbackKeyboard, true);
			document.addEventListener("mouseup", callbackMouse, true);
			_button.data("Selected", true);
			_button.addClass('is-selected');
			_button.css('pointer-events', 'none');
			selectedButton = _button;
		}
	};
	button.on("click", function( _event ){
		var mainButton = this;
		var buttons = $(".change-keybind-button");
		buttons.map(function()
		{
			if (this != mainButton)
			{
				toggle($(this), true);
			}
		});
		toggle($(this), false);
	});
	button.off("mouseenter");
	button.off("mouseleave");
	button.off("mousedown");
	button.off("mouseup");
	button.on("mouseenter", function()
	{
		$(this).addClass('is-selected');
	});
	button.on("mouseleave", function()
	{
		if (!$(this).data("Selected"))
		{
			$(this).removeClass('is-selected');
		}
	});

	//Delete button
	var destroyButtonLayout = $('<div class="keybind-delete-button-container"/>');
	row.append(destroyButtonLayout);
	var destroyButton = destroyButtonLayout.createTextButton("Delete", function()
	{
		row.remove();
	}, 'delete-keybind-button', 2);
};

KeybindSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.input.unbindTooltip();
};
