::MSU.Class.ModSource <- class
{
	static ModSourceDomain = null;
	static Regex = null;
	static BadURLMessage = "A link must be pointing to a specific mod.";
	static Icon = null;
	__URL = null;

	constructor( _url, _opts = null )
	{
		if (this.Regex != null && !this.Regex.match(_url))
		{
			::logError(this.BadURLMessage);
			throw ::MSU.Exception.InvalidValue(_url);
		}
		this.__URL = _url;
		if (_opts != null) {
			foreach (key, value in _opts) this[key] = value;
		}
	}

	function getUpdateURL()
	{
		return null;
	}

	function getURL()
	{
		return this.__URL
	}

	function extractRelease(_data) {
		return null;
	}
}
