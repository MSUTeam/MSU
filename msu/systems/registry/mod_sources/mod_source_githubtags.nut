::MSU.Class.ModSourceGitHubTags <- class extends ::MSU.Class.ModSource
{
	static ModSourceDomain = ::MSU.Class.RegistrySystem.ModSourceDomain.GitHubTags;
	static Regex = regexp(@"https://github.com/([-\w]+)/([-\w]+).*");
	static BadURLMessage = "A link must point into a Github repository, e.g. 'https://github.com/MSUteam/MSU', or a subtree, e.g. 'https://github.com/Suor/battle-brothers-mods/tree/master/autopilot'.";
	static Icon = "github";
	// This is one is set via Mod.Registry.addModSource(..., {Prefix = ...}) -> base.constructor()
	Prefix = ""

	function getUpdateURL()
	{
		local capture = this.Regex.capture(this.__URL);
		local owner = ::MSU.regexMatch(capture, this.__URL, 1);
		local repo = ::MSU.regexMatch(capture, this.__URL, 2);
		return format("https://api.github.com/repos/%s/%s/git/matching-refs/tags/%s?per_page=100",
			owner, repo, this.Prefix)
	}

	function extractRelease(_data) {
		local refPrefix = "refs/tags/" + this.Prefix, maxVersion = "0.0.0";
		foreach (rec in _data) {
			local version = rec.ref.slice(refPrefix.len());
			if (!::MSU.SemVer.isSemVer(version)) continue;
			if (::MSU.SemVer.compareVersionWithOperator(version, ">", maxVersion))
				maxVersion = version;
		}
		return {Version = maxVersion, Changes = ""};
	}
}
