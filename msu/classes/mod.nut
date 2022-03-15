this.MSU.Class.Mod <- class
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

	constructor( _id, _version, _name = null )
	{
		if (_name == null) _name = _id;
		this.MSU.requireString(_id, _version, _name);

		this.ID = _id;
		this.Name = _name;

		local table = ::MSU.System.Registry.getVersionTable(_version);
		this.Version = table.Version;
		this.PreRelease = table.PreRelease;
		this.Metadata = table.Metadata;
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

	function registerMod( _system, ... )
	{
		if (vargv == null) vargv = [];

		vargv.insert(0, this); // Requires changing registerMod functions to accept a mod object rather than an ID
		_system.registerMod.acall(vargv);
	}
}
