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

MSUConnection.prototype.queryData = function (_data)
{
	this.setCustomKeybinds(_data.keybinds);
	this.setSettings(_data.settings);
}

MSUConnection.prototype.setCustomKeybinds = function (_keybinds)
{
	var self = this;
	_keybinds.forEach(function(keybind)
	{
		self.addKeybind(keybind);
	});
}

MSUConnection.prototype.removeKeybind = function (_keybind)
{
	MSU.Keybinds.removeKeybind(_keybind.modID, _keybind.id)
}

MSUConnection.prototype.addKeybind = function (_keybind)
{
	MSU.Keybinds.addKeybindFromSQ(_keybind.modID, _keybind.id, _keybind.keyCombinations);
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
