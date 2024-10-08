::MSU.Class.ModSourceGitHub <- class extends ::MSU.Class.ModSource
{
	static ModSourceDomain = ::MSU.Class.RegistrySystem.ModSourceDomain.GitHub;
	static Regex = regexp("https:\\/\\/github\\.com\\/([-\\w]+)\\/([-\\w]+)");
	static BadURLMessage = "A GitHub link must be a link to a specific repository, e.g. 'https://github.com/MSUTeam/MSU' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.";
	static Icon = "github";

	function getUpdateURL()
	{
		local capture = this.Regex.capture(this.__URL);
		return "https://api.github.com/repos/" + ::MSU.regexMatch(capture, this.__URL, 1) + "/" + ::MSU.regexMatch(capture, this.__URL, 2) + "/releases/latest"
	}

	function extractRelease(_data) {
		return {Version = _data.tag_name, Changes = _data.body};
	}
}
