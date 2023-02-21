::mods_hookExactClass("states/world_state", function(o) {
	local onInitUI = o.onInitUI;
	o.onInitUI = function()
	{
		onInitUI();
		local mainMenuModule = this.m.WorldMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
		::MSU.AfterQueue.run();
	}

	o.main_menu_module_onModOptionsPressed <- function()
	{
		::MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
		::MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.toggleMenuScreen();
		this.setAutoPause(true);
		this.m.WorldScreen.hide();
		::MSU.SettingsScreen.show(::MSU.SettingsFlags.World);
		this.m.MenuStack.push(function ()
		{
			::MSU.SettingsScreen.hide();
			this.m.WorldScreen.show();
			this.setAutoPause(false);
			this.toggleMenuScreen();
		}, function ()
		{
			return !::MSU.SettingsScreen.isAnimating();
		});
	}

	o.msu_settings_screen_onCancelPressed <- function()
	{
		this.m.MenuStack.pop();
	}

	o.msu_settings_screen_onSavepressed <- function( _data )
	{
		::MSU.System.ModSettings.updateSettingsFromJS(_data);
		this.m.MenuStack.pop();
	}

	o.getLocalCombatProperties = function( _pos, _ignoreNoEnemies = false )
	{
		local raw_parties = ::World.getAllEntitiesAtPos(_pos, ::Const.World.CombatSettings.CombatPlayerDistance);
		local parties = [];
		local properties = ::Const.Tactical.CombatInfo.getClone();
		local tile = ::World.getTile(::World.worldToTile(_pos));
		local isAtUniqueLocation = false;
		properties.TerrainTemplate = ::Const.World.TerrainTacticalTemplate[tile.TacticalType];
		properties.Tile = tile;
		properties.InCombatAlready = false;
		properties.IsAttackingLocation = false;
		local factions = array(256, 0); // This is the part that MSU changes

		foreach (party in raw_parties)
		{
			if (!party.isAlive() || party.isPlayerControlled())
			{
				continue;
			}

			if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
			{
				continue;
			}

			if (party.isLocation() && party.isLocationType(::Const.World.LocationType.Unique))
			{
				isAtUniqueLocation = true;
				break;
			}

			if (party.isInCombat())
			{
				raw_parties = ::World.getAllEntitiesAtPos(_pos, ::Const.World.CombatSettings.CombatPlayerDistance * 2.0);
				break;
			}
		}

		foreach (party in raw_parties)
		{
			if (!party.isAlive() || party.isPlayerControlled())
			{
				continue;
			}

			if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
			{
				continue;
			}

			if (isAtUniqueLocation && (!party.isLocation() || !party.isLocationType(::Const.World.LocationType.Unique)))
			{
				continue;
			}

			if (!_ignoreNoEnemies)
			{
				local hasOpponent = false;

				foreach (other in raw_parties)
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

		foreach (party in parties)
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

			::World.Combat.abortCombatWithParty(party);
			party.onBeforeCombatStarted();
			local troops = party.getTroops();

			foreach (t in troops)
			{
				if (t.Script != "")
				{
					t.Faction <- party.getFaction();
					t.Party <- this.WeakTableRef(party);
					properties.Entities.push(t);

					if (!::World.FactionManager.isAlliedWithPlayer(party.getFaction()))
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

		foreach (i, f in factions)
		{
			if (f > best)
			{
				best = f;
				highest_faction = i;
			}
		}

		if (::World.FactionManager.getFaction(highest_faction) != null)
		{
			properties.Music = ::World.FactionManager.getFaction(highest_faction).getCombatMusic();
		}

		return properties;
	}

	local onBeforeSerialize = o.onBeforeSerialize;
	o.onBeforeSerialize = function( _out )
	{
		onBeforeSerialize(_out);
		local meta = _out.getMetaData();
		local modIDsString = "";
		foreach (mod in ::MSU.System.Serialization.Mods)
		{
			meta.setString(mod.getID() + "Version", mod.getVersionString());
			::MSU.Mod.Debug.printLog(format("MSU Serialization: Saving %s (%s), Version: %s", mod.getName(), mod.getID(), mod.getVersionString()));
		}
		foreach (mod in ::mods_getRegisteredMods()) modIDsString += mod.Name + ",";
		meta.setString("MSU.SavedModIDs", modIDsString.slice(0, -1));
	}

	local onBeforeDeserialize = o.onBeforeDeserialize;
	o.onBeforeDeserialize = function( _in )
	{
		onBeforeDeserialize(_in);

		if (::MSU.Mod.Serialization.isSavedVersionAtLeast("1.1.0", _in.getMetaData()))
		{
			local modIDs = split(_in.getMetaData().getString("MSU.SavedModIDs"), ",");
			local hooksMods = ::mods_getRegisteredMods();
			foreach (mod in hooksMods)
			{
				local IDIdx = modIDs.find(mod.Name);
				if (IDIdx != null)
				{
					modIDs.remove(IDIdx);
					if (::MSU.System.Registry.hasMod(mod.Name))
					{
						local oldVersion = _in.getMetaData().getString(mod.Name + "Version");
						if (oldVersion == "")
						{
							::logInfo(format("MSU Serialization: First time this save has been loaded with an MSU version of %s (%s)", mod.FriendlyName, mod.Name));
						}
						else
						{
							local msuMod = ::MSU.System.Registry.getMod(mod.Name);
							switch (::MSU.SemVer.compare(msuMod, ::MSU.SemVer.getTable(oldVersion)))
							{
								case 1:
									::logInfo(format("MSU Serialization: Loading old save for %s (%s), %s -> %s", msuMod.getName(), msuMod.getID(), oldVersion, msuMod.getVersionString()));
									break;
								case 0:
									::MSU.Mod.Debug.printLog(format("MSU Serialization: Loading %s (%s), version %s", msuMod.getName(), msuMod.getID(), msuMod.getVersionString()));
									break;
								case -1:
									::logWarning(format("MSU Serialization: Loading save from newer version for %s (%s), %s -> %s", msuMod.getName(), msuMod.getID(), oldVersion, msuMod.getVersionString()));
									break;
							}
						}
					} // else hooks mod loaded that already existed in save
				}
				else
				{
					::logWarning(format("MSU Serialization: First time this save is being loaded with %s (%s)", mod.FriendlyName, mod.Name));
				}
			}

			foreach (id in modIDs)
			{
				::logWarning(format("MSU Serialization: This save was made while using %s but is being loaded without it.", id));
			}
		}
		else // pre 1.1.0 legacy save support (should be removed in the future)
		{
			foreach (mod in ::MSU.System.Serialization.Mods)
			{
				local oldVersion = _in.getMetaData().getString(mod.getID() + "Version");
				if (oldVersion == "")
				{
					::logInfo(format("MSU Serialization: First time loading this save with %s (%s)", mod.getName(), mod.getID()));
				}
				else
				{
					switch (::MSU.SemVer.compare(mod, ::MSU.SemVer.getTable(oldVersion)))
					{
						case 1:
							::logInfo(format("MSU Serialization: Loading old save for %s (%s), %s -> %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()));
							break;
						case 0:
							::MSU.Mod.Debug.printLog(format("MSU Serialization: Loading %s (%s), version %s", mod.getName(), mod.getID(), mod.getVersionString()));
							break;
						case -1:
							::logWarning(format("MSU Serialization: Loading save from newer version for %s (%s), %s -> %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()));
							break;
						default:
							::logError("Something has gone very wrong with MSU Serialization");
							::MSU.Log.printStackTrace();
					}
				}
			}
		}
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		::MSU.System.ModSettings.flagSerialize(_out);
		::World.Flags.set("MSU.LastDayMorningEventCalled", ::World.Assets.getLastDayMorningEventCalled());
		onSerialize(_out);
		::MSU.System.Serialization.clearFlags();
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		if (::World.Flags.has("MSU.LastDayMorningEventCalled"))
		{
			::World.Assets.setLastDayMorningEventCalled(::World.Flags.get("MSU.LastDayMorningEventCalled"));
		}
		else
		{
			::World.Assets.setLastDayMorningEventCalled(::World.getTime().Days);
		}
		::MSU.System.ModSettings.flagDeserialize(_in);
		::MSU.System.Serialization.clearFlags();
	}

	local onKeyInput = o.onKeyInput;
	o.onKeyInput = function( _key )
	{
		if (!::MSU.Key.isKnownKey(_key))
		{
			return onKeyInput(_key);
		}
		if (::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.World) || ::MSU.Mod.ModSettings.getSetting("SuppressBaseKeybinds").getValue())
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
		if (::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.World))
		{
			return false;
		}
		return onMouseInput(_mouse);
	}
});
