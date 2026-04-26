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
