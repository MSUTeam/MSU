"use strict";

var ModSettingsScreen = function ()
{
	MSUUIScreen.call(this);

	this.mModPanels = {};
	this.mChangedPanels = {};
	this.mDialogContainer = null;
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

// Inheritance in JS
ModSettingsScreen.prototype = Object.create(MSUUIScreen.prototype)
Object.defineProperty(ModSettingsScreen.prototype, 'constructor', {
    value: ModSettingsScreen,
    enumerable: false,
    writable: true });

ModSettingsScreen.prototype.onConnection = function (_handle)
{
	MSUUIScreen.prototype.onConnection.call(this, _handle);
	this.register($('.root-screen'));
}

ModSettingsScreen.prototype.createDIV = function (_parentDiv)
{
	var self = this;
	MSUUIScreen.prototype.createDIV.call(this, _parentDiv);
	var dialogLayout = $('<div class="l-dialog-container"/>');
	this.mContainer.append(dialogLayout);
	this.mDialogContainer = dialogLayout.createDialog('Mod Settings', null, null, false, 'dialog-1024-768');

	//Footer Bar
	var footerButtonBar = $('<div class="l-button-bar"></div>');
	this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	var layout = $('<div class="l-cancel-button"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Cancel", function ()
	{
	    self.notifyBackendCancelButtonPressed();
	}, '', 4);

	var layout = $('<div class="l-ok-button"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Save", function ()
	{
	    self.notifyBackendSaveButtonPressed();
	}, '', 4);

	var content = this.mContainer.findDialogContentContainer();
	var modPageListContainerLayout = $('<div class="l-list-container"></div>');
	content.append(modPageListContainerLayout);
	this.mListContainer = modPageListContainerLayout.createList(2);
	this.mListScrollContainer = this.mListContainer.findListScrollContainer();
}

ModSettingsScreen.prototype.destroyDIV = function ()
{
	this.mDialogContainer.empty();
	this.mDialogContainer.remove();
	this.mDialogContainer = null;

	MSUUIScreen.prototype.destroyDIV.call(this);
}

ModSettingsScreen.prototype.show = function (_data)
{
	this.mModPanels = _data;
	this.createModPanels();

	MSUUIScreen.prototype.show.call(this,_data);
}

ModSettingsScreen.prototype.createModPanels = function ()
{

}

ModSettingsScreen.prototype.getChanges = function ()
{
	var changes = {}
	for (var modID in this.mModPanels)
	{
		changes[modID] = {}
		for (var settingID in this.mModPanels[modID]["settings"])
		{
			console.error(modID + " | " + settingID + " | ")
			console.error(this.mModPanels[modID]["settings"][settingID]["value"])
			changes[modID][settingID] = this.mModPanels[modID]["settings"][settingID]["value"];
		}
	}
	return changes;
}

ModSettingsScreen.prototype.notifyBackendCancelButtonPressed = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onCancelButtonPressed');
	}
}

ModSettingsScreen.prototype.notifyBackendSaveButtonPressed = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onSaveButtonPressed', this.getChanges());
	}
}

// ModSettingsScreen.prototype.showBackgroundImage = function ()
// {
// }




registerScreen("ModSettingsScreen", new ModSettingsScreen());
