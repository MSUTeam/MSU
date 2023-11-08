::MSU.HooksMod.hook("scripts/retinue/followers/scout_follower", function(q) {
	q.getMovementSpeedMult <- function()
	{
		return ::World.Assets.getTerrainTypeSpeedMult(::World.State.getPlayer().getTile().Type);
	}
})
