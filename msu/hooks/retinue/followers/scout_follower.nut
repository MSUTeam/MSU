::mods_hookExactClass("retinue/followers/scout_follower", function(o) {
	o.getMovementSpeedMult <- function()
	{
		return ::World.Assets.getTerrainTypeSpeedMult(this.World.State.getPlayer().getTile().Type);
	}
})
