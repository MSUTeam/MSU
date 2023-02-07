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

MSUConnection.prototype.getUpdateCheckPromise = function (_updateURL)
{
	var ret = $.Deferred();
	var xhttp = new XMLHttpRequest();
	xhttp.onloadend = function()
	{
		if (this.status == 200)
		{
			ret.resolve(JSON.parse(this.responseText).tag_name); // will (probably) need adjustment if we add more update sources (other than github)
			return;
		}
		ret.resolve(null);
	}
	xhttp.ontimeout = function()
	{
		ret.resolve(null);
	}
	xhttp.open('GET', _updateURL);
	xhttp.send();
	return ret;
}

MSUConnection.prototype.checkForModUpdates = function (_mods)
{
	var self = this;
	var modIDs = [];
	var promises = [];
	$.each(_mods, function (_id, _version)
	{
		modIDs.push(_id);
		promises.push(self.getUpdateCheckPromise(_version));
	})
	$.when.apply($, promises).done(function()
	{
		var modVersions = {};
		var args = arguments
		modIDs.forEach(function(_modID, _i)
		{
			if (args[_i] != null) modVersions[_modID] = args[_i]
		})
		self.notifyBackendReceivedModVersions(modVersions);
	}).fail(function()
	{
		console.error("Something went wrong with MSU Update checks");
	});
}

MSUConnection.prototype.notifyBackendReceivedModVersions = function (_modVersions)
{
	SQ.call(this.mSQHandle, "receiveModVersions", _modVersions);
}

MSUConnection.prototype.setTooltipImageKeywords = function (_table)
{
	$.each(_table, function(_key, _value){
		MSU.NestedTooltip.KeyImgMap[_key] = _value;
	})
}


registerScreen("MSUConnection", new MSUConnection());
