local gt = this.getroottable();

gt.MSU.modSkill <- function ()
{
	this.Const.Combat.DivertedAttackHitChancePenalty <- 15;
	this.Const.Combat.DivertedAttackDamageMult <- 0.75;

	this.Const.ItemActionOrder <- {
		First = 0,
		Early = 1000,
		Any = 50000,
		BeforeLast = 60000
		Last = 70000,
		VeryLast = 80000
	};

	::mods_hookDescendants("skills/skill", function(o) {
		if ("create" in o)
		{
			local create = o.create;
			o.create = function()
			{
				create();
				if (this.m.InjuriesOnBody != null)
				{
					this.setupDamageType();
				}
			}
		}
	});

	::mods_hookBaseClass("skills/skill", function(o) {
		o = o[o.SuperName];

		o.m.DamageType <- [];
		o.m.ItemActionOrder <- this.Const.ItemActionOrder.Any;

		o.m.IsBaseValuesSaved <- false;
		o.m.ScheduledChanges <- [];

		o.scheduleChange <- function( _field, _change, _set = false )
		{
			this.m.ScheduledChanges.push({Field = _field, Change = _change, Set = _set});
		}

		o.executeScheduledChanges <- function()
		{
			if (this.m.ScheduledChanges.len() == 0)
			{
				return;
			}

			foreach (c in this.m.ScheduledChanges)
			{
				switch (typeof c.Change)
				{
					case "integer":
						if (c.Set)
						{
							this.m[c.Field] = c.Change;
						}
						else
						{
							this.m[c.Field] += c.Change;
						}

						break;

					case "string":
						if (c.Set)
						{
							this.m[c.Field] = c.Change;
						}
						else
						{
							this.m[c.Field] += c.Change;
						}
						break;

					default:
						this.m[c.Field] = c.Change;
						break;
				}
			}

			this.m.ScheduledChanges.clear();
		}

		o.saveBaseValues <- function()
		{
			if (this.m.IsBaseValuesSaved)
			{
				return;
			}

			this.b <- clone this.skill.m;
			this.m.IsBaseValuesSaved = true;
		}

		o.softReset <- function()
		{
			if (!this.m.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod softReset() skill \"" + this.getID() + "\" does not have base values saved.");
				return false;
			}

			this.m.ActionPointCost = this.b.ActionPointCost;
			this.m.FatigueCost = this.b.FatigueCost;
			this.m.FatigueCostMult = this.b.FatigueCostMult;
			this.m.MinRange = this.b.MinRange;
			this.m.MaxRange = this.b.MaxRange;

			return true;
		}

		o.hardReset <- function()
		{
			if (!this.m.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod hardReset() skill \"" + this.getID() + "\" does not have base values saved.");
				return false;
			}

			foreach (k, v in this.b)
			{
				this.m[k] = v;
			}

			return true;
		}

		o.resetField <- function( _field )
		{
			if (!this.m.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod resetField() skill \"" + this.getID() + "\" does not have base values saved.");
				return false;
			}

			this.m[_field] = this.b[_field];

			return true;
		}

		o.onMovementStarted <- function( _tile, _numTiles )
		{
		}

		o.onMovementFinished <- function( _tile )
		{
		}

		o.onAfterDamageReceived <- function()
		{
		}

		o.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity )
		{
		}

		o.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity )
		{
		}

		// o.onAttacked <- function( _skill, _attacker )
		// {
		// }

		// o.onHit <- function( _skill, _attacker, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		// {			
		// }

		o.onUpdateLevel <- function()
		{
		}

		o.getItemActionCost <- function( _items )
		{
			return null;
		}

		o.getItemActionOrder <- function()
		{
			return this.m.ItemActionOrder;
		}

		o.onPayForItemAction <- function( _skill, _items )
		{
		}

		o.onNewMorning <- function()
		{
		}

		o.onGetHitFactors <- function( _skill, _targetTile, _tooltip ) 
		{
		}

		o.onQueryTooltip <- function( _skill, _tooltip )
		{			
		}

		local use = o.use;
		o.use = function( _targetTile, _forFree = false )
		{
			# Save the container as a local variable because some skills delete
			# themselves during use (e.g. Reload Bolt) causing this.m.Container
			# to point to null.
			local container = this.m.Container;
			local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;

			container.onBeforeAnySkillExecuted(this, _targetTile, targetEntity);

			local ret = use( _targetTile, _forFree );

			container.onAnySkillExecuted(this, _targetTile, targetEntity);

			return ret;
		}

		o.removeDamageType <- function( _damageType )
		{
			for (local i = 0; i < this.m.DamageType.len(); i++)
			{
				if (this.m.DamageType[i].DamageType == _damageType)
				{
					this.m.DamageType.remove(i);
				}
			}
		}

		o.setDamageTypeWeight <- function( _damageType, _weight )
		{
			foreach (d in this.m.DamageType)
			{
				if (d.Type == _damageType)
				{
					d.Weight = _weight;
				}
			}
		}

		o.addDamageType <- function( _damageType, _weight = null )
		{
			if (this.hasDamageType(_damageType))
			{
				return;
			}

			if (_weight == null)
			{
				if (this.m.DamageType.len() > 0)
				{
					local totalWeight = 0;
					foreach (d in this.m.DamageType)
					{
						totalWeight += d.Weight;
					}

					_weight = totalWeight / this.m.DamageType.len();
				}
				else
				{
					_weight = 100;
				}
			}

			this.m.DamageType.push({Type = _damageType, Weight = _weight});
		}

		o.hasDamageType <- function( _damageType, _only = false )
		{
			foreach (d in this.m.DamageType)
			{
				if (d.Type == _damageType)
				{
					return _only ? this.m.DamageType.len() == 1 : true;
				}
			}

			return false;
		}

		o.getDamageTypeWeight <- function( _damageType )
		{
			foreach (d in this.m.DamageType)
			{
				if (d.Type = _damageType)
				{
					return d.Weight;
				}
			}

			return null;
		}

		o.getDamageTypeProbability <- function ( _damageType )
		{
			local totalWeight = 0;
			local weight = null;

			foreach (d in this.m.DamageType)
			{
				totalWeight += d.Weight;

				if (d.Type == _damageType)
				{
					weight = d.Weight;
				}
			}

			return weight == null ? null : weight.tofloat() / totalWeight;
		}

		o.getDamageType <- function()
		{
			return this.m.DamageType;
		}

		o.getWeightedRandomDamageType <- function()
		{
			local totalWeight = 0;
			foreach (d in this.m.DamageType)
			{
				totalWeight += d.Weight;
			}

			local roll = this.Math.rand(1, totalWeight);

			foreach (d in this.m.DamageType)
			{
				if (roll <= d.Weight)
				{
					return d.Type;
				}

				roll -= d.Weight;
			}
		}

		o.setupDamageType <- function()
		{
			switch (this.m.InjuriesOnBody)
			{
				case this.Const.Injury.BluntBody:
					this.addDamageType(this.Const.Damage.DamageType.Blunt);
					break;
				case this.Const.Injury.PiercingBody:
					this.addDamageType(this.Const.Damage.DamageType.Piercing);
					break;
				case this.Const.Injury.CuttingBody:
					this.addDamageType(this.Const.Damage.DamageType.Cutting);
					break;
				case this.Const.Injury.BurningBody:
					this.addDamageType(this.Const.Damage.DamageType.Burning);
					break;
				case this.Const.Injury.BluntAndPiercingBody:
					this.addDamageType(this.Const.Damage.DamageType.Blunt, 55);
					this.addDamageType(this.Const.Damage.DamageType.Piercing, 45);
					break;
				case this.Const.Injury.BurningAndPiercingBody:
					this.addDamageType(this.Const.Damage.DamageType.Burning, 25);
					this.addDamageType(this.Const.Damage.DamageType.Piercing, 75)
					break;
				case this.Const.Injury.CuttingAndPiercingBody:
					this.addDamageType(this.Const.Damage.DamageType.Cutting);
					this.addDamageType(this.Const.Damage.DamageType.Piercing);
					break;
			}
		}

		local getDescription = o.getDescription;
		o.getDescription = function()
		{
			if (this.m.DamageType.len() == 0)
			{
				return getDescription();
			}

			local ret = "[color=" + this.Const.UI.Color.NegativeValue + "]Inflicts ";			

			foreach (d in this.m.DamageType)
			{
				local probability = this.Math.round(this.getDamageTypeProbability(d.Type) * 100);

				if (probability < 100)
				{
					ret += probability + "% ";
				}
				
				ret += this.Const.Damage.getDamageTypeName(d.Type) + ", ";
			}

			ret = ret.slice(0, -2);

			ret += " Damage [/color]\n\n" + getDescription();

			return ret;
		}

		local getHitFactors = o.getHitFactors;
		o.getHitFactors = function( _targetTile )
		{
			local ret = getHitFactors(_targetTile);			
			this.getContainer().onGetHitFactors(this, _targetTile, ret);
			return ret;
		}

		o.getDefaultRangedTooltip <- function()
		{
			local ret = this.getDefaultTooltip();

			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if shooting downhill"
			});

			local accuText = "";
			if (this.m.AdditionalAccuracy != 0)
			{
				accuText = "Has [color=" + (this.m.AdditionalAccuracy > 0 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue) + "]+" + this.m.AdditionalAccuracy + "%[/color] chance to hit";
			}

			if (this.m.AdditionalHitChance != 0)
			{
				accuText += this.m.AdditionalAccuracy == 0 ? "Has" : ", and";
				local additionalHitChance = this.m.AdditionalHitChance + this.getContainer().getActor().getCurrentProperties().HitChanceAdditionalWithEachTile;
				accuText += " [color=" + (additionalHitChance > 0 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue) + "]" + additionalHitChance + "%[/color]";
				accuText += this.m.AdditionalAccuracy == 0 ? " chance to hit " : "";
				accuText += " per tile of distance";
			}

			if (accuText.len() != 0)
			{
				ret.push({
					id = 7,
					type = "text",
					icon = "ui/icons/hitchance.png",
					text = accuText
				});
			}

			return ret;
		}

		// o.getShieldBonus <- function( _skill, _targetEntity )
		// {
		// 	local shieldBonus = 0;
		// 	local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		// 	if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
		// 	{
		// 		shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);				

		// 		if (_targetEntity.getSkills().hasSkill("effects.shieldwall"))
		// 		{
		// 			shieldBonus *= 2;
		// 		}
		// 	}

		// 	return shieldBonus;
		// }

		// o.getShieldRelevantHitChanceBonus <- function( _skill, _targetEntity )
		// {
		// 	local bonus = 0;

		// 	if (!_skill.m.IsShieldRelevant)
		// 	{
		// 		local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		// 		if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
		// 		{
		// 			local shieldBonus = this.getShieldBonus(_skill, _targetEntity);
		// 			local hasShieldwall = _targetEntity.getSkills().hasSkill("effects.shieldwall");

		// 			if (hasShieldwall)
		// 			{
		// 				shieldBonus /= 2;
		// 			}

		// 			bonus += shieldBonus;

		// 			if (!_skill.m.IsShieldwallRelevant && hasShieldwall)
		// 			{
		// 				bonus += shieldBonus;
		// 			}
		// 		}
		// 	}

		// 	return bonus;
		// }

		// o.getHitchance = function( _targetEntity )
		// {
		// 	if (!_targetEntity.isAttackable())
		// 	{
		// 		return 0;
		// 	}

		// 	local user = this.m.Container.getActor();
		// 	local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);

		// 	if (!this.isUsingHitchance())
		// 	{
		// 		return 100;
		// 	}

		// 	local allowDiversion = this.m.IsRanged && this.m.MaxRangeBonus > 1;
		// 	local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
		// 	local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
		// 	local defense = _targetEntity.getDefense(user, this, defenderProperties);
		// 	local levelDifference = _targetEntity.getTile().Level - user.getTile().Level;
		// 	local distanceToTarget = user.getTile().getDistanceTo(_targetEntity.getTile());
		// 	local toHit = skill - defense;

		// 	if (this.m.IsRanged)
		// 	{
		// 		toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
		// 	}

		// 	if (levelDifference < 0)
		// 	{
		// 		toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
		// 	}
		// 	else
		// 	{
		// 		toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
		// 	}

		// 	toHit += this.getShieldRelevantHitChanceBonus(this, _targetEntity);

		// 	toHit = toHit * properties.TotalAttackToHitMult;
		// 	toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);
		// 	local userTile = user.getTile();

		// 	if (allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		// 	{
		// 		local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), user.getFaction(), true);

		// 		if (blockedTiles.len() != 0)
		// 		{
		// 			local blockChance = this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult;
		// 			toHit = this.Math.floor(toHit * (1.0 - blockChance));
		// 		}
		// 	}

		// 	return this.Math.max(5, this.Math.min(95, toHit));
		// }

		// o.attackEntity = function( _user, _targetEntity, _allowDiversion = true, _isDiverting = false )
		// {
		// 	if (_targetEntity != null && !_targetEntity.isAlive())
		// 	{
		// 		return false;
		// 	}

		// 	local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		// 	local userTile = _user.getTile();
		// 	local astray = false;

		// 	if (_allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		// 	{
		// 		local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), _user.getFaction());

		// 		if (blockedTiles.len() != 0 && this.Math.rand(1, 100) <= this.Math.ceil(this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult * 100))
		// 		{
		// 			_allowDiversion = false;
		// 			astray = true;
		// 			_targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
		// 		}
		// 	}

		// 	if (!_targetEntity.isAttackable())
		// 	{
		// 		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		// 		{
		// 			local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

		// 			if (_user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
		// 			{
		// 				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		// 			}
		// 		}

		// 		return false;
		// 	}

		// 	local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		// 	local defense = _targetEntity.getDefense(_user, this, defenderProperties);
		// 	local levelDifference = _targetEntity.getTile().Level - _user.getTile().Level;
		// 	local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
		// 	local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		// 	local shieldBonus = this.getShieldBonus(this, _targetEntity);

		// 	local toHit = this.getHitchance(_targetEntity);

		// 	if (_isDiverting && this.m.IsRanged && !_allowDiversion && this.m.IsShowingProjectile)
		// 	{
		// 		toHit = toHit - this.Const.Combat.DivertedAttackHitChancePenalty;
		// 		properties.DamageTotalMult *= this.Const.Combat.DivertedAttackDamageMult;
		// 	}

		// 	_targetEntity.onAttacked(_user);
		// 	_targetEntity.getSkills().onAttacked(this, _user);

		// 	if (this.m.IsDoingAttackMove && !_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		// 	{
		// 		this.Tactical.getShaker().cancel(_user);

		// 		if (this.m.IsDoingForwardMove)
		// 		{
		// 			this.Tactical.getShaker().shake(_user, _targetEntity.getTile(), 5);
		// 		}
		// 		else
		// 		{
		// 			local otherDir = _targetEntity.getTile().getDirectionTo(_user.getTile());

		// 			if (_user.getTile().hasNextTile(otherDir))
		// 			{
		// 				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(otherDir), 6);
		// 			}
		// 		}
		// 	}

		// 	if (!_targetEntity.isAbleToDie() && _targetEntity.getHitpoints() == 1)
		// 	{
		// 		toHit = 0;
		// 	}

		// 	local r = this.Math.rand(1, 100);

		// 	if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == 0)
		// 	{
		// 		if (_user.isPlayerControlled())
		// 		{
		// 			r = this.Math.max(1, r - 5);
		// 		}
		// 		else if (_targetEntity.isPlayerControlled())
		// 		{
		// 			r = this.Math.min(100, r + 5);
		// 		}
		// 	}

		// 	local isHit = r <= toHit;

		// 	if (!_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		// 	{
		// 		local rolled = r;
		// 		this.Tactical.EventLog.log_newline();

		// 		if (astray)
		// 		{
		// 			if (this.isUsingHitchance())
		// 			{
		// 				if (isHit)
		// 				{
		// 					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
		// 				}
		// 				else
		// 				{
		// 					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
		// 				}
		// 			}
		// 			else
		// 			{
		// 				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
		// 			}
		// 		}
		// 		else if (this.isUsingHitchance())
		// 		{
		// 			if (isHit)
		// 			{
		// 				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
		// 			}
		// 			else
		// 			{
		// 				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
		// 			}
		// 		}
		// 		else
		// 		{
		// 			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
		// 		}
		// 	}

		// 	if (isHit && this.Math.rand(1, 100) <= _targetEntity.getCurrentProperties().RerollDefenseChance)
		// 	{
		// 		r = this.Math.rand(1, 100);
		// 		isHit = r <= toHit;
		// 	}

		// 	if (isHit)
		// 	{
		// 		this.getContainer().setBusy(true);
		// 		local info = {
		// 			Skill = this,
		// 			Container = this.getContainer(),
		// 			User = _user,
		// 			TargetEntity = _targetEntity,
		// 			Properties = properties,
		// 			DistanceToTarget = distanceToTarget
		// 		};

		// 		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || !_targetEntity.isHiddenToPlayer()))
		// 		{
		// 			local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
		// 			local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		// 			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledTargetHit, info);

		// 			if (this.m.SoundOnHit.len() != 0)
		// 			{
		// 				this.Time.scheduleEvent(this.TimeUnit.Virtual, time + this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
		// 					Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
		// 					Pos = _targetEntity.getPos()
		// 				});
		// 			}
		// 		}
		// 		else
		// 		{
		// 			if (this.m.SoundOnHit.len() != 0)
		// 			{
		// 				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
		// 			}

		// 			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && toHit <= 15)
		// 			{
		// 				this.Sound.play(this.Const.Sound.ArenaShock[this.Math.rand(0, this.Const.Sound.ArenaShock.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
		// 			}

		// 			this.onScheduledTargetHit(info);
		// 		}

		// 		return true;
		// 	}
		// 	else
		// 	{
		// 		local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
		// 		_targetEntity.onMissed(_user, this, this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2);
		// 		this.m.Container.onTargetMissed(this, _targetEntity);
		// 		local prohibitDiversion = false;

		// 		if (_allowDiversion && this.m.IsRanged && !_user.isPlayerControlled() && this.Math.rand(1, 100) <= 25 && distanceToTarget > 2)
		// 		{
		// 			local targetTile = _targetEntity.getTile();

		// 			for( local i = 0; i < this.Const.Direction.COUNT; i++ )
		// 			{
		// 				if (targetTile.hasNextTile(i))
		// 				{
		// 					local tile = targetTile.getNextTile(i);

		// 					if (!tile.IsEmpty && tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_user))
		// 					{
		// 						prohibitDiversion = true;
		// 						break;
		// 					}
		// 				}
		// 			}
		// 		}

		// 		if (_allowDiversion && this.m.IsRanged && !(this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2) && !prohibitDiversion && distanceToTarget > 2)
		// 		{
		// 			this.divertAttack(_user, _targetEntity);
		// 		}
		// 		else if (this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2)
		// 		{
		// 			local info = {
		// 				Skill = this,
		// 				User = _user,
		// 				TargetEntity = _targetEntity,
		// 				Shield = shield
		// 			};

		// 			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		// 			{
		// 				local divertTile = _targetEntity.getTile();
		// 				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
		// 				local time = 0;

		// 				if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
		// 				{
		// 					time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		// 				}

		// 				this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onShieldHit, info);
		// 			}
		// 			else
		// 			{
		// 				this.onShieldHit(info);
		// 			}
		// 		}
		// 		else
		// 		{
		// 			if (this.m.SoundOnMiss.len() != 0)
		// 			{
		// 				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
		// 			}

		// 			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		// 			{
		// 				local divertTile = _targetEntity.getTile();
		// 				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

		// 				if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
		// 				{
		// 					this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		// 				}
		// 			}

		// 			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
		// 			{
		// 				if (toHit >= 90 || _targetEntity.getHitpointsPct() <= 0.1)
		// 				{
		// 					this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaBigMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
		// 				}
		// 				else if (this.Math.rand(1, 100) <= 20)
		// 				{
		// 					this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
		// 				}
		// 			}
		// 		}

		// 		return false;
		// 	}
		// }

		// o.divertAttack = function( _user, _targetEntity )
		// {
		// 	local tile = _targetEntity.getTile();
		// 	local dist = _user.getTile().getDistanceTo(tile);

		// 	if (dist < this.Const.Combat.DiversionMinDist)
		// 	{
		// 		return;
		// 	}

		// 	local d = _user.getTile().getDirectionTo(tile);

		// 	if (dist >= this.Const.Combat.DiversionSpreadMinDist)
		// 	{
		// 		d = this.Math.rand(0, this.Const.Direction.COUNT - 1);
		// 	}

		// 	if (tile.hasNextTile(d))
		// 	{
		// 		local divertTile = tile.getNextTile(d);
		// 		local levelDifference = divertTile.Level - _targetEntity.getTile().Level;

		// 		if (divertTile.IsOccupiedByActor && levelDifference <= this.Const.Combat.DiversionMaxLevelDifference)
		// 		{
		// 			this.attackEntity(_user, divertTile.getEntity(), false, true);
		// 		}
		// 		else
		// 		{
		// 			local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
		// 			local time = 0;

		// 			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(tile) >= this.Const.Combat.SpawnProjectileMinDist)
		// 			{
		// 				time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
		// 			}

		// 			this.getContainer().setBusy(true);

		// 			if (this.m.SoundOnMiss.len() != 0)
		// 			{
		// 				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, divertTile.Pos);
		// 			}

		// 			if (divertTile.IsEmpty && !divertTile.IsCorpseSpawned && this.Const.Tactical.TerrainSubtypeAllowProjectileDecals[divertTile.Subtype] && this.Const.ProjectileDecals[this.m.ProjectileType].len() != 0 && this.Math.rand(0, 100) < this.Const.Combat.SpawnArrowDecalChance)
		// 			{
		// 				local info = {
		// 					Skill = this,
		// 					Container = this.getContainer(),
		// 					User = _user,
		// 					TileHit = divertTile
		// 				};

		// 				if (this.m.IsShowingProjectile && _user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || divertTile.IsVisibleForPlayer))
		// 				{
		// 					this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledProjectileSpawned, info);
		// 				}
		// 				else
		// 				{
		// 					this.onScheduledProjectileSpawned(info);
		// 				}
		// 			}
		// 		}
		// 	}
		// }

		// o.onScheduledTargetHit = function( _info )
		// {
		// 	_info.Container.setBusy(false);

		// 	if (!_info.TargetEntity.isAlive())
		// 	{
		// 		return;
		// 	}

		// 	local partHit = this.Math.rand(1, 100);
		// 	local bodyPart = this.Const.BodyPart.Body;
		// 	local bodyPartDamageMult = 1.0;

		// 	if (partHit <= _info.Properties.getHitchance(this.Const.BodyPart.Head))
		// 	{
		// 		bodyPart = this.Const.BodyPart.Head;
		// 	}
		// 	else
		// 	{
		// 		bodyPart = this.Const.BodyPart.Body;
		// 	}

		// 	bodyPartDamageMult = bodyPartDamageMult * _info.Properties.DamageAgainstMult[bodyPart];
		// 	local damageMult = this.m.IsRanged ? _info.Properties.RangedDamageMult : _info.Properties.MeleeDamageMult;
		// 	damageMult = damageMult * _info.Properties.DamageTotalMult;
		// 	local damageRegular = this.Math.rand(_info.Properties.DamageRegularMin, _info.Properties.DamageRegularMax) * _info.Properties.DamageRegularMult;
		// 	local damageArmor = this.Math.rand(_info.Properties.DamageRegularMin, _info.Properties.DamageRegularMax) * _info.Properties.DamageArmorMult;
		// 	damageRegular = this.Math.max(0, damageRegular + _info.DistanceToTarget * _info.Properties.DamageAdditionalWithEachTile);
		// 	damageArmor = this.Math.max(0, damageArmor + _info.DistanceToTarget * _info.Properties.DamageAdditionalWithEachTile);
		// 	local damageDirect = this.Math.minf(1.0, _info.Properties.DamageDirectMult * (this.m.DirectDamageMult + _info.Properties.DamageDirectAdd));
		// 	local injuries;

		// 	if (this.m.InjuriesOnBody != null && bodyPart == this.Const.BodyPart.Body)
		// 	{
		// 		if (_info.TargetEntity.getFlags().has("skeleton"))
		// 		{
		// 			injuries = this.Const.Injury.SkeletonBody;
		// 		}
		// 		else
		// 		{
		// 			injuries = this.m.InjuriesOnBody;
		// 		}
		// 	}
		// 	else if (this.m.InjuriesOnHead != null && bodyPart == this.Const.BodyPart.Head)
		// 	{
		// 		if (_info.TargetEntity.getFlags().has("skeleton"))
		// 		{
		// 			injuries = this.Const.Injury.SkeletonHead;
		// 		}
		// 		else
		// 		{
		// 			injuries = this.m.InjuriesOnHead;
		// 		}
		// 	}

		// 	local hitInfo = clone this.Const.Tactical.HitInfo;
		// 	hitInfo.DamageRegular = damageRegular * damageMult;
		// 	hitInfo.DamageArmor = damageArmor * damageMult;
		// 	hitInfo.DamageDirect = damageDirect;
		// 	hitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit * _info.Properties.FatigueDealtPerHitMult;
		// 	hitInfo.DamageMinimum = _info.Properties.DamageMinimum;
		// 	hitInfo.BodyPart = bodyPart;
		// 	hitInfo.BodyDamageMult = bodyPartDamageMult;
		// 	hitInfo.FatalityChanceMult = _info.Properties.FatalityChanceMult;
		// 	hitInfo.Injuries = injuries;
		// 	hitInfo.InjuryThresholdMult = _info.Properties.ThresholdToInflictInjuryMult;
		// 	hitInfo.Tile = _info.TargetEntity.getTile();
		// 	_info.Container.onBeforeTargetHit(_info.Skill, _info.TargetEntity, hitInfo);
		// 	local pos = _info.TargetEntity.getPos();
		// 	local hasArmorHitSound = _info.TargetEntity.getItems().getAppearance().ImpactSound[bodyPart].len() != 0;
		// 	_info.TargetEntity.onDamageReceived(_info.User, _info.Skill, hitInfo);

		// 	if (hitInfo.DamageInflictedHitpoints >= this.Const.Combat.PlayHitSoundMinDamage)
		// 	{
		// 		if (this.m.SoundOnHitHitpoints.len() != 0)
		// 		{
		// 			this.Sound.play(this.m.SoundOnHitHitpoints[this.Math.rand(0, this.m.SoundOnHitHitpoints.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, pos);
		// 		}
		// 	}

		// 	if (hitInfo.DamageInflictedHitpoints == 0 && hitInfo.DamageInflictedArmor >= this.Const.Combat.PlayHitSoundMinDamage)
		// 	{
		// 		if (this.m.SoundOnHitArmor.len() != 0)
		// 		{
		// 			this.Sound.play(this.m.SoundOnHitArmor[this.Math.rand(0, this.m.SoundOnHitArmor.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, pos);
		// 		}
		// 	}

		// 	if (typeof _info.User == "instance" && _info.User.isNull() || !_info.User.isAlive() || _info.User.isDying())
		// 	{
		// 		return;
		// 	}

		// 	_info.TargetEntity.getSkills().onHit(_info.Skill, _info.User, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
		// 	_info.Container.onTargetHit(_info.Skill, _info.TargetEntity, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
		// 	_info.User.getItems().onDamageDealt(_info.TargetEntity, this, hitInfo);

		// 	if (hitInfo.DamageInflictedHitpoints >= this.Const.Combat.SpawnBloodMinDamage && !_info.Skill.isRanged() && (_info.TargetEntity.getBloodType() == this.Const.BloodType.Red || _info.TargetEntity.getBloodType() == this.Const.BloodType.Dark))
		// 	{
		// 		_info.User.addBloodied();
		// 		local item = _info.User.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		// 		if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		// 		{
		// 			item.setBloodied(true);
		// 		}
		// 	}
		// }
	});
}
