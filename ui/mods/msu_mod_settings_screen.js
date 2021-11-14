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

ModSettingsScreen.prototype = Object.create(MSUUIScreen.prototype)
Object.defineProperty(ModSettingsScreen.prototype, 'constructor', {
    value: ModSettingsScreen,
    enumerable: false, // so that it does not appear in 'for in' loop
    writable: true });

ModSettingsScreen.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
	this.register($('.root-screen'));
}

ModSettingsScreen.prototype.createDIV = function (_parentDiv)
{
	MSUUIScreen.prototype.createDIV.call(this, _parentDiv);
    this.mBackgroundImage = this.mContainer.createImage(null, function (_image)
	{
        _image.removeClass('display-none').addClass('display-block');
        _image.fitImageToParent();
    }, function (_image)
	{
        _image.fitImageToParent();
    }, 'display-none');
}

ModSettingsScreen.prototype.destroyDIV = function ()
{
	MSUUIScreen.prototype.destroyDIV.call(this);

}

registerScreen("ModSettingsScreen", new ModSettingsScreen());
