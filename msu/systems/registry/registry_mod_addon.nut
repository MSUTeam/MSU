local githubURLRegex = regexp("https:\\/\\/github\\.com\\/([-\\w]+)\\/([-\\w]+)") // temp location
local nexusURLRegex = regexp("https:\\/\\/www\\.nexusmods\\.com\\/battlebrothers\\/mods\\/(\\d+)") // temp location
::MSU.Class.RegistryModAddon <- class extends ::MSU.Class.SystemModAddon
{
	_GithubURL = null;
	_NexusModsURL = null;
	_UpdateSource = null;

	function getGithubURL()
	{
		return this._GithubURL;
	}

	function setGithubURL( _url )
	{
		::MSU.requireString(_url);
		if (!githubURLRegex.match(_url))
		{
			::logError("A Github link must be a link to a specific repository, eg: https://github.com/MSUTeam/MSU");
			throw ::MSU.Exception.InvalidValue(_url);
		}
		this._GithubURL = _url;
		this._UpdateSource = ::MSU.System.Registry.UpdateSourceType.Github;
	}

	function getNexusModsURL()
	{
		return this._NexusModsURL;
	}

	function setNexusModsURL( _url )
	{
		::MSU.requireString(_url);
		if (!nexusURLRegex.match(_url))
		{
			::logError("A NexusMods link must be a link to a specific mod's main page, eg: https://www.nexusmods.com/battlebrothers/mods/479");
			throw ::MSU.Exception.InvalidType(_url);
		}
		this._NexusModsURL = _url;
	}

	// hide github link?

	function hasSource()
	{
		return this._UpdateSource != null;
	}

	function getSource()
	{
		return this._UpdateSource;
	}

	function getUpdateURL()
	{
		if (this._UpdateSource == null) return null;
		if (this._UpdateSource == ::MSU.System.Registry.UpdateSourceType.Github)
		{
			local capture = githubURLRegex.capture(this._GithubURL);
			return "https://api.github.com/repos/" + ::MSU.regexMatch(capture, this._GithubURL, 1) + "/" + ::MSU.regexMatch(capture, this._GithubURL, 2) + "/releases/latest"
		}
	}
}
