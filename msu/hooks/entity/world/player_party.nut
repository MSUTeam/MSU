::MSU.HooksMod.hook("scripts/entity/world/player_party", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.setMovementSpeed(100);
		this.m.MovementSpeedMultFunctions.PlayerMovementSpeedMult <- this.getPlayerPartyMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RosterMovementSpeedMult <- this.getRosterMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.StashMovementSpeedMult <- this.getStashMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.OriginMovementSpeedMult <- this.getOriginMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RetinueMovementSpeedMult <- this.getRetinueMovementSpeedMult;
	}

	//refers to the base 105 movement speed of the player
	q.getPlayerPartyMovementSpeedMult <- function()
	{
		return 1.05;
	}

	q.getRosterMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local roster = ::World.getPlayerRoster().getAll();
		foreach (bro in roster)
		{
			mult *= bro.getMovementSpeedMult();
		}
		return mult;
	}

	q.getStashMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local inventory = ::World.Assets.getStash();
		foreach (item in inventory.getItems())
		{
			if (item != null)
				mult *= item.getMovementSpeedMult();
		}
		return mult;
	}

	q.getOriginMovementSpeedMult <- function()
	{
		return ::World.Assets.getOrigin().getMovementSpeedMult()
	}

	q.getRetinueMovementSpeedMult <- function()
	{
		local mult = 1.0;
		local retinue = ::World.Retinue;
		foreach (follower in retinue.m.Slots)
		{
			if (follower != null)
				mult *= follower.getMovementSpeedMult();
		}
		return mult;
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		this.setMovementSpeed(100);
	}
});
