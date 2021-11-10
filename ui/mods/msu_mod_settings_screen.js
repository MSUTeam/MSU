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

var ModSettingsModule = function (_screen)
{
	this.mParent = _screen;
}



Object.setPrototypeOf(ModSettingsScreen.prototype, MSUUIScreen.prototype);

ModSettingsScreen.prototype.createDIV = function (_parentDiv)
{
	var self = this;
	this.mContainer = $('<div class="flexbox display-none opacity-full"');
	for (modID in this.mModPanels)
	{

	}
}

var 