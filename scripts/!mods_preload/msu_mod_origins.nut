local gt = this.getroottable();

gt.MSU.modOrigins <- function ()
{
	::mods_hookDescendants("scenarios/world/starting_scenario", function()
	    {
	        local onInit = o.onInit
	        o.onInit = function()
	        {
	            local speed = this.World.State.getPlayer().getBaseMovementSpeed();
	            onInit();
	            local newSpeed = this.World.State.getPlayer().getBaseMovementSpeed();
	            if (speed != newSpeed)
	            {
	                this.World.State.getPlayer().resetBaseMovementSpeed();
	                this.getMovementSpeedMult <- function()
	                {
	                    return newSpeed/speed;
	                };
	            };
	        };
	   });
}