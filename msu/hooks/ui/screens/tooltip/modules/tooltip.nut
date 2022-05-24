::mods_hookNewObject("ui/screens/tooltip/modules/tooltip", function(o){
	o.onQueryMSUTooltipData <- function(_data)
	{
		return ::TooltipScreen.m.TooltipEvents.onQueryMSUTooltipData(_data);
	}
})
