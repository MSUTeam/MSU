{
	var createMainMenuButtons = MainMenuModule.prototype.createMainMenuButtons;
	MainMenuModule.prototype.createMainMenuButtons = function ()
	{
		createMainMenuButtons.call(this);
		this.addModOptionsButton();
	}

	MainMenuModule.prototype.addModOptionsButton = function ()
	{
		var self = this;

		row = $('<div class="row"></div>');
		var temp = this.mButtonContainer.find('.divider')
		temp.before(row);
		buttonLayout = $('<div class="l-center"></div>');
		row.append(buttonLayout);
		button = buttonLayout.createTextButton("Mod Options", function ()
		{
			self.notifyBackendModOptionsButtonPressed();
		}, '', 4);
	}

	Screens["MainMenuScreen"].getModule("MainMenuModule").addModOptionsButton();

	MainMenuModule.prototype.notifyBackendModOptionsButtonPressed = function()
	{
		SQ.call(this.mSQHandle, 'onModOptionsButtonPressed');
	}

	var createWorldMapMenuButtons = MainMenuModule.prototype.createWorldMapMenuButtons;
	MainMenuModule.prototype.createWorldMapMenuButtons = function ()
	{
		createWorldMapMenuButtons.call(this);
		this.addModOptionsButton();
	}
}