"use strict";

var ModSettingsScreen = function ()
{
	MSUUIScreen.call(this);

	this.mModPanels = {};
	/*

	this.mModPanels = 
	{
		modID : 
		{
			settingID : 
			{
				type = "",
				name = "",
				value = 0,
				locked = false,

			}
		}
	}
	*/

}
Object.setPrototypeOf(ModSettingsScreen.prototype, MSUUIScreen);
ModSettingsScreen.prototype.onConnection = function (_handle)
{
	MSUUIScreen.prototype.onConnection.call(this, _handle);
	this.register($('.root-screen'));
}

ModSettingsScreen.prototype.createDIV = function (_parentDiv)
{
	MSUUIScreen.prototype.createDIV.call(this, _parentDiv);
	this.unregister();
}

ModSettingsScreen.prototype.destroyDIV = function ()
{
	MSUUIScreen.prototype.destroyDIV.call(this);
}

registerScreen("ModSettingsScreen", new ModSettingsScreen());
