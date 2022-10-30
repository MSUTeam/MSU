::MSU.Class.ModSourceGitHub <- class extends ::MSU.Class.ModSource
{
	static URLDomain = ::MSU.System.Registry.URLDomain.GitHub;
	static Regex = regexp("https:\\/\\/github\\.com\\/([-\\w]+)\\/([-\\w]+)");

	constructor( _url )
	{
		if (!this.Regex.match(_url))
		{
			::logError("A GitHub link must be a link to a specific repository, eg: 'https://github.com/MSUTeam/MSU' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.");
			throw ::MSU.Exception.InvalidValue(_url);
		}
		base.constructor(_url);
	}

	function getUpdateURL()
	{
		local capture = this.Regex.capture(this.__URL);
		return "https://api.github.com/repos/" + ::MSU.regexMatch(capture, this.__URL, 1) + "/" + ::MSU.regexMatch(capture, this.__URL, 2) + "/releases/latest"
	}
}
