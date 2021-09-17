local gt = this.getroottable();

gt.MSU.modSkill <- function ()
{
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

		o.getDefaultRangedTooltip <- function()
		{
			local ret = this.getDefaultTootip();

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
				accuText += accuText.len() == 0 ? "Has" : ", and";
				accuText += "[color=" + (this.m.AdditionalHitChance > 0 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue) + "]" + this.m.AdditionalHitChance + "%[/color] per tile of distance";
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
	});
}
