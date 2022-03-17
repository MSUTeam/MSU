"use strict";

var ModSettingsScreen = function ()
{
	MSUUIScreen.call(this);
	this.mID = "ModSettingsScreen";

	this.mModPanels = {};
	this.mChangedPanels = {};
	this.mDialogContainer = null;
	this.mListContainer = null;
	this.mListScrollContainer = null;
	this.mModPageScrollContainer = null;
	this.mActiveSettings = [];
	this.mPageTabContainer = null;
	this.mActivePanelButton = null;
	/*

	this.mModPanels = 
	[
		{
			modID = "",
			name = "",
			pages = [
				id = "",
				name = "",
				settings = [
					{
						id = "",
						type = "",
						name = "",
						value = 0,
						locked = false,
					}
				]
			]
		}
		{

		}
	]
	*/

}

// Inheritance in JS
ModSettingsScreen.prototype = Object.create(MSUUIScreen.prototype)
Object.defineProperty(ModSettingsScreen.prototype, 'constructor', {
	value: ModSettingsScreen,
	enumerable: false,
	writable: true });

var BooleanSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.layout = $('<div class="boolean-container"/>');
	_parentDiv.append(this.layout);
	this.checkbox = $('<input type="checkbox" id= "' + _setting.id + '-id" name="' + _setting.id +'-name" />');
	this.layout.append(this.checkbox);
	this.label = $('<label class="text-font-normal font-color-subtitle" for="cb-camera-adjust">' + _setting.name + '</label>');
	this.layout.append(this.label);
	this.checkbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.checkbox.iCheck(_setting.value === true ? 'check' : 'uncheck');

	this.checkbox.on('ifChecked ifUnchecked', null, this, function (_event) {
		_setting.value = !_setting.value;
	});

	if (_setting.locked)
	{
		this.checkbox.attr('disabled', true);
	}

	// Tooltip
	this.label.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

BooleanSetting.prototype.unbindTooltip = function ()
{
	this.label.unbindTooltip();
}

var StringSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="string-container"/>');
	this.setting = _setting
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.input = $('<input type="text" class="title-font-big font-bold font-color-brother-name string-input"/>');
	this.input.val(_setting.value)
	this.input.on("change", function(){
		self.setting.value = self.input.val();
	});


	this.layout.append(this.input);

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.input.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

StringSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.input.unbindTooltip();
}

var KeybindSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="string-container line"/>');
	this.setting = _setting;
	this.parent = _parentDiv;
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title line">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.input = $('<input type="text" class="title-font-big font-bold font-color-brother-name string-input"/>');
	this.input.val(_setting.value);
	this.input.on("change", function(){
		self.setting.value = self.input.val();
	})

	this.input.on("click", function(){
		this.blur();
		self.createPopup(_parentDiv);
	})


	this.layout.append(this.input);

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.input.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

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
	})
	this.parent.mPopupDialog.addPopupDialogButton('Add', 'l-add-keybind-button', function (_dialog)
	{
		self.createChangeKeybindButton("");
	})
	this.parent.mPopupDialog.addPopupDialogButton('OK', 'l-ok-keybind-button', function (_dialog)
	{
		var buttons = $(".change-keybind-button")
		var result = ""
		for(var idx = 0; idx < buttons.length; idx++)
		{
			var text = $(buttons[idx]).findButtonText().html()
			if(text.length > 0)
			{
				result += text + "/"
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
}

KeybindSetting.prototype.createChangeKeybindScrollContainer = function(_dialog)
{
	this.mButtonContainer = _dialog.createList(2);
	var keybindArray = this.setting.value.split("/");
	for (var x = 0; x < keybindArray.length; x++)
	{
		this.createChangeKeybindButton(keybindArray[x]);
	}
}

KeybindSetting.prototype.createChangeKeybindButton = function(_name)
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
	}

	var callbackMouse = function(_event)
	{
		var key = MSU.Key.MouseMapJS[_event.button];
		if (key === undefined || key === null)
		{
			return;
		}
		setButton(key);
	}

	var setButton = function(_key)
	{
		var pressedKeys = MSU.Keybinds.getPressedKeysAsString(_key) + _key;
		selectedButton.changeButtonText(MSU.Key.sortKeyString(pressedKeys));
		toggle(selectedButton, true);
	}

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
	}
	button.on("click", function( _event ){
		var mainButton = this;
		var buttons = $(".change-keybind-button");
		buttons.map(function()
		{
			if (this != mainButton)
			{
				toggle($(this), true);
			}
		})
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
		button.remove();
		buttonLayout.remove();
		$(this).remove();
		destroyButtonLayout.remove();
		row.remove();
	}, 'delete-keybind-button', 2);
}

KeybindSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.input.unbindTooltip();
}

var RangeSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="range-container line"/>');
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title line">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.control = $('<div class="scale-control"/>');
	this.layout.append(this.control);

	this.slider = $('<input class="scale-slider" type="range"/>');
	this.slider.attr({
		min : _setting.min,
		max : _setting.max,
		step : _setting.step
	});
	this.slider.val(_setting.value);
	this.control.append(this.slider);

	this.label = $('<div class="scale-label text-font-normal font-color-subtitle">' + _setting.value + '</div>');
	this.control.append(this.label);

	this.layout.on("change", function ()
	{
		_setting.value = parseFloat(self.slider.val());
		self.label.text('' + _setting.value);
	});

	if (_setting.locked)
	{
		this.slider.attr('disabled', true);
	}

	// Tooltip
	this.control.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

RangeSetting.prototype.unbindTooltip = function ()
{
	this.control.unbindTooltip();
	this.title.unbindTooltip();
}

var EnumSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.setting = _setting;
	this.idx = _setting.array.indexOf(_setting.value);
	if (this.idx == -1)
	{
		console.error("EnumSetting Error");
	}

	this.layout = $('<div class="enum-container"/>');
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.button = this.layout.createTextButton(_setting.value, function ()
	{
		self.cycle(true);
	}, 'enum-button', 4);

	this.button.mousedown(function (event)
	{
		if (event.which === 3)
		{
			self.cycle(false);
		}
	});

	if (_setting.locked)
	{
		this.button.attr('disabled', true);
	}

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.button.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

EnumSetting.prototype.cycle = function (_forward)
{
	this.idx += _forward ? 1 : -1;
	if (this.idx == -1)
	{
		this.idx = this.setting.array.length - 1;
	}
	else if (this.idx == this.setting.array.length)
	{
		this.idx = 0;
	}
	this.setting.value = this.setting.array[this.idx];
	this.button.changeButtonText(this.setting.value);
}

EnumSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.button.unbindTooltip();
}

var DividerSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.layout = $('<div class="divider"/>');
	_parentDiv.append(this.layout);

	var line = $('<div class="gold-line"/>');
	this.layout.append(line);

	if (_setting.name != "")
	{
		this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
		this.layout.append(this.title);
		this.layout.css("height", "3.0rem");
		line.css("top", "3.0rem");
		this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	}
}

DividerSetting.prototype.unbindTooltip = function ()
{
	if ('title' in this)
	{
		this.title.unbindTooltip();
	}
}

ModSettingsScreen.prototype.onConnection = function (_handle)
{
	MSUUIScreen.prototype.onConnection.call(this, _handle);
	this.register($('.root-screen'));
}

ModSettingsScreen.prototype.createDIV = function (_parentDiv)
{
	var self = this;
	MSUUIScreen.prototype.createDIV.call(this, _parentDiv);
	this.mPopupDialog = null;
	this.mContainer = $('<div class="msu-settings-screen dialog-screen ui-control display-none opacity-none"/>');
	_parentDiv.append(this.mContainer);

	var dialogLayout = $('<div class="l-dialog-container"/>');
	this.mContainer.append(dialogLayout);
	this.mDialogContainer = dialogLayout.createDialog('Mod Settings', "Select a Mod From the List", null, true, 'dialog-1024-768');

	this.mPageTabContainer = $('<div class="l-tab-button-bar"/>')
	this.mDialogContainer.findDialogTabContainer().append(this.mPageTabContainer);

	//Footer Bar
	var footerButtonBar = $('<div class="l-button-bar"></div>');
	this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	var layout = $('<div class="l-cancel-button"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Cancel", function ()
	{
		self.notifyBackendCancelButtonPressed();
	}, '', 1);

	var layout = $('<div class="l-ok-button"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Save", function ()
	{
		self.notifyBackendSaveButtonPressed();
	}, '', 1);

	var content = this.mContainer.findDialogContentContainer();

	//Mod List Container
	var pagesListScrollContainer = $('<div class="l-list-container"/>');
	content.append(pagesListScrollContainer);
	this.mListContainer = pagesListScrollContainer.createList(2);
	this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	//Mod Page Container
	var modPageContainerLayout = $('<div class="l-page-container"/>');
	content.append(modPageContainerLayout);
	this.mModPageContainer = modPageContainerLayout.createList(2);
	this.mModPageScrollContainer = this.mModPageContainer.findListScrollContainer();
}

