this.MSU.Class.Keybind <- class
{
	Key = null;
	ModID = null;
	ID = null;
	Name = null;
	Description = null;
	KeyState = null;

	constructor( _modID, _id, _key, _name = null, _keyState = null )
	{
		if (_name == null) _name = _id;
		if (_keyState == null) _keyState = ::MSU.Key.KeyState.Release;

		if (!(_modID in this.MSU.System.Keybinds.Mods)) throw ::Exception.ModNotRegistered;
		if (!(_keyState in ::MSU.Key.KeyState)) throw ::Exception.KeyNotFound;

		::MSU.requireString(_modID, _id, _key, _name);

		this.ModID = _modID;
		this.ID = _id;
		this.Key = ::MSU.Key.sortKeyString(_key);
		this.Environment = _environment;
		this.Name = _name;
		this.KeyState = _keyState;
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

	function getKey()
	{
		return this.Key;
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
		local setting = this.MSU.Class.StringSetting(this.getID(), this.getKey(), this.getName());
		setting.setDescription(this.getDescription());
		setting.addCallback(function(_data)
		{
			::MSU.System.Keybinds.update(this.getModID(), this.getID(), _data);
		});
		return setting;
	}
}
