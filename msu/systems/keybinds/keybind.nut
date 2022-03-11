this.MSU.Class.Keybind <- class
{
	Key = null;
	ModID = null;
	ID = null;
	Name = null;
	Description = null;

	constructor( _modID, _id, _key, _name = null )
	{
		if (_name == null) _name = _id;
		if (!(_modID in this.MSU.System.Keybinds.Mods))
		{
			throw ::Exception.ModNotRegistered;
		}
		::MSU.requireString(_modID, _id, _key, _name);

		this.ModID = _modID;
		this.ID = _id;
		this.Key = getParsedKeyFromMSUKey(_key);
		this.Environment = _environment;
		this.Name = _name;
	}

	function setDescription( _description )
	{
		this.Description = _description;
	}

	function getDescription()
	{
		return this.Description;
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
