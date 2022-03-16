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

		Debug = ::MSU.EmptyModAddon;
		Keybinds = ::MSU.EmptyModAddon;
		ModSettings = ::MSU.EmptyModAddon;
		Registry = ::MSU.EmptyModAddon;
		Serialization = ::MSU.EmptyModAddon;

		::MSU.System.Registry.registerMod(this);
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

	function register( _system, ... )
	{
		if (vargv == null) vargv = [];

		vargv.insert(0, _system);
		vargv.insert(1, this);
		_system.registerMod.acall(vargv);
	}

	function printLog( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.Debug.print(_text, ::MSU.System.Debug.LogType.Info, _flagID)
	}

	function printWarning( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.Debug.print(_text, ::MSU.System.Debug.LogType.Warning, _flagID);
	}

	function printError( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.Debug.print(_text, ::MSU.System.Debug.LogType.Error, _flagID);
	}

	// No isDebugEnabled cuz imo Debug.isEnabled is fine

	function getSetting( _id )
	{
		return this.ModSettings.getSetting(_id);
	}

	function _tostring()
	{
		return format("Mod %s, Versions %s\n Registered Systems:\nDebug: %s\nKeybinds: %s\nModSettings: %s", this.getID(), this.getVersionString(), (this.Debug == ::MSU.EmptyModAddon).tostring(), (this.Keybinds == ::MSU.EmptyModAddon).tostring(), (this.ModSettings == ::MSU.EmptyModAddon).tostring());
	}
}
