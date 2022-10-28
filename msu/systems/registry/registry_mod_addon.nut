::MSU.Class.RegistryModAddon <- class extends ::MSU.Class.SystemModAddon
{
	static GithubURLRegex = regexp("https:\\/\\/github\\.com\\/([-\\w]+)\\/([-\\w]+)");
	static NexusURLRegex = regexp("https:\\/\\/www\\.nexusmods\\.com\\/battlebrothers\\/mods\\/(\\d+)");
	__GithubURL = null;
	__NexusModsURL = null;
	__UpdateSource = null;

	function getGithubURL()
	{
		return this.__GithubURL;
	}

	function setGithubURL( _url )
	{
		::MSU.requireString(_url);
		if (!this.GithubURLRegex.match(_url))
		{
			::logError("A Github link must be a link to a specific repository, eg: 'https://github.com/MSUTeam/MSU' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.");
			throw ::MSU.Exception.InvalidValue(_url);
		}
		this.__GithubURL = _url;
		this.__UpdateSource = ::MSU.System.Registry.UpdateSourceType.Github;
	}

	function getNexusModsURL()
	{
		return this.__NexusModsURL;
	}

	function setNexusModsURL( _url )
	{
		::MSU.requireString(_url);
		if (!this.NexusURLRegex.match(_url))
		{
			::logError("A NexusMods link must be a link to a specific mod's main page, eg: 'https://www.nexusmods.com/battlebrothers/mods/479' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.");
			throw ::MSU.Exception.InvalidType(_url);
		}
		this.__NexusModsURL = _url;
	}

	// hide github link?

	function hasSource()
	{
		return this.__UpdateSource != null;
	}

	function getSource()
	{
		return this.__UpdateSource;
	}

	function getUpdateURL()
	{
		if (this.__UpdateSource == null) return null;
		if (this.__UpdateSource == ::MSU.System.Registry.UpdateSourceType.Github)
		{
			local capture = this.GithubURLRegex.capture(this.__GithubURL);
			return "https://api.github.com/repos/" + ::MSU.regexMatch(capture, this.__GithubURL, 1) + "/" + ::MSU.regexMatch(capture, this.__GithubURL, 2) + "/releases/latest"
		}
	}
}
