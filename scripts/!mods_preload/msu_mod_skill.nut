local gt = this.getroottable();

gt.Const.MSU.modSkill <- function ()
{
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

		local getDescription = ::mods_getMember(o, "getDescription");
		::mods_override(o, "getDescription", function() {
			if (this.m.DamageType.len() == 0)
			{
				return getDescription();
			}

			local ret = "[color=" + this.Const.UI.Color.NegativeValue + "]Inflicts ";

			local totalWeight = 0;
			foreach (d in this.m.DamageType)
			{
				totalWeight += d.Weight;
			}

			foreach (d in this.m.DamageType)
			{
				foreach (damageTypeName, v in this.Const.Damage.DamageType)
				{
					if (d.Type == v)
					{
						local probability = this.Math.round(100.0 * d.Weight) / totalWeight;
						ret += probability < 100 ? probability + "% " : "";
						ret += damageTypeName + ", ";
						break;
					}
				}
			}

			ret = ret.slice(0, -2);

			ret += " Damage [/color]\n\n" + getDescription();

			return ret;
		});
	});

	::mods_hookBaseClass("skills/skill", function(o) {
		o = o[o.SuperName];

		o.m.DamageType <- [];

		o.m.IsBaseValuesSaved <- false;
		o.m.ScheduledChanges <- [];

		o.m.scheduleChange <- function( _field, _change, _set = true )
		{
			this.ScheduledChanges.push({Field = _field, Change = _change, Set = _set});
		}

		o.m.executeScheduledChanges <- function()
		{
			if (this.ScheduledChanges.len() == 0)
			{
				return;
			}

			foreach (c in this.ScheduledChanges)
			{
				switch (typeof c.Change)
				{
					case "integer":
						if (c.Set)
						{
							this[c.Field] = c.Change;
						}
						else
						{
							this[c.Field] += c.Change;
						}

						break;

					case "string":
						if (c.Set)
						{
							this[c.Field] = c.Change;
						}
						else
						{
							this[c.Field] += c.Change;
						}
						break;

					default:
						this[c.Field] = c.Change;
						break;
				}
			}

			this.ScheduledChanges.clear();
		}

		o.saveBaseValues <- function()
		{
			if (this.m.IsBaseValuesSaved)
			{
				return;
			}

			this.m.b <- clone this.skill.m;
			this.m.IsBaseValuesSaved = true;
		}

		o.softReset <- function()
		{
			if (!this.m.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod softReset() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}

			this.m.ActionPointCost = this.m.b.ActionPointCost;
			this.m.FatigueCost = this.m.b.FatigueCost;
			this.m.FatigueCostMult = this.m.b.FatigueCostMult;
			this.m.MinRange = this.m.b.MinRange;
			this.m.MaxRange = this.m.b.MaxRange;

			return true;
		}

		o.m.hardReset <- function()
		{
			if (!this.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod hardReset() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}

			foreach (k, v in this.b)
			{
				this[k] = v;
			}

			return true;
		}

		o.m.resetField <- function( _field )
		{
			if (!this.IsBaseValuesSaved)
			{
				this.logWarning("MSU Mod resetField() skill \"" + this.ID + "\" does not have base values saved.");
				return false;
			}

			this[_field] = this.b[_field];

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

		o.onAnySkillExecuted <- function(_skill, _targetTile)
		{
		}

		o.onBeforeAnySkillExecuted <- function(_skill, _targetTile)
		{
		}

		local use = o.use;
		o.use = function( _targetTile, _forFree = false )
		{
			# Save the container as a local variable because some skills delete
			# themselves during use (e.g. Reload Bolt) causing this.m.Container
			# to point to null.
			local container = this.m.Container;

			container.onBeforeAnySkillExecuted(this, _targetTile);

			local ret = use( _targetTile, _forFree );

			container.onAnySkillExecuted(this, _targetTile);

			return ret;
		}

		o.removeDamageType <- function(_damageType)
		{
			for (local i = 0; i < this.m.DamageType.len(); i++)
			{
				if (this.m.DamageType[i].DamageType == _damageType)
				{
					this.m.DamageType.remove(i);
				}
			}
		}

		o.setDamageTypeWeight <- function(_damageType, _weight)
		{
			foreach (d in this.m.DamageType)
			{
				if (d.Type == _damageType)
				{
					d.Weight = _weight;
				}
			}
		}

		o.addDamageType <- function(_damageType, _weight = null)
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

		o.hasDamageType <- function(_damageType, _only = false)
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

		o.getDamageTypeWeight <- function(_damageType)
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
	});
}
