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
		return (_keyState & this.KeyState) != 0;
	}

	function getKeyState()
	{
		return this.KeyState;
	}

	function getKeyCombinations()
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

	function makeSetting()
	{
		local setting = this.MSU.Class.KeybindSetting(this.getID(), this.getKeyCombinations(), this.getName());
		setting.setDescription(this.getDescription());
		local self = this.weakref();
		setting.addCallback(function(_data)
		{
			::MSU.System.Keybinds.update(self.ref().getModID(), self.ref().getID(), _data);
		});
		return setting;
	}

	function _tostring()
	{
		return format("ModID: %s, ID: %s, KeyCombinations: %s, keyState: %s", this.getModID(), this.getID(), this.getKeyCombinations(), this.getKeyState().tostring());
	}
}
