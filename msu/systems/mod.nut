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
	Tooltips = null;

	constructor( _id, _version, _name = null )
	{
		if (_name == null) _name = _id;
		::MSU.requireString(_id, _version, _name);

		this.ID = _id;
		this.Name = _name;

		local table = ::MSU.SemVer.getTable(_version);
		this.Version = table.Version;
		this.PreRelease = table.PreRelease;
		this.Metadata = table.Metadata;
		::MSU.System.Registry.registerMod(this);
		::MSU.System.Debug.registerMod(this);
		::MSU.System.ModSettings.registerMod(this);
		::MSU.System.Keybinds.registerMod(this);
		::MSU.System.Serialization.registerMod(this);
		::MSU.System.PersistentData.registerMod(this);
		::MSU.System.Tooltips.registerMod(this);
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
		return ::MSU.SemVer.getShortVersionString(this);
	}

	function getVersionString()
	{
		return ::MSU.SemVer.getVersionString(this);
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
