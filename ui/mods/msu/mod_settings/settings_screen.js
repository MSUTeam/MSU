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

};

// Inheritance in JS
ModSettingsScreen.prototype = Object.create(MSUUIScreen.prototype);
Object.defineProperty(ModSettingsScreen.prototype, 'constructor', {
	value: ModSettingsScreen,
	enumerable: false,
	writable: true
});

ModSettingsScreen.prototype.onConnection = function (_handle)
{
	MSUUIScreen.prototype.onConnection.call(this, _handle);
	this.register($('.root-screen'));
};

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

	this.mPageTabContainer = $('<div class="l-tab-button-bar"/>');
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

	layout = $('<div class="l-ok-button"/>');
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
};

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
};

ModSettingsScreen.prototype.unbindTooltips = function ()
{
	this.mActiveSettings.forEach(function(setting)
	{
		setting.unbindTooltip();
	});

	MSUUIScreen.prototype.unbindTooltips.call(this);
};

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
};

ModSettingsScreen.prototype.hide = function()
{
	this.mDialogContainer.findDialogSubTitle().html("Select a Mod From the List");

	this.mActiveButton = null;

	this.mPageTabContainer.empty();
	this.mModPageScrollContainer.empty();
	this.mListScrollContainer.empty();

	MSUUIScreen.prototype.hide.call(this);
};

ModSettingsScreen.prototype.show = function (_data)
{
	this.mModPanels = _data;
	this.createModPanelList();
	MSUUIScreen.prototype.show.call(this,_data);
	if(_data.length != 0)
	{
		this.mListScrollContainer[0].firstElementChild.click();
	}
};

ModSettingsScreen.prototype.createModPanelList = function ()
{
	var self = this;
	this.mModPanels.forEach(function(mod)
	{
		self.addModPanelButtonToList(mod);
	});
};

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
		_button.addClass('is-active');

		self.switchToModPanel(_mod);
		self.switchToPage(_mod, _mod.pages[0]);
	}, 'msu-button');

	button.text(_mod.name);
	button.removeClass('button');
};

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
};

ModSettingsScreen.prototype.switchToPage = function (_mod, _page)
{
	this.mActiveSettings.forEach(function(element)
	{
		element.unbindTooltip();
	});
	this.mActiveSettings = [];
	this.mModPageScrollContainer.empty();
	var self = this;
	_page.settings.forEach(function(element)
	{
		self.mActiveSettings.push(new window[element.type + "Setting"](_mod, _page, element, self.mModPageScrollContainer));
	});
	this.mActiveSettings.forEach(function(element)
	{
		if ('title' in element)
		{
			while (element.title.width() >= 341)
			{
				element.title.css('font-size', (parseInt(element.title.css('font-size').slice(0, -2)) - 1) + 'px');
				if (parseInt(element.title.css('font-size').slice(0, -2)) <= 1)
				{
					console.error("Setting with ID " + element.data.id + ": Font size of title too small! Stopping font size adjustment.");
					return;
				}
			}
		}
	});
};

ModSettingsScreen.prototype.getChanges = function () // Could still be significantly improved/optimized
{
	var changes = {};
	this.mModPanels.forEach(function(modPanel)
	{
		changes[modPanel.id] = {};
		modPanel.pages.forEach(function(page)
		{
			page.settings.forEach(function(element)
			{
				if ("IsSetting" in element.data && !element.locked)
				{
					changes[modPanel.id][element.id] = element.value;
				}
			});
		});
	});
	return changes;
};

ModSettingsScreen.prototype.notifyBackendCancelButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onCancelButtonPressed');
};

ModSettingsScreen.prototype.notifyBackendSaveButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onSaveButtonPressed', this.getChanges());
};

ModSettingsScreen.prototype.notifyBackendSettingButtonPressed = function (_data)
{
	SQ.call(this.mSQHandle, 'onSettingPressed', _data);
};

registerScreen("ModSettingsScreen", new ModSettingsScreen());
