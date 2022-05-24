::MSU.Class.TooltipsSystem <- class extends ::MSU.Class.System
{
	Mods = null;

	constructor()
	{
		base.constructor(::MSU.SystemID.Tooltips);
		this.Mods = {};
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

	function getTooltip( _modID, _identifier )
	{
		local fullKey = split(_identifier, ".");
		local currentTable = this.Mods[_modID];
		for (local i = 0; i < fullKey.len(); ++i)
		{
			currentTable = currentTable[fullKey[i]];
		}
		return currentTable;
	}
}
