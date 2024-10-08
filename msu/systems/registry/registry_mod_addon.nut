::MSU.Class.RegistryModAddon <- class extends ::MSU.Class.SystemModAddon
{
	__ModSources = null;
	__UpdateSource = null;

	constructor(_mod)
	{
		base.constructor(_mod);
		this.__ModSources = {};
	}

	function getModSource( _domain )
	{
		return this.__ModSources[_domain];
	}

	function hasModSource( _domain )
	{
		return _domain in this.__ModSources;
	}

	function addModSource( _domain, _url, _opts = null )
	{
		::MSU.requireString(_url);
		if (_opts != null) ::MSU.requireTable(_opts);
		this.__ModSources[_domain] <- ::MSU.System.Registry.ModSources[_domain](_url, _opts);
	}

	function getUpdateSource()
	{
		if (!this.hasUpdateSource()) return null;
		return this.__ModSources[this.__UpdateSource];
	}

	function hasUpdateSource()
	{
		return this.__UpdateSource != null;
	}

	function setUpdateSource( _domain )
	{
		if (!(_domain in this.__ModSources))
		{
			::logError("Invalid domain value, make sure you've added this domain to the mod sources for this mod with addModSource");
			throw ::MSU.Exception.InvalidValue(_domain);
		}
		if (_domain == ::MSU.System.Registry.ModSourceDomain.NexusMods)
		{
			::logError("Due to the NexusMods API not being public we cannot support a NexusMods update source at this time");
			throw ::MSU.Exception.InvalidValue(_domain);
		}
		this.__UpdateSource = _domain;
	}
}
