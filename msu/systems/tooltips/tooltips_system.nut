::MSU.Class.TooltipsSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	ImageKeywordMap = null;

	constructor()
	{
		base.constructor(::MSU.SystemID.Tooltips);
		this.Mods = {};
		this.ImageKeywordMap = {};
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		_mod.Tooltips = ::MSU.Class.TooltipsModAddon(_mod);
		this.Mods[_mod.getID()] <- {};
	}

	function setTooltips( _modID, _tooltipTable )
	{
		this.__addTable(this.Mods[_modID], _tooltipTable);
	}

	function __addTable( _currentTable, _tableToAdd )
	{
		foreach (key, value in _tableToAdd)
		{
			if (!(key in _currentTable) && typeof value == "table")
			{
				_currentTable[key] <- {};
				this.__addTable(_currentTable[key], value);
			}
			else
			{
				_currentTable[key] <- value;
			}
		}
	}

	function setTooltipImageKeywords(_modID, _tooltipTable)
	{
		local identifier, path;
		foreach (imagePath, id in _tooltipTable)
		{
			imagePath = "coui://gfx/" + imagePath;
			if (imagePath in this.ImageKeywordMap)
			{
				::logError(format("ImagePath %s already set by mod %s with tooltipID %s! Skipping this image keyword.", imagePath, _modID, id));
				continue;
			}
			identifier = {mod = _modID, id = id};
			this.ImageKeywordMap[imagePath] <- identifier;
		}
	}

	function passTooltipIdentifiers()
	{
		::MSU.UI.JSConnection.passTooltipIdentifiers(this.ImageKeywordMap);
	}

	function getTooltip( _modID, _identifier )
	{
		local arr = split(_identifier, "+");
		local fullKey = split(arr[0], ".");
		local extraData;
		switch (arr.len())
		{
			case 1:
				break;

			case 2:
				extraData = arr[1];
				break;

			default:
				arr.slice(1).reduce(@(a, b) a + "+" + b);
				break;
		}

		local currentTable = this.Mods[_modID];
		for (local i = 0; i < fullKey.len(); ++i)
		{
			local currentKey = fullKey[i];
			currentTable = currentTable[currentKey];
		}
		return {
			Tooltip = currentTable,
			Data = extraData
		};
	}
}
