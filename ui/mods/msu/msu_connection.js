var MSUConnection = function ()
{
	MSUBackendConnection.call(this);
};

MSUConnection.prototype = Object.create(MSUBackendConnection.prototype);
Object.defineProperty(MSUConnection.prototype, 'constructor', {
	value: MSUConnection,
	enumerable: false,
	writable: true
});

MSUConnection.prototype.onQuerySettingsData = function (_data)
{
	MSU.Keybinds.setKeybinds(_data.keybinds);
	Screens.ModSettingsScreen.setSettings(_data.settings);
};

MSUConnection.prototype.removeKeybind = function (_keybind)
{
	MSU.Keybinds.removeKeybind(_keybind.modID, _keybind.id);
};

MSUConnection.prototype.addKeybind = function (_keybind)
{
	MSU.Keybinds.addKeybindFromSQ(_keybind.modID, _keybind.id, _keybind.keyCombinations);
};

MSUConnection.prototype.clearKeys = function ()
{
	MSU.Keybinds.PressedKeys = {};
}

MSUConnection.prototype.checkMSUGithubVersion = function ()
{
	var checkMSUUpdate = new XMLHttpRequest();
	var self = this;
	checkMSUUpdate.addEventListener("load", function()
	{
		self.notifyBackendGetMSUGithubVersion(JSON.parse(this.responseText).tag_name);
	});
	checkMSUUpdate.open("GET", 'https://api.github.com/repos/MSUTeam/mod_MSU/releases/latest');
	checkMSUUpdate.send();
}

MSUConnection.prototype.notifyBackendGetMSUGithubVersion = function (_version)
{
	SQ.call(this.mSQHandle, "getMSUGithubVersion", _version);
}

registerScreen("MSUConnection", new MSUConnection());
