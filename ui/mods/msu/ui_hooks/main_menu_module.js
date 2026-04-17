MSU.Hooks.MainMenuModule_createMainMenuButtons = MainMenuModule.prototype.createMainMenuButtons;
MainMenuModule.prototype.createMainMenuButtons = function ()
{
	MSU.Hooks.MainMenuModule_createMainMenuButtons.call(this);
	this.addModOptionsButton();
};

MainMenuModule.prototype.addModOptionsButton = function()
{
	var self = this;

	var row = $('<div class="row"></div>');
	var temp = this.mButtonContainer.find('.divider');
	temp.before(row);
	var buttonLayout = $('<div class="l-center"></div>');
	row.append(buttonLayout);
	buttonLayout.createTextButton("Mod Options", function ()
	{
		self.notifyBackendModOptionsButtonPressed();
	}, '', 4);
}

MainMenuModule.prototype.notifyBackendModOptionsButtonPressed = function()
{
	SQ.call(this.mSQHandle, 'onModOptionsButtonPressed');
};

MSU.Hooks.MainMenuModule_createWorldMapMenuButtons = MainMenuModule.prototype.createWorldMapMenuButtons;
MainMenuModule.prototype.createWorldMapMenuButtons = function (_isSavingAllowed, _seed)
{
	MSU.Hooks.MainMenuModule_createWorldMapMenuButtons.call(this, _isSavingAllowed, _seed);
	this.addModOptionsButton();
};

MSU.Hooks.MainMenuModule_createTacticalMapMenuButtons = MainMenuModule.prototype.createTacticalMapMenuButtons;
MainMenuModule.prototype.createTacticalMapMenuButtons = function (_isRetreatAllowed, _isQuitAllowed, _quitText)
{
	MSU.Hooks.MainMenuModule_createTacticalMapMenuButtons.call(this, _isRetreatAllowed, _isQuitAllowed, _quitText);
	this.addModOptionsButton();
};

MSU.Hooks.LoadCampaignMenuModule_addCampaignEntryToList = LoadCampaignMenuModule.prototype.addCampaignEntryToList;
LoadCampaignMenuModule.prototype.addCampaignEntryToList = function (_data)
{
	MSU.Hooks.LoadCampaignMenuModule_addCampaignEntryToList.call(this, _data);
	if (_data.isIncompatibleVersion && _data.MSU_ModIncompatibility.length !== 0)
	{
		var entry = this.mListScrollContainer.find('.ui-control.campaign:last');
		console.error("binding tooltip to " + entry);
		entry.bindTooltip({ contentType: "msu-generic", modId: MSU.ID, elementId: "LoadCampaign", errors: _data.MSU_ModIncompatibility})
	}
};
