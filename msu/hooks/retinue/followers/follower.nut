::MSU.HooksMod.hook("scripts/retinue/follower", function(q) {
	q.getMovementSpeedMult <- function()
	{
		return 1.0;
	}
})
