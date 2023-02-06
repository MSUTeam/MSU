::MSU.Class.TooltipsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	static __regexp = regexp("\\[([^|]+)\\|([\\w\\.\\+]+)\\]"); // \[(.+?)\|([\w\.]+)\] \[([^|]+)\|([\w\.]+)\]
	function setTooltips( _tooltipTable )
	{
		::MSU.System.Tooltips.setTooltips(this.Mod.getID(), _tooltipTable);
	}

	function setTooltipImageKeywords( _table )
	{
		return ::MSU.System.Tooltips.setTooltipImageKeywords(this.Mod.getID(), _table);
	}

	function getTooltip( _identifier )
	{
		return ::MSU.System.Tooltips.getTooltip(this.Mod.getID(), _identifier);
	}

	function parseString( _string, _prefix = "" )
	{
		local myModID = this.getMod().getID();
		local match;
		local ret = "";
		local lastPos = 0;
		while (match = this.__regexp.capture(_string, lastPos))
		{
			ret += _string.slice(lastPos, match[0].begin);
			local text = _string.slice(match[1].begin, match[1].end);
			local tooltipID = _string.slice(match[2].begin, match[2].end);
			local modID = !::MSU.System.Tooltips.hasKey(myModID, tooltipID) && ::MSU.System.Tooltips.hasKey(::MSU.ID, tooltipID) ? ::MSU.ID : myModID;
			ret += format("[tooltip=%s.%s]%s[/tooltip]", modID, _prefix + tooltipID, text);
			lastPos = match[0].end;
		}

		return ret + _string.slice(lastPos);
	}
}
