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
        return 1.057;
    }
});
