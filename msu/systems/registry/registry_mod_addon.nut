::MSU.Class.RegistryModAddon <- class extends ::MSU.Class.SystemModAddon
{
	static GitHubURLRegex = regexp("https:\\/\\/github\\.com\\/([-\\w]+)\\/([-\\w]+)");
	static NexusURLRegex = regexp("https:\\/\\/www\\.nexusmods\\.com\\/battlebrothers\\/mods\\/(\\d+)");
	__GitHubURL = null;
	__NexusModsURL = null;
	__UpdateSource = null;

	function getGitHubURL()
	{
		return this.__GitHubURL;
	}

	function setGitHubURL( _url )
	{
		::MSU.requireString(_url);
		if (!this.GitHubURLRegex.match(_url))
		{
			::logError("A GitHub link must be a link to a specific repository, eg: 'https://github.com/MSUTeam/MSU' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.");
			throw ::MSU.Exception.InvalidValue(_url);
		}
		this.__GitHubURL = _url;
		this.__UpdateSource = ::MSU.System.Registry.UpdateSourceType.GitHub;
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
		if (this.__UpdateSource == ::MSU.System.Registry.UpdateSourceType.GitHub)
		{
			local capture = this.GitHubURLRegex.capture(this.__GitHubURL);
			return "https://api.github.com/repos/" + ::MSU.regexMatch(capture, this.__GitHubURL, 1) + "/" + ::MSU.regexMatch(capture, this.__GitHubURL, 2) + "/releases/latest"
		}
	}
}
