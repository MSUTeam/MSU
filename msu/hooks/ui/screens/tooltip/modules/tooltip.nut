::mods_hookNewObject("ui/screens/tooltip/modules/tooltip", function(o){
	o.onQueryGenericTooltipData <- function(_data)
	{
		return ::TooltipScreen.m.TooltipEvents.onQueryGenericTooltipData(_data);
	}
})
