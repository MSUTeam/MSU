local gt = this.getroottable();

gt.MSU.modMisc <- function ()
{
	gt.Const.FactionRelation <- {
		Any = 0,
		SameFaction = 1,
		Allied = 2,
		Enemy = 3
	}
	::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(o) {
		o.isActiveEntity <- function( _entity )
		{
			local activeEntity = this.getActiveEntity();
			return activeEntity != null && activeEntity.getID() == _entity.getID();
		}
	});

	local old_assignTroops = gt.Const.World.Common.assignTroops;
	gt.Const.World.Common.assignTroops <- function( _party, _partyList, _resources, _weightMode = 1)
	{
		local p = old_assignTroops( _party, _partyList, _resources, _weightMode);
		_party.setBaseMovementSpeedMult(p.MovementSpeedMult);
		_party.resetBaseMovementSpeed();
		return p;
	}

	::mods_hookNewObjectOnce("entity/world/combat_manager", function(o){
		local joinCombat = o.joinCombat
		o.joinCombat = function( _combat, _party){
			if (_combat.Factions.len() <= 100)
			{
				_combat.Factions.resize(256, [])
			}
			joinCombat( _combat, _party)
		}
	})
		
	::mods_hookExactClass("states/world_state", function(o){
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

			foreach( party in raw_parties )
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

			foreach( party in raw_parties )
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

					foreach( other in raw_parties )
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

			foreach( party in parties )
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

				foreach( t in troops )
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

			foreach( i, f in factions )
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
	})
}
