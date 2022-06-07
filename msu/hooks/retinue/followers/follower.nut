::mods_hookBaseClass("retinue/followers/follower", function(o) {
	o = o[o.SuperName];
	o.getMovementSpeedMult <- function()
	{
		return 1.0;
	}
})
