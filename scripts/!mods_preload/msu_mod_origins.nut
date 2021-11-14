local gt = this.getroottable();

gt.MSU.modOrigins <- function ()
{
	::mods_hookExactClass("scenarios/world/rangers_scenario", function(o) {
        local onInit = o.onInit;
        o.onInit = function()
        {
            onInit();
            if (this.World.State.getPlayer() != null)
            {
                this.World.State.getPlayer().setBaseMovementSpeed(100);
            }
        }

        o.getMovementSpeedMult <- function()
        {
            return 1.057;
        }
    });
}