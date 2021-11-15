local gt = this.getroottable();

gt.MSU.modPlayerParty <- function ()
{
	::mods_hookExactClass("entity/world/player_party", function(o) {
		

		local create = o.create;
		o.create = function()
		{
			create();
			this.resetBaseMovementSpeed();
			this.setBaseMovementSpeedMult(1.05);
			this.m.MovementSpeedMultFunctions.push(this.getRosterMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getStashMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getOriginMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getRetinueMovementSpeedMult);
		}

		o.getRosterMovementSpeedMult <- function()
		{
			local mult = 1.0;
			local roster = this.World.getPlayerRoster().getAll();
			foreach(bro in roster)
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
			local inventory = this.World.Assets.getStash();
			foreach(item in inventory.getItems())
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
			local origin = this.World.Assets.getOrigin();
			if ("getMovementSpeedMult" in origin)
			{
				mult *= origin.getMovementSpeedMult();
			}
			return mult;
		}

		o.getRetinueMovementSpeedMult <- function()
		{
			local mult = 1.0;
			local retinue = this.World.Retinue;
			foreach(follower in retinue.m.Followers)
			{
				if ("getMovementSpeedMult" in follower)
				{
					mult *= follower.getMovementSpeedMult();
				}
			}
			return mult;
		}
	});
}