::MSU.Tooltip <- {
	SettingsIdentifier = "msu-settings",
	TooltipIdentifiers = {},
	function addTooltips(_mainKey, _tooltipTable)
	{
		this.TooltipIdentifiers[_mainKey] <- _tooltipTable;
	}
}
