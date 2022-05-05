::mods_hookExactClass("entity/world/party", function(o) {
	o.m.VanillaBaseMovementSpeed <- o.m.BaseMovementSpeed;
	o.m.BaseMovementSpeedMult <- 1.0;
	o.m.MovementSpeedMult <- 1.0;
	o.m.MovementSpeedMultFunctions <- {};

	local create = o.create;
	o.create = function()
	{
		create();
		this.resetBaseMovementSpeed();
		this.m.MovementSpeedMultFunctions.BaseMovementSpeedMult <- this.getBaseMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RoadMovementSpeedMult <- this.getRoadMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.SlowdownPerUnitMovementSpeedMult <- this.getSlowdownPerUnitMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.GlobalMovementSpeedMult <- this.getGlobalMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.NightTimeMovementSpeedMult <- this.getNightTimeMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.RiverMovementSpeedMult <- this.getRiverMovementSpeedMult;
		this.m.MovementSpeedMultFunctions.NotPlayerMovementSpeedMult <- this.getNotPlayerMovementSpeedMult;
	}

	o.getVanillaBaseMovementSpeed <- function()
	{
		return this.m.VanillaBaseMovementSpeed;
	}

	o.setVanillaBaseMovementSpeed <- function( _speed )
	{
		this.m.VanillaBaseMovementSpeed = _speed;
	}

	o.setBaseMovementSpeed <- function( _speed )
	{
		this.m.BaseMovementSpeed = _speed;
	}

	o.resetBaseMovementSpeed <- function()
	{
		this.setBaseMovementSpeed(100);
	}

	o.getBaseMovementSpeedMult <- function()
	{
		return this.m.BaseMovementSpeedMult;
	}

	o.setBaseMovementSpeedMult <- function( _mult )
	{
		this.m.BaseMovementSpeedMult = _mult;
	}

	o.getMovementSpeedMult <- function()
	{
		return this.m.MovementSpeedMult;
	}

	o.setMovementSpeedMult <- function( _mult )
	{
		this.m.MovementSpeedMult = _mult;
	}

	o.setMovementSpeed <- function( _speed )
	{
		this.setVanillaBaseMovementSpeed(_speed);
		this.setBaseMovementSpeedMult(_speed / 100.0);
	}

	o.getFinalMovementSpeedMult <- function()
	{
		local mult = 1.0;
		foreach (key, func in this.m.MovementSpeedMultFunctions)
		{
			local funcResult = func();
			mult *= funcResult;
		}
		return mult;
	}

	o.updateMovementSpeedMult <- function()
	{
		this.setMovementSpeedMult(this.getFinalMovementSpeedMult());
	}

	o.getMovementSpeed <- function( _update = false )
	{
		if (_update)
		{
			this.updateMovementSpeedMult();
		}
		local speed = this.getBaseMovementSpeed() * this.getMovementSpeedMult();
		return speed;
	}

	o.getTimeDelta <- function() 
	{
		local delta = ::Math.maxf(0.0, ::Time.getVirtualTimeF() - this.m.LastUpdateTime);
		return delta;
	}

	//------------- All movementspeed factors, extracted out of party onUpdate() ---------------------

	o.getSlowdownPerUnitMovementSpeedMult <- function()
	{
		return (1.0 - ::Math.minf(0.5, this.m.Troops.len() * ::Const.World.MovementSettings.SlowDownPartyPerTroop));
	}

	o.getGlobalMovementSpeedMult <- function()
	{
		return ::Const.World.MovementSettings.GlobalMult;
	}

	o.getRoadMovementSpeedMult <- function()
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

	o.getNightTimeMovementSpeedMult <- function()
	{
		if (!this.m.IsSlowerAtNight || ::World.isDaytime())
		{
			return 1.0;
		}
		return ::Const.World.MovementSettings.NighttimeMult;
	}

	o.getRiverMovementSpeedMult <- function()
	{
		if (!this.getTile().HasRiver)
		{
			return 1.0;
		}
		return ::Const.World.MovementSettings.RiverMult;
	}

	o.getNotPlayerMovementSpeedMult <- function()
	{
		if (this.m.IsPlayer)
		{
			return 1.0;
		}
		return ::Const.World.MovementSettings.NotPlayerMult;
	}

	o.onUpdate = function()
	{
		this.world_entity.onUpdate();
		local delta = this.getTimeDelta();
		this.m.LastUpdateTime = ::Time.getVirtualTimeF();
		
		if (this.isInCombat())
		{
			this.setOrders("Fighting");
			return;
		}

		if (this.m.StunTime > ::Time.getVirtualTimeF())
		{
			return;
		}

		if (this.m.Controller != null)
		{
			this.m.Controller.think();
		}

		if (this.m.Flags.get("IsAlps"))
		{
			this.m.IsLeavingFootprints = false;

			if (::World.getTime().IsDaytime)
			{
				//use function instead of accessing m
				this.setVisibilityMult(0.0);
				this.getController().getBehavior(::Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			}
			else
			{
				//use function instead of accessing m
				this.setVisibilityMult(1.0);
				this.getController().getBehavior(::Const.World.AI.Behavior.ID.Attack).setEnabled(true);
			}
		}

		if (this.m.Path != null)
		{
			if (this.m.Path.isAtWaypoint(this.getPos()))
			{
				this.m.Path.pop();

				if (this.m.Path.isEmpty())
				{
					this.m.Path = null;
					this.m.Destination = null;
				}
			}

			if (this.m.Path != null)
			{
				this.m.Destination = ::World.tileToWorld(this.m.Path.getCurrent());
			}
		}

		if (this.m.Destination != null)
		{
			if (this.m.IsMirrored)
			{
				if (this.getSprite("bodyUp").HasBrush)
				{
					if (this.m.Destination.Y < this.getPos().Y)
					{
						this.getSprite("bodyUp").Visible = false;
						this.getSprite("body").Visible = true;
					}
					else
					{
						this.getSprite("bodyUp").setHorizontalFlipping(this.m.Destination.X < this.getPos().X);
						this.getSprite("bodyUp").Visible = true;
						this.getSprite("body").Visible = false;
					}
				}

				this.getSprite("body").setHorizontalFlipping(this.m.Destination.X < this.getPos().X);
			}

			local myTile = this.getTile();
			local speed = this.getMovementSpeed(true) * delta;

			if (this.m.IsLeavingFootprints && !myTile.IsOccupied)
			{
				if (::Time.getVirtualTimeF() - this.m.LastFootprintTime >= 1.0)
				{
					local scale;

					if (this.m.FootprintSizeOverride == 0.0)
					{
						scale = ::Math.minf(1.0, ::Math.maxf(0.4, this.m.Troops.len() * 0.05));
					}
					else
					{
						scale = this.m.FootprintSizeOverride;
					}

					::World.spawnFootprint(this.createVec(this.getPos().X - 5, this.getPos().Y - 15), this.m.Footprints[this.getDirection8To(this.m.Destination)] + "_0" + this.m.LastFootprintType, scale, this.m.FootprintSizeOverride != 0.0 ? 30.0 : 0.0, ::World.Assets.getFootprintVision(), this.m.FootprintType);
					this.m.LastFootprintTime = ::Time.getVirtualTimeF();
					this.m.LastFootprintType = this.m.LastFootprintType == 1 ? 2 : 1;
				}
			}

			if (!this.move(this.m.Destination, speed))
			{
				this.m.Destination = null;
			}
		}

		if (this.m.IdleSoundsIndex != 0 && this.m.LastIdleSound + 10.0 < ::Time.getRealTimeF() && ::Math.rand(1, 100) <= 5 && this.isVisibleToEntity(::World.State.getPlayer(), 500))
		{
			this.m.LastIdleSound = ::Time.getRealTimeF();
			::Sound.play(::Const.SoundPartyAmbience[this.m.IdleSoundsIndex][::Math.rand(0, ::Const.SoundPartyAmbience[this.m.IdleSoundsIndex].len() - 1)], ::Const.Sound.Volume.Ambience, this.getPos());
		}

		::MSU.Mod.Debug.isEnabled("movement")
		{
			this.testCompareMovementSpeeds()
		}
	}

	o.testCompareMovementSpeeds <- function()
	{
		local moddedSpeed = this.getMovementSpeed(true);
		local vanillaMovementSpeed = 1.0
		local slowDownPartyPerTroop = 1.0
		local GlobalMult = 1.0
		local TerrainTypeSpeedMult = 1.0
		local getTerrainTypeSpeedMultPlayer = 1.0
		local NighttimeMult = 1.0
		local RiverMult = 1.0
		local NotPlayerMult = 1.0


		local vanillaMovementSpeed = this.getVanillaBaseMovementSpeed();
		local speed = vanillaMovementSpeed;
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

		if(::Math.round(moddedSpeed) != ::Math.round(speed))
		{
			::MSU.Mod.Debug.printError("Movement Speed for party " + this.getName() + " is NOT correct. Expected: " + speed + " , actual: " + moddedSpeed, "movement")
			::MSU.Mod.Debug.printError("COMPARING VANILLA AND MSU", "movement")
			::MSU.Mod.Debug.printError("vanillaMovementSpeed " + vanillaMovementSpeed + " " + this.getBaseMovementSpeedMult() * 100, "movement")
			::MSU.Mod.Debug.printError("GlobalMult" + GlobalMult + " " + this.getGlobalMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("slowDownPartyPerTroop" + slowDownPartyPerTroop + " " + this.getSlowdownPerUnitMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("NotPlayerMult " + NotPlayerMult + " " + this.getNotPlayerMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("RiverMult " + RiverMult + " " + this.getRiverMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("NighttimeMult " + NighttimeMult + " " + this.getNightTimeMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("TerrainTypeSpeedMult " + TerrainTypeSpeedMult + " " + this.getRoadMovementSpeedMult(), "movement")
			::MSU.Mod.Debug.printError("getTerrainTypeSpeedMultPlayer " + getTerrainTypeSpeedMultPlayer + " " + this.getRoadMovementSpeedMult(), "movement")

		}
	}
	
	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		this.getFlags().set("VanillaBaseMovementSpeed", this.getVanillaBaseMovementSpeed());
		this.getFlags().set("BaseMovementSpeedMult", this.getBaseMovementSpeedMult());
		onSerialize(_out);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		if (this.getFlags().has("VanillaBaseMovementSpeed"))
		{
			this.setVanillaBaseMovementSpeed(this.getFlags().get("VanillaBaseMovementSpeed"));
		}
		if (this.getFlags().has("BaseMovementSpeedMult"))
		{
			this.setBaseMovementSpeedMult(this.getFlags().get("BaseMovementSpeedMult"));
		}
		this.resetBaseMovementSpeed();

	}
});
