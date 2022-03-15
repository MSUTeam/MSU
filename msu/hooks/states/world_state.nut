::mods_hookExactClass("states/world_state", function(o) {
	local onInitUI = o.onInitUI;
	o.onInitUI = function()
	{
		onInitUI();
		local mainMenuModule = this.m.WorldMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
	}

	o.main_menu_module_onModOptionsPressed <- function()
	{
		this.MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
		this.MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.toggleMenuScreen();
		this.m.WorldScreen.hide();
		this.MSU.SettingsScreen.show(this.MSU.SettingsFlags.World);
		this.m.MenuStack.push(function ()
		{
			this.MSU.SettingsScreen.hide();
			this.m.WorldScreen.show();
			this.toggleMenuScreen();
		}, function ()
		{
			return !this.MSU.SettingsScreen.isAnimating();
		});
	}

	o.msu_settings_screen_onCancelPressed <- function()
	{
		this.m.MenuStack.pop();
	}

	o.msu_settings_screen_onSavepressed <- function( _data )
	{
		this.MSU.System.ModSettings.updateSettings(_data);
		this.m.MenuStack.pop();
	}

	o.getLocalCombatProperties = function( _pos, _ignoreNoEnemies = false )
	{
		local raw_parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance);
		local parties = [];
		local properties = this.Const.Tactical.CombatInfo.getClone();
		local tile = this.World.getTile(this.World.worldToTile(_pos));
		local isAtUniqueLocation = false;
		properties.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
		properties.Tile = tile;
		properties.InCombatAlready = false;
		properties.IsAttackingLocation = false;
		local factions = array(256, 0)

		foreach ( party in raw_parties )
		{
			if (!party.isAlive() || party.isPlayerControlled())
			{
				continue;
			}

			if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
			{
				continue;
			}

			if (party.isLocation() && party.isLocationType(this.Const.World.LocationType.Unique))
			{
				isAtUniqueLocation = true;
				break;
			}

			if (party.isInCombat())
			{
				raw_parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance * 2.0);
				break;
			}
		}

		foreach ( party in raw_parties )
		{
			if (!party.isAlive() || party.isPlayerControlled())
			{
				continue;
			}

			if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
			{
				continue;
			}

			if (isAtUniqueLocation && (!party.isLocation() || !party.isLocationType(this.Const.World.LocationType.Unique)))
			{
				continue;
			}

			if (!_ignoreNoEnemies)
			{
				local hasOpponent = false;

				foreach ( other in raw_parties )
				{
					if (other.isAlive() && !party.isAlliedWith(other))
					{
						hasOpponent = true;
						break;
					}
				}

				if (hasOpponent)
				{
					parties.push(party);
				}
			}
			else
			{
				parties.push(party);
			}
		}

		foreach ( party in parties )
		{
			if (party.isInCombat())
			{
				properties.InCombatAlready = true;
			}

			if (party.isLocation())
			{
				properties.IsAttackingLocation = true;
				properties.CombatID = "LocationBattle";
				properties.LocationTemplate = party.getCombatLocation();
				properties.LocationTemplate.OwnedByFaction = party.getFaction();
			}

			this.World.Combat.abortCombatWithParty(party);
			party.onBeforeCombatStarted();
			local troops = party.getTroops();

			foreach ( t in troops )
			{
				if (t.Script != "")
				{
					t.Faction <- party.getFaction();
					t.Party <- this.WeakTableRef(party);
					properties.Entities.push(t);

					if (!this.World.FactionManager.isAlliedWithPlayer(party.getFaction()))
					{
						++factions[party.getFaction()];
					}
				}
			}

			if (troops.len() != 0)
			{
				party.onCombatStarted();
				properties.Parties.push(party);
				this.m.PartiesInCombat.push(party);

				if (party.isAlliedWithPlayer())
				{
					properties.AllyBanners.push(party.getBanner());
				}
				else
				{
					properties.EnemyBanners.push(party.getBanner());
				}
			}
		}

		local highest_faction = 0;
		local best = 0;

		foreach ( i, f in factions )
		{
			if (f > best)
			{
				best = f;
				highest_faction = i;
			}
		}

		if (this.World.FactionManager.getFaction(highest_faction) != null)
		{
			properties.Music = this.World.FactionManager.getFaction(highest_faction).getCombatMusic();
		}

		return properties;
	}

	local onBeforeSerialize = o.onBeforeSerialize;
	o.onBeforeSerialize = function( _out )
	{
		onBeforeSerialize(_out);
		local meta = _out.getMetaData();
		foreach (mod in this.MSU.System.Serialization.Mods)
		{
			meta.setString(mod.getID() + "Version", mod.getVersionString());
			::MSU.Mod.printLog(format("MSU Serialization: Saving %s (%s), Version: %s", mod.getName(), mod.getID(), mod.getVersionString()));
		}
	}

	local onBeforeDeserialize = o.onBeforeDeserialize;
	o.onBeforeDeserialize = function( _in )
	{
		onBeforeDeserialize(_in);
		foreach (mod in this.MSU.System.Serialization.Mods)
		{
			local oldVersion = _in.getMetaData().getString(mod.getID() + "Version");
			if (oldVersion == "") return;

			switch (::MSU.Registry.compareModToVersion(mod, oldVersion))
			{
				case -1:
					this.logInfo(format("MSU Serialization: Loading old save for mod %s (%s), %s => %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()));
					break;
				case 0:
					::MSU.Mod.printLog(format("MSU Serialization: Loading %s (%s), version %s", mod.getName(), mod.getID(), mod.getVersionString()));
					break;
				case 1:
					this.logWarning(format("MSU Serialization: Loading save from newer version for mod %s (%s), %s => %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()))
					break;
				default:
					this.logError("Something has gone very wrong with MSU Serialization");
					this.MSU.System.Debug.printStackTrace();
			}
		}
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		this.MSU.System.ModSettings.flagSerialize();
		this.World.Flags.set("MSU.LastDayMorningEventCalled", this.World.Assets.getLastDayMorningEventCalled());
		onSerialize(_out);
		this.MSU.System.ModSettings.resetFlags();
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		if (this.World.Flags.has("MSU.LastDayMorningEventCalled"))
		{
			this.World.Assets.setLastDayMorningEventCalled(this.World.Flags.get("MSU.LastDayMorningEventCalled"));
		}
		else
		{
			this.World.Assets.setLastDayMorningEventCalled(0);
		}

		this.MSU.System.ModSettings.flagDeserialize();
		this.MSU.System.ModSettings.resetFlags();
	}

	local onKeyInput = o.onKeyInput;
	o.onKeyInput = function( _key )
	{
		if (!::MSU.Key.isKnownKey(_key))
		{
			return onKeyInput(_key);
		}
		if (::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.World) == false)
		{
			return false;
		}
		return onKeyInput(_key);
	}

	local onMouseInput = o.onMouseInput;
	o.onMouseInput = function( _mouse )
	{
		if (!::MSU.Key.isKnownMouse(_mouse))
		{
			return onMouseInput(_mouse);
		}
		if (::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.World) == false)
		{
			return false;
		}
		return onMouseInput(_mouse);
	}
});
