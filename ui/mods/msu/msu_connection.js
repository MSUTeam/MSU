"use strict";

var MSU = {}

var MSUConnection = function ()
{
	MSUBackendConnection.call(this);
	this.mModSettings = {};
}

MSUConnection.prototype = Object.create(MSUBackendConnection.prototype)
Object.defineProperty(MSUConnection.prototype, 'constructor', {
	value: MSUConnection,
	enumerable: false,
	writable: true });

MSUConnection.prototype.setCustomKeybinds = function (_keybinds)
{
	console.error("setCustomKeybinds:\n" + JSON.stringify(_keybinds))
	//TODO
	// MSU.GlobalKeyHandler.addHandlerFunction("2+shift", "testKeybind", function(_event){
	// 	console.error("Testing keybind")
	// })
	// MSU.CustomKeybinds.setFromSQ(_keybinds);
	//test
}

MSUConnection.prototype.setSettings = function (_settings)
{
	this.mModSettings = _settings;
}

MSUConnection.prototype.updateSetting = function (_setting)
{
	this.mModSettings[_setting.mod][_setting.setting] = _setting.value;
}

var getModSettingValue = function (_modID, _settingID)
{
	return Screens["MSUConnection"].mModSettings[_modID][_settingID];
}

var setModSettingValue = function (_modID, _settingID, _value)
{
	Screens["MSUConnection"].setModSettingValue(_modID, _settingID, _value);
}

MSUConnection.prototype.setModSettingValue = function (_modID, _settingID, _value)
{
	this.mModSettings[_modID][_settingID] = _value;
	var out = {
		mod : _modID,
		setting : _settingID,
		value : _value
	}
	this.notifyBackendUpdateSetting(out);
}

MSUConnection.prototype.notifyBackendUpdateSetting = function(_data)
{
	SQ.call(this.mSQHandle, "updateSettingJS", _data);
}

registerScreen("MSUConnection", new MSUConnection());
