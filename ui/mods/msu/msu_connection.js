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
		var args = arguments;
		modIDs.forEach(function(_modID, _i)
		{
			if (args[_i] != null)
			{
				modVersionData[_modID] = args[_i];
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
	var self = this;
	SQ.call(self.mSQHandle, "compareModVersions", _modVersionData, function(_ret)
	{
		self.showModUpdates(_ret)
	});
}

MSUConnection.prototype.showModUpdates = function (_modVersionData)
{
	var transformMarkdownToHTML = function(_text)
	{
		// Span-level formatting, applied to the text content of every line.
		// Order matters: links first (so URLs aren't mangled), then bold before
		// italic (so ** isn't eaten by the single-* rule), then the rest.
		var applyInline = function(_str)
		{
			return _str
				// [text](url) -> clickable element that opens in the browser
				.replace(/\[([^\[\]]+?)\]\(([^\)]+?)\)/g, '<span class="msu-popup-link" onclick="event.stopPropagation();openURL(\'$2\')">$1</span>')
				// **bold** / __bold__  -- use .+? so nested *italic* survives to the next pass
				.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
				.replace(/__(.+?)__/g, '<strong>$1</strong>')
				// *italic* / _italic_
				.replace(/\*([^*]+?)\*/g, '<em>$1</em>')
				.replace(/_([^_]+?)_/g, '<em>$1</em>')
				// ~~strikethrough~~
				.replace(/~~([^~]+?)~~/g, '<del>$1</del>')
				// `inline code`
				.replace(/`([^`]+?)`/g, '<code>$1</code>');
		};

		var asLines = _text.split(/\r?\n/);
		var ret = "";
		var listType = null; // "ul", "ol", or null -- tracks an open list block

		var closeList = function()
		{
			if (listType !== null) {
				ret += "</" + listType + ">";
				listType = null;
			}
		};

		for (var i = 0; i < asLines.length; i++)
		{
			var line = asLines[i].trim();

			// Horizontal rule: ---, ***, or ___ (3+ of the same, whole line)
			if (/^(-{3,}|\*{3,}|_{3,})$/.test(line)) {
				closeList();
				ret += "<hr>";
				continue;
			}

			// Headings: count leading #, cap at h6
			var hashCount = 0;
			while (hashCount < line.length && line[hashCount] == "#") hashCount++;
			if (hashCount > 0) {
				closeList();
				var level = Math.min(hashCount, 6);
				ret += "<h" + level + ">" + applyInline(line.slice(hashCount).replace(/^\s+/, "")) + "</h" + level + ">";
				continue;
			}

			// Unordered list item: "- ", "* ", "+ "
			var ulMatch = /^[-*+]\s+(.*)$/.exec(line);
			if (ulMatch) {
				if (listType !== "ul") { closeList(); ret += "<ul>"; listType = "ul"; }
				ret += "<li>" + applyInline(ulMatch[1]) + "</li>";
				continue;
			}

			// Ordered list item: "1. ", "2. ", ... (requires a space, so "1.5x" is safe)
			var olMatch = /^\d+\.\s+(.*)$/.exec(line);
			if (olMatch) {
				if (listType !== "ol") { closeList(); ret += "<ol>"; listType = "ol"; }
				ret += "<li>" + applyInline(olMatch[1]) + "</li>";
				continue;
			}

			// Blockquote: "> "
			var bqMatch = /^>\s?(.*)$/.exec(line);
			if (bqMatch) {
				closeList();
				ret += "<blockquote>" + applyInline(bqMatch[1]) + "</blockquote>";
				continue;
			}

			// Plain or blank line: close any open list, emit text with a <br> break
			closeList();
			ret += applyInline(line) + "<br>";
		}
		closeList(); // close a list that runs to the end of the text

		return ret;
	};

	var self = this;
	var numUpdates = 0;
	var hasNew = false;
	var numMods = Object.keys(_modVersionData).length
	var objectsToAdd = [];
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

		$.each(updateInfo.sources, function (_, _source) {
			var container = $('<div class="l-source-button"/>').appendTo(versionRow);
			container.click(function (e) { e.stopPropagation(); });
			var button = container.createImageButton(Path.GFX + "mods/msu/logos/" + _source.icon + "-32.png", function ()
			{
				openURL(_source.URL);
			});
		})

		// Add update patch notes, with a click handler to show/hide them
		if (updateInfo.changes)
		{
			var neatText = transformMarkdownToHTML(updateInfo.changes);
			var patchNotesInfoRow = $('<div class="description-font-normal font-color-description">Click to hide patch notes</div>')
				.appendTo(modInfoContainer);
			var descriptionRow = $('<div class="msu-mod-info-description description-font-normal font-color-description"/>')
				.html(neatText)
				.appendTo(modInfoContainer);
			modInfoContainer.click(function(){
				if (descriptionRow.html() == ""){
					patchNotesInfoRow.text("Click to hide patch notes");
					descriptionRow.html(neatText);
				}
				else {
					patchNotesInfoRow.text("Click to show patch notes");
					descriptionRow.html("");
				}
			})
		}
		// New patches up top, old patches bottom
		if (updateInfo.isNew)
		{
			var isNewSymbol = $('<div class="msu-popup-is-new-symbol"/>')
				.appendTo(modInfoContainer);
			objectsToAdd.push(modInfoContainer);
			hasNew = true;
		}
		else
		{
			objectsToAdd.splice(0, 0, modInfoContainer);
		}
	});

	if (numUpdates == 0)
		return;

	$.each(objectsToAdd, function(_, _modInfoContainer){
		MSU.Popup.addListContent(_modInfoContainer)
	})
	delete objectsToAdd;

	var checkText = "" + numMods + (numMods == 1 ? " mod" : " mods") + " checked<br>";
	checkText += numUpdates + (numUpdates == 1 ? " update" : " updates");
	MSU.Popup.setSmallContainerInfo(checkText);
	MSU.Popup.setState(hasNew ? MSU.Popup.mState.Full : MSU.Popup.mState.Small);
}

// this should be reworked if/when we added JS side settings callbacks
MSUConnection.prototype.onVanillaBBCodeUpdated = function (_bool)
{
	var elements = document.getElementsByTagName('link');
	for (var i = 0; i < elements.length; i++)
	{
		if (elements[i].href.indexOf("ui/mods/msu/css/vanilla_font_unbold.css") != -1)
		{
			elements[i].disabled = _bool;
			break;
		}
	}
}

registerScreen("MSUConnection", new MSUConnection());
