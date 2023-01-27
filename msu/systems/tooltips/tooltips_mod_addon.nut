::MSU.Class.TooltipsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	static __regexp = regexp("\\[([\\w\\.]+)\\|([\\w\\.]+)\\]");
	function setTooltips( _tooltipTable )
	{
		::MSU.System.Tooltips.setTooltips(this.Mod.getID(), _tooltipTable);
	}

	function getTooltip( _identifier )
	{
		return ::MSU.System.Tooltips.getTooltip(this.Mod.getID(), _identifier);
	}

	function parseString( _string, _prefix = "" )
	{
		local modID = this.Mod.getID();
		local string = ::MSU.String.regexReplace(_string, this.__regexp, @(_all, _text, _id) format("[tooltip=%s.%s]%s[/tooltip]", modID, _prefix + _id, _text));
		return string
	}
}
