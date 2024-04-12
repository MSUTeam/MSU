::MSU.MH.hook("scripts/scenarios/world/rangers_scenario", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		if (::World.State.getPlayer() != null)
		{
			::World.State.getPlayer().setMovementSpeed(100);
		}
	}

	q.getMovementSpeedMult <- function()
	{
		// Magic number is the result of dividing the rangers movementspeed (111) by the player party movement speed (105)
		return 1.05714285714285714285;
	}
});
