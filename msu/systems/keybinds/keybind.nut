this.MSU.Class.Keybind <- class
{
	KeyCombinations = null;
	ModID = null;
	ID = null;
	Name = null;
	Description = null;
	KeyState = null;

	constructor( _modID, _id, _keyCombinations, _name = null, _keyState = null )
	{
		if (_name == null) _name = _id;
		if (_keyState == null) _keyState = ::MSU.Key.KeyState.Release;

		if (!(_modID in this.MSU.System.Keybinds.KeybindsByMod)) throw ::Exception.ModNotRegistered;

		::MSU.requireString(_modID, _id, _keyCombinations, _name);

		this.ModID = _modID;
		this.ID = _id;
		this.KeyCombinations = split(::MSU.Key.sortKeyCombinationsString(_keyCombinations), "/");
		this.Name = _name;
		this.KeyState = _keyState;
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

	function callOnKeyState( _keyState )
	{
		if (this.KeyState == ::MSU.Key.KeyState.All)
		{
			return true;
		}
		return _keyState == this.KeyState;
	}

	function getKeyCombatinations()
	{
		return this.KeyCombinations.reduce(@(a,b) a + "/" + b);
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

	function getModID()
	{
		return this.ModID;
	}

	function getEnvironment()
	{
		return this.Environment;
	}

	function makeSetting()
	{
		local setting = this.MSU.Class.StringSetting(this.getID(), this.getKeyCombatinations(), this.getName());
		setting.setDescription(this.getDescription());
		local self = this.weakref();
		setting.addCallback(function(_data)
		{
			::MSU.System.Keybinds.update(self.ref().getModID(), self.ref().getID(), _data);
		});
		return setting;
	}
}
