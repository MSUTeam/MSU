::MSU.MH.hook("scripts/ui/screens/tooltip/modules/tooltip", function(q) {
	q.onQueryMSUTooltipData <- function(_data)
	{
		return ::TooltipScreen.m.TooltipEvents.onQueryMSUTooltipData(_data);
	}
})
