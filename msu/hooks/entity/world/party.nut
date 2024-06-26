::MSU.MH.hook("scripts/entity/world/party", function(q) {
	// The final movement speed mult that is applied to the default value of 100
	q.m.MovementSpeedMult <- 1.0;
	q.m.MovementSpeedMultFunctions <- {};

	q.create = @(__original) function()
	{
		__original();
		this.m.MovementSpeedMultFunctions.BaseMovementSpeedMult <- this.getBaseMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RoadMovementSpeedMult <- this.getRoadMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.SlowdownPerUnitMovementSpeedMult <- this.getSlowdownPerUnitMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.GlobalMovementSpeedMult <- this.getGlobalMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.NightTimeMovementSpeedMult <- this.getNightTimeMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RiverMovementSpeedMult <- this.getRiverMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.NotPlayerMovementSpeedMult <- this.getNotPlayerMovementSpeedMult;
	}

	// Used in vanilla to fetch BaseMovementSpeed in the ai_flee function ; we now return the new computed value
	q.getBaseMovementSpeed = @() function()
	{
		return this.getMovementSpeed();
	}

	// Get the base values that were changed for slower parties or things like caravan contracts
	q.getBaseMovementSpeedMult <- function()
	{
		return this.m.BaseMovementSpeed / 100.0;
	}

	q.getMovementSpeedMult <- function()
	{
		return this.m.MovementSpeedMult;
	}

	q.setMovementSpeedMult <- function( _mult )
	{
		this.m.MovementSpeedMult = _mult;
	}

	q.getFinalMovementSpeedMult <- function()
	{
		local mult = 1.0;
		foreach (key, func in this.m.MovementSpeedMultFunctions)
		{
			local funcResult = func();
			mult *= funcResult;
		}
		return mult;
	}

	q.updateMovementSpeedMult <- function()
	{
		this.setMovementSpeedMult(this.getFinalMovementSpeedMult());
	}

	q.getMovementSpeed <- function( _update = false )
	{
		if (_update)
		{
			this.updateMovementSpeedMult();
		}
		local speed = ::Const.World.MovementSettings.Speed * this.getMovementSpeedMult();
		return speed;
	}

	q.getTimeDelta <- function()
	{
		local delta = ::Math.maxf(0.0, ::Time.getVirtualTimeF() - this.m.LastUpdateTime);
		return delta;
	}

	//------------- All movementspeed factors, extracted out of party onUpdate() ---------------------

	q.getSlowdownPerUnitMovementSpeedMult <- function()
	{
		return (1.0 - ::Math.minf(0.5, this.m.Troops.len() * ::Const.World.MovementSettings.SlowDownPartyPerTroop));
	}

	q.getGlobalMovementSpeedMult <- function()
	{
		return ::Const.World.MovementSettings.GlobalMult;
	}

	q.getRoadMovementSpeedMult <- function()
	{
		if (this.isIgnoringCollision())
		{
			return 1.0;
		}
		local myTile = this.getTile();
		if (myTile.HasRoad)
		{
			return ::Math.maxf(::Const.World.TerrainTypeSpeedMult[myTile.Type] * ::Const.World.MovementSettings.RoadMult, 1.0);
		}
		else
		{
			return ::Const.World.TerrainTypeSpeedMult[myTile.Type];
		}
	}

	q.getTerrainTypeSpeedMult <- function()
	{
		return this.m.IsPlayer ? ::World.Assets.getTerrainTypeSpeedMult(this.getTile().Type) : 1.0;
	}

	q.getNightTimeMovementSpeedMult <- function()
	{
		if (!this.m.IsSlowerAtNight || ::World.isDaytime())
		{
			return 1.0;
		}
		return ::Const.World.MovementSettings.NighttimeMult;
	}

	q.getRiverMovementSpeedMult <- function()
	{
		return this.getTile().HasRiver ? ::Const.World.MovementSettings.RiverMult : 1.0;
	}

	q.getNotPlayerMovementSpeedMult <- function()
	{
		return this.m.IsPlayer ? 1.0 : ::Const.World.MovementSettings.NotPlayerMult;
	}

	q.onUpdate = @(__original) function()
	{
		local moddedSpeed = this.getMovementSpeed(true);
		local delta = this.getTimeDelta();
		local speedDelta = moddedSpeed * delta;
		local move = this.move;
		this.move = function(_dest, _speed)
		{
			if (::MSU.Mod.Debug.isEnabled("movement") && ::Math.round(speedDelta) != ::Math.round(_speed))
			{
				this.__testCompareMovementSpeeds(moddedSpeed, _speed)
			}
			return move(_dest, speedDelta);
		}
		__original();
		this.move = move;
	}

	q.__testCompareMovementSpeeds <- function(_moddedSpeed, _speed)
	{
		local name = this.m.IsPlayer ? "Player" : this.getName()
		local vanillaMovementSpeed = 1.0
		local slowDownPartyPerTroop = 1.0
		local GlobalMult = 1.0
		local TerrainTypeSpeedMult = 1.0
		local getTerrainTypeSpeedMultPlayer = 1.0
		local NighttimeMult = 1.0
		local RiverMult = 1.0
		local NotPlayerMult = 1.0

		local speed = this.m.BaseMovementSpeed;
		slowDownPartyPerTroop = (1.0 - ::Math.minf(0.5, this.m.Troops.len() * ::Const.World.MovementSettings.SlowDownPartyPerTroop));
		speed *= slowDownPartyPerTroop
		GlobalMult = ::Const.World.MovementSettings.GlobalMult;
		speed *= GlobalMult
		local myTile = this.getTile();

		if (!this.isIgnoringCollision())
		{
			if (myTile.HasRoad)
			{
				TerrainTypeSpeedMult = ::Math.maxf(::Const.World.TerrainTypeSpeedMult[myTile.Type] * ::Const.World.MovementSettings.RoadMult, 1.0);
			}
			else
			{
				TerrainTypeSpeedMult = ::Const.World.TerrainTypeSpeedMult[myTile.Type];
			}
			speed *= TerrainTypeSpeedMult

			if (this.m.IsPlayer)
			{
				getTerrainTypeSpeedMultPlayer = ::World.Assets.getTerrainTypeSpeedMult(myTile.Type);
			}
			speed *= getTerrainTypeSpeedMultPlayer
		}

		if (this.m.IsSlowerAtNight && !::World.isDaytime())
		{
			NighttimeMult = ::Const.World.MovementSettings.NighttimeMult;
		}
		speed *= NighttimeMult

		if (myTile.HasRiver)
		{
			RiverMult = ::Const.World.MovementSettings.RiverMult;
		}
		speed *= RiverMult
		if (this.getFaction() != ::Const.Faction.Player)
		{
			NotPlayerMult = ::Const.World.MovementSettings.NotPlayerMult;
		}
		speed *= NotPlayerMult

		local function logIfDifferent(_key, _modded, _vanilla)
		{
			if (::Math.round(_modded) != ::Math.round(_vanilla))
			{
				::MSU.Mod.Debug.printError(format("%s : Vanilla : %f | Modded: %f", _key, _vanilla, _modded), "movement")
			}
		}

		::MSU.Mod.Debug.printError("Movement Speed for party " + this.getName() + " is NOT correct. Expected: " + speed + " , actual: " + _moddedSpeed, "movement")
		logIfDifferent("GlobalMult", GlobalMult, this.getGlobalMovementSpeedMult());
		logIfDifferent("slowDownPartyPerTroop", slowDownPartyPerTroop, this.getSlowdownPerUnitMovementSpeedMult());
		logIfDifferent("NotPlayerMult", NotPlayerMult, this.getNotPlayerMovementSpeedMult());
		logIfDifferent("RiverMult", RiverMult, this.getRiverMovementSpeedMult());
		logIfDifferent("NighttimeMult", NighttimeMult, this.getNightTimeMovementSpeedMult());
		logIfDifferent("TerrainTypeSpeedMult", TerrainTypeSpeedMult, this.getRoadMovementSpeedMult());
	}
});
