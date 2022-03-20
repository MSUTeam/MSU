::mods_hookExactClass("scenarios/world/rangers_scenario", function(o) {
	local onInit = o.onInit;
	o.onInit = function()
	{
		onInit();
		if (::World.State.getPlayer() != null)
		{
			::World.State.getPlayer().setBaseMovementSpeed(100);
		}
	}

	o.getMovementSpeedMult <- function()
	{
		// Magic number is the result of dividing the rangers movementspeed (111) by the player party movement speed (105)
		return 1.057;
	}
});
