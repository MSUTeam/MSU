::MSU.Class.TooltipsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function setTooltips( _tooltipTable )
	{
		::MSU.System.Tooltips.setTooltips(this.Mod.getID(), _tooltipTable);
	}

	function getTooltip( _identifier )
	{
		return ::MSU.System.Tooltips.getTooltip(this.Mod.getID(), _identifier);
	}
}