ModSettingsScreen.prototype.destroy = function ()
{
	this.mActiveSettings.forEach(function(setting)
	{
		setting.remove();
	});

	this.mActiveSettings = [];
	this.mModPanels = {};
	this.mChangedPanels = {};

	MSUUIScreen.prototype.destroy.call(this);
}

ModSettingsScreen.prototype.unbindTooltips = function ()
{
	this.mActiveSettings.forEach(function(setting)
	{
		setting.unbindTooltip();
	});

	MSUUIScreen.prototype.unbindTooltips.call(this);
}

ModSettingsScreen.prototype.destroyDIV = function ()
{
	if (this.mPopupDialog !== null)
	{
		this.mPopupDialog.destroyPopupDialog();
	}
	this.mPopupDialog = null;
	this.mDialogContainer.empty();
	this.mDialogContainer.remove();
	this.mDialogContainer = null;
	MSUUIScreen.prototype.destroyDIV.call(this);
}

ModSettingsScreen.prototype.hide = function()
{
	this.mDialogContainer.findDialogSubTitle().html("Select a Mod From the List");

	this.mActiveButton = null;

	this.mPageTabContainer.empty();
	this.mModPageScrollContainer.empty();
	this.mListScrollContainer.empty();

	MSUUIScreen.prototype.hide.call(this);
}

ModSettingsScreen.prototype.show = function (_data)
{
	this.mModPanels = _data;
	this.createModPanelList();

	MSUUIScreen.prototype.show.call(this,_data);
}

ModSettingsScreen.prototype.createModPanelList = function ()
{
	var self = this;
	this.mModPanels.forEach(function(mod)
	{
		self.addModPanelButtonToList(mod);
	});
}

ModSettingsScreen.prototype.addModPanelButtonToList = function (_mod)
{
	var self = this;
	var button = this.mListScrollContainer.createCustomButton(null, function (_button)
	{
		if (self.mActivePanelButton !== null)
		{
			self.mActivePanelButton.removeClass('is-active');
		}
		self.mActivePanelButton = _button;
		_button.addClass('is-active')

		self.switchToModPanel(_mod);
		self.switchToPage(_mod, _mod.pages[0])
	}, 'msu-button');

	button.text(_mod.name);
	button.removeClass('button');

}

ModSettingsScreen.prototype.switchToModPanel = function (_mod)
{
	this.mPageTabContainer.empty();
	var self = this;
	this.mContainer.findDialogSubTitle().html(_mod.name);

	var first = true;
	_mod.pages.forEach(function(page)
	{
		var layout = $('<div class="l-tab-button"/>');
		self.mPageTabContainer.append(layout);
		var button = layout.createTabTextButton(page.name, function ()
		{
			self.switchToPage(_mod, page);
		}, null, 'tab-button', 7);

		if (first)
		{
			button.addClass('is-selected');
			first = false;
		}
	});
}

ModSettingsScreen.prototype.switchToPage = function (_mod, _page)
{
	this.mActiveSettings.forEach(function(setting)
	{
		setting.unbindTooltip();
	});
	this.mActiveSettings = [];
	this.mModPageScrollContainer.empty();
	var self = this;
	_page.settings.forEach(function(setting)
	{
		self.mActiveSettings.push(new window[setting.type + "Setting"](_mod, _page, setting, self.mModPageScrollContainer));
	});
	this.mActiveSettings.forEach(function(setting)
	{
		if ('title' in setting)
		{
			while (setting.title.width() >= 341)
			{
				setting.title.css('font-size', (parseInt(setting.title.css('font-size').slice(0, -2)) - 1) + 'px')
			}
		}
	});
}

ModSettingsScreen.prototype.getChanges = function () // Could still be significantly improved/optimized
{
	var changes = {}
	this.mModPanels.forEach(function(modPanel)
	{
		changes[modPanel.id] = {};
		modPanel.pages.forEach(function(page)
		{
			page.settings.forEach(function(setting)
			{
				if (setting.type != "Divider" && !setting.locked)
				{
					changes[modPanel.id][setting.id] = setting.value;
				}
			});
		});
	});
	return changes;
}

ModSettingsScreen.prototype.notifyBackendCancelButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onCancelButtonPressed');
}

ModSettingsScreen.prototype.notifyBackendSaveButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onSaveButtonPressed', this.getChanges());
}

registerScreen("ModSettingsScreen", new ModSettingsScreen());
