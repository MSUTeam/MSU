::MSU.Class.AbstractKeybind <- class
{
	KeyCombinations = null;
	Mod = null;
	ID = null;
	Name = null;
	Description = null;

	constructor( _modID, _id, _keyCombinations, _name = null )
	{
		if (_name == null) _name = _id;
		if (!(_modID in ::MSU.System.Keybinds.KeybindsByMod))
		{
			::logError(::MSU.Error.ModNotRegistered(_modID));
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		::MSU.requireString(_modID, _id, _keyCombinations, _name);

		this.Mod = ::MSU.System.Registry.getMod(_modID);
		this.ID = _id;
		this.KeyCombinations = split(::MSU.Key.sortKeyCombinationsString(_keyCombinations), "/");
		this.Name = _name;
		this.Description = "";
	}

	function setDescription( _description )
	{
		this.Description = _description;
	}

	function getDescription()
	{
		return this.Description;
	}

	function getKeyCombinations()
	{
		if (this.KeyCombinations.len() == 0) return "";
		return this.KeyCombinations.reduce(@(_a, _b) _a + "/" + _b);
	}

	function getRawKeyCombinations()
	{
		return this.KeyCombinations;
	}

	function getID()
	{
		return this.ID;
	}

	function getName()
	{
		return this.Name;
	}

	function getMod()
	{
		return this.Mod;
	}

	function makeSetting()
	{
		local setting = ::MSU.Class.KeybindSetting(this.getID(), this.getKeyCombinations(), this.getName());
		setting.setDescription(this.getDescription());
		setting.addAfterChangeCallback(function(_oldValue)
		{
			::MSU.System.Keybinds.update(this.getMod().getID(), this.getID());
		});
		return setting;
	}

	function tostring()
	{
		return format("ModID: %s, ID: %s, KeyCombinations: %s", this.getMod().getID(), this.getID(), this.getKeyCombinations());
	}

	function _tostring()
	{
		return this.tostring();
	}
}
