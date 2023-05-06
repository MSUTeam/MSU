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

MSUConnection.prototype.setInputDenied = function (_bool)
{
	SQ.call(this.mSQHandle, "setInputDenied", _bool);
}

MSUConnection.prototype.getUpdateCheckPromise = function (_updateURL)
{
	var ret = $.Deferred();
	var xhttp = new XMLHttpRequest();
	xhttp.onloadend = function()
	{
		if (this.status == 200)
		{
			ret.resolve(JSON.parse(this.responseText)); // will (probably) need adjustment if we add more update sources (other than github)
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

MSUConnection.prototype.checkForModUpdates = function (_modsWithUpdateData)
{
	var self = this;
	var modIDs = [];
	var promises = [];
	$.each(_modsWithUpdateData, function (_id, _version)
	{
		modIDs.push(_id);
		promises.push(self.getUpdateCheckPromise(_version));
	})
	$.when.apply($, promises).done(function()
	{
		var modVersionData = {};
		// var modVersionDataForBackend = {};
		var args = arguments;
		modIDs.forEach(function(_modID, _i)
		{
			if (args[_i] != null)
			{
				modVersionData[_modID] = args[_i];
				// modVersionDataForBackend[_modID] = args[_i].tag_name;
			}
		})
		self.compareModVersions(modVersionData)
	}).fail(function()
	{
		console.error("Something went wrong with MSU Update checks");
	});
}

MSUConnection.prototype.compareModVersions = function (_modVersionData)
{
	MSU.Utils.Timer("popup")
	var self = this;
	SQ.call(self.mSQHandle, "compareModVersions", _modVersionData, function(_ret)
	{
		MSU.Utils.Timer("popup").stop();
		self.showModUpdates(_ret)
	});
}

MSUConnection.prototype.showModUpdates = function (_modVersionData)
{
	var self = this;
	var numUpdates = 0;
	var numMods = Object.keys(_modVersionData).length
	$.each(_modVersionData, function (_modID, _modInfo)
	{
		if (_modInfo.UpdateInfo === undefined)
			return;
		numUpdates++;
		var updateInfo = _modInfo.UpdateInfo;
		var modInfoContainer = $('<div class="msu-mod-info-container"/>');
		var nameRow = $('<div class="msu-mod-name-row title title-font-big font-bold font-color-title">' + updateInfo.name + '</div>')
			.appendTo(modInfoContainer)

		var versionRow = $('<div class="msu-mod-version-row">')
			.appendTo(modInfoContainer)

		var colorFromIdx = 0;
		if (updateInfo.updateType != "MAJOR")
		{
			colorFromIdx = updateInfo.availableVersion.indexOf('.') + 1;
		}
		if (updateInfo.updateType == "PATCH")
		{
			colorFromIdx = updateInfo.availableVersion.indexOf('.', colorFromIdx + 1) + 1;
		}
		var start = updateInfo.availableVersion.slice(0, colorFromIdx);
		var coloredSpan = '<span style="color:red;">' + updateInfo.availableVersion.slice(colorFromIdx) + '</span>';
		versionRow.append($('<div class="msu-mod-version-info text-font-normal">' + updateInfo.currentVersion + ' => ' + start + coloredSpan + ' (Update Available)</div>'));

		if ("GitHub" in updateInfo.sources)
		{
			var githubContainer = $('<div class="l-github-button"/>')
				.appendTo(versionRow);
			var githubButton = githubContainer.createImageButton(Path.GFX + "mods/msu/logos/github-32.png", function ()
			{
				openURL(updateInfo.sources.GitHub);
			});
		}
		if ("NexusMods" in updateInfo.sources)
		{
			var nexusModsContainer = $('<div class="l-nexusmods-button"/>')
				.appendTo(versionRow);
			nexusModsContainer.createImageButton(Path.GFX + "mods/msu/logos/nexusmods-32.png", function ()
			{
				openURL(updateInfo.sources.NexusMods);
			});
		}

		// Add update text
		if (_modInfo.body.length > 0)
		{
			var descriptionRow = $('<div class="msu-mod-info-description description-font-normal font-color-description"/>')
				.html(_modInfo.body.replace(/(?:\r\n|\r|\n)/g, '<br>'))
				.appendTo(modInfoContainer)
		}
		MSU.Popup.addListContent(modInfoContainer)
	});

	var checkText = "" + numMods + (numMods == 1 ? " mod" : " mods") + " checked<br>";
	checkText += numUpdates + (numUpdates == 1 ? " update" : " updates");
	MSU.Popup.setSmallContainerInfo(checkText);
	MSU.Popup.setState(MSU.Popup.mStates.Small);
}

registerScreen("MSUConnection", new MSUConnection());
