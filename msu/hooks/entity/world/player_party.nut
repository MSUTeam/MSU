::mods_hookExactClass("entity/world/player_party", function(o) {
	local create = o.create;
	o.create = function()
	{
		create();
		this.resetBaseMovementSpeed();
		this.setBaseMovementSpeedMult(1.05);
		this.m.MovementSpeedMultFunctions["RosterMovementSpeedMult"] <- this.getRosterMovementSpeedMult;
		this.m.MovementSpeedMultFunctions["StashMovementSpeedMult"] <- this.getStashMovementSpeedMult;
		this.m.MovementSpeedMultFunctions["OriginMovementSpeedMult"] <- this.getOriginMovementSpeedMult;
		this.m.MovementSpeedMultFunctions["RetinueMovementSpeedMult"] <- this.getRetinueMovementSpeedMult;
		this.m.MovementSpeedMultFunctions["TerrainTypeSpeedMult"] <- this.getTerrainTypeSpeedMult;
	}

	o.getRosterMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local roster = ::World.getPlayerRoster().getAll();
		foreach (bro in roster)
		{
			if ("getMovementSpeedMult" in bro)
			{
				mult *= bro.getMovementSpeedMult();
			}
		}
		return mult;
	}

	o.getStashMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local inventory = ::World.Assets.getStash();
		foreach (item in inventory.getItems())
		{
			if ("getMovementSpeedMult" in item)
			{
				mult *= item.getMovementSpeedMult();
			}
		}
		return mult;
	}

	o.getOriginMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local origin = ::World.Assets.getOrigin();
		if ("getMovementSpeedMult" in origin)
		{
			mult *= origin.getMovementSpeedMult();
		}
		return mult;
	}

	o.getRetinueMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local retinue = ::World.Retinue;
		foreach (follower in retinue.m.Followers)
		{
			if ("getMovementSpeedMult" in follower)
			{
				mult *= follower.getMovementSpeedMult();
			}
		}
		return mult;
	}

	o.getTerrainTypeSpeedMult <- function()
	{
		return ::World.Assets.getTerrainTypeSpeedMult(this.getTile().Type);
	}
});
