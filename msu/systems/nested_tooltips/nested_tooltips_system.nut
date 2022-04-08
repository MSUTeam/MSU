::MSU.Class.NestedTooltipSystem <- class extends ::MSU.Class.System
{
	Tooltips = null;
	Extended = null;

	constructor()
	{
		base.constructor(::MSU.SystemID.NestedTooltips)
		this.Tooltips = {};
		this.Extended = false;
	}

	function addTooltip( _modID, _id, _tooltip )
	{
		if (!(_modID in this.Tooltips))
		{
			this.Tooltips[_modID] <- {};
		}
		if (!("getTooltip" in _tooltip) && (!("Text" in _tooltip)))
		{
			throw ::MSU.Exception.InvalidValue("_tooltip");
		}
		this.Tooltips[_modID][_id] <- _tooltip;
	}

	function addTooltips( _modID, _tooltips )
	{
		foreach (key, value in _tooltips)
		{
			this.addTooltip(_modID, key, value);
		}
	}

	function buildTooltip( _modID, _id, _environment = null )
	{
		local tooltip = this.Tooltips[_modID][_id];
		local ret = {
			name = tooltip.Name,
			text = null
		};
		if ("getTooltip" in tooltip)
		{
			ret.text = tooltip.getTooltip(_environment);
		}
		else if ("getVars" in tooltip)
		{
			ret.text = ::buildTextFromTemplate(tooltip.Text, tooltip.getVars(_environment));
		}
		else
		{
			ret.text = tooltip.text;
		}

		if ("Icon" in tooltip)
		{
			ret.icon <- tooltip.Icon;
		}

		return ret;
	}
}
