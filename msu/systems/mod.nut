::MSU.Class.Mod <- class
{
	ID = null;
	Name = null;
	Version = null;
	PreRelease = null;
	Metadata = null;

	// Systems
	Debug = null;
	Keybinds = null;
	ModSettings = null;
	Registry = null;
	Serialization = null;
	PersistentData = null;

	constructor( _id, _version, _name = null )
	{
		if (_name == null) _name = _id;
		::MSU.requireString(_id, _version, _name);

		this.ID = _id;
		this.Name = _name;

		local table = ::MSU.System.Registry.getVersionTable(_version);
		this.Version = table.Version;
		this.PreRelease = table.PreRelease;
		this.Metadata = table.Metadata;
		::MSU.System.Registry.registerMod(this);
		::MSU.System.Debug.registerMod(this);
		::MSU.System.ModSettings.registerMod(this);
		::MSU.System.Keybinds.registerMod(this);
		::MSU.System.Serialization.registerMod(this);
		::MSU.System.PersistentData.registerMod(this);
	}

	function getName()
	{
		return this.Name;
	}

	function getID()
	{
		return this.ID;
	}

	function getShortVersionString()
	{
		return this.Version.reduce(@(_a, _b) _a + "." + _b);
	}

	function getVersionString()
	{
		local ret = this.getShortVersionString();

		if (this.PreRelease != null)
		{
			ret += "-" + this.PreRelease.reduce(@(_a, _b) _a + "." + _b);
		}

		if (this.Metadata != null)
		{
			ret += "+" + this.Metadata.reduce(@(_a, _b) _a + "." + _b);
		}

		return ret;
	}

	function tostring()
	{
		return format("Mod %s, Versions %s\n", this.getID(), this.getVersionString());
	}

	function _tostring()
	{
		return this.tostring();
	}
}
