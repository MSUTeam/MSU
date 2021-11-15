"use strict";

var ModSettingsScreen = function ()
{
	MSUUIScreen.call(this);

	this.mModPanels = {};
	this.mChangedPanels = {};
	this.mDialogContainer = null;
	this.mListContainer = null;
	this.mListScrollContainer = null;
	this.mBackgroundImage = null;
	this.mModPageScrollContainer = null;
	/*

	this.mModPanels = 
	{
		modID : 
		{
			name = "",
			settings = {
				settingID : 
				{
					type = "",
					name = "",
					value = 0,
					locked = false,
				}
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
	var dialogLayout = $('<div class="l-dialog-container out"/>');
	this.mContainer.append(dialogLayout);
	this.mDialogContainer = dialogLayout.createDialog('Mod Settings', "Select a Mod From the List", null, false, 'dialog-1024-768');

	//Background for main menu screen
	this.mBackgroundImage = this.mContainer.createImage(null, function (_image)
	{
	    _image.removeClass('display-none').addClass('display-block');
	    _image.fitImageToParent();
	}, function (_image)
	{
	    _image.fitImageToParent();
	}, 'display-none');

	//Footer Bar
	var footerButtonBar = $('<div class="l-button-bar out"></div>');
	this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	var layout = $('<div class="l-cancel-button out"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Cancel", function ()
	{
		self.notifyBackendCancelButtonPressed();
	}, '', 1);

	var layout = $('<div class="l-ok-button out"/>');
	footerButtonBar.append(layout);
	layout.createTextButton("Save", function ()
	{
		self.notifyBackendSaveButtonPressed();
	}, '', 1);

	//List Container
	var content = this.mContainer.findDialogContentContainer();
	content.addClass('out')
	var pagesListScrollContainer = $('<div class="l-list-container out"/>');
	content.append(pagesListScrollContainer);
	this.mListContainer = pagesListScrollContainer.createList(2);
	this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	var modPageContainerLayout = $('<div class="l-page-container out"/>')

	content.append(modPageContainerLayout);
    this.mModPageContainer = modPageContainerLayout.createList(4);
    this.mModPageScrollContainer = this.mModPageContainer.findListScrollContainer();
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
	this.mBackgroundImage.attr('src', Screens["MainMenuScreen"].mBackgroundImage.attr('src'));
	this.mModPanels = _data;
	this.mListScrollContainer.empty()
	this.createModPageList();

	MSUUIScreen.prototype.show.call(this,_data);
}

ModSettingsScreen.prototype.createModPageList = function ()
{
	for (var modID in this.mModPanels)
	{
		this.addModPageButtonToList(modID);
	}
}

ModSettingsScreen.prototype.addModPageButtonToList = function (_modID)
{
	var self = this;
	var result = $('<div class="l-row"/>');
	var buttonLayout = $('<div class="l-button"/>');
	result.append(buttonLayout);
	var button = buttonLayout.createTextButton(this.mModPanels[_modID].name, function ()
	{
		self.switchToMod(_modID);
	}, '', 4)
	this.mListScrollContainer.append(result);
}

ModSettingsScreen.prototype.switchToMod = function (_modID)
{
	this.mModPageScrollContainer.empty()
	console.error("switchToMod " + _modID);
	this.mContainer.findDialogSubTitle().html(this.mModPanels[_modID].name)
	for (var settingID in this.mModPanels[_modID].settings)
	{
		this["create" + this.mModPanels[_modID].settings[settingID].type + "Setting"](_modID, settingID, this.mModPageScrollContainer)
	}
}

ModSettingsScreen.prototype.createBooleanSetting = function (_modID, _settingID, _parentDiv)
{
	var layout = $('<div class="boolean-container out"/>');
	_parentDiv.append(layout);
	var checkbox = $('<input type="checkbox" id= "' + _settingID + '-id" name="' + _settingID +'-name" />');
	layout.append(checkbox);
	var label = $('<label class="text-font-normal font-color-subtitle" for="cb-camera-adjust">' + this.mModPanels[_modID].settings[_settingID].name + '</label>');
	layout.append(label);
	checkbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });
    checkbox.iCheck(this.mModPanels[_modID].settings[_settingID].value === true ? 'check' : 'uncheck')
    label.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _modID + "." + _settingID });
}

ModSettingsScreen.prototype.getChanges = function ()
{
	var changes = {}
	for (var modID in this.mModPanels)
	{
		changes[modID] = {}
		for (var settingID in this.mModPanels[modID].settings)
		{
			changes[modID][settingID] = this.mModPanels[modID].settings[settingID].value;
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
