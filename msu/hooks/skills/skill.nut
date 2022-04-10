::mods_hookDescendants("skills/skill", function(o) {
	if ("create" in o)
	{
		local create = o.create;
		o.create = function()
		{
			create();
			if (this.m.DamageType.len() == 0)
			{
				switch (this.m.InjuriesOnBody)
				{
					case null:
						return;

					case ::Const.Injury.BluntBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Blunt);
						break;

					case ::Const.Injury.PiercingBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Piercing);
						break;

					case ::Const.Injury.CuttingBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Cutting);
						break;

					case ::Const.Injury.BurningBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Burning);
						break;

					case ::Const.Injury.BluntAndPiercingBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Blunt, 55);
						this.m.DamageType.add(::Const.Damage.DamageType.Piercing, 45);
						break;

					case ::Const.Injury.BurningAndPiercingBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Burning, 25);
						this.m.DamageType.add(::Const.Damage.DamageType.Piercing, 75);
						break;

					case ::Const.Injury.CuttingAndPiercingBody:
						this.m.DamageType.add(::Const.Damage.DamageType.Cutting);
						this.m.DamageType.add(::Const.Damage.DamageType.Piercing);
						break;
				}
			}
		}
	}
});

::mods_hookBaseClass("skills/skill", function(o) {
	o = o[o.SuperName];

	o.m.DamageType <- ::MSU.Class.WeightedContainer();
	o.m.ItemActionOrder <- ::Const.ItemActionOrder.Any;

	o.m.IsBaseValuesSaved <- false;
	o.m.ScheduledChanges <- [];

	o.scheduleChange <- function( _field, _change, _set = false )
	{
		this.m.ScheduledChanges.push({Field = _field, Change = _change, Set = _set});
		this.getContainer().m.ScheduledChangesSkills.push(this);
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
				case "string":
					if (c.Set) this.m[c.Field] = c.Change;
					else this.m[c.Field] += c.Change;
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
		if (!this.m.IsBaseValuesSaved)
		{
			this.b <- clone this.skill.m;
			foreach (k, v in this.m)
			{
				this.b[k] <- v;
			}
			this.m.IsBaseValuesSaved = true;
		}
	}

	o.getBaseValue <- function( _field )
	{
		return this.b[_field];
	}

	o.setBaseValue <- function( _field, _value )
	{
		this.b[_field] = _value;
	}

	o.softReset <- function()
	{
		if (!this.m.IsBaseValuesSaved)
		{
			::logWarning("MSU Mod softReset() skill \"" + this.getID() + "\" does not have base values saved.");
			::MSU.Log.printStackTrace();
			return false;
		}

		this.m.ActionPointCost = this.b.ActionPointCost;
		this.m.FatigueCost = this.b.FatigueCost;
		this.m.FatigueCostMult = this.b.FatigueCostMult;
		this.m.MinRange = this.b.MinRange;
		this.m.MaxRange = this.b.MaxRange;

		return true;
	}

	o.hardReset <- function( _exclude = null )
	{
		if (!this.m.IsBaseValuesSaved)
		{
			::logWarning("MSU Mod hardReset() skill \"" + this.getID() + "\" does not have base values saved.");
			::MSU.Log.printStackTrace();
			return false;
		}

		if (_exclude == null) _exclude = [];
		::MSU.requireArray(_exclude);

		local toExclude = ["IsNew", "Order", "Type"];
		toExclude.extend(_exclude);

		foreach (k, v in this.b)
		{
			if (toExclude.find(k) == null) this.m[k] = v;
		}

		return true;
	}

	o.resetField <- function( _field )
	{
		if (!this.m.IsBaseValuesSaved)
		{
			::logWarning("MSU Mod resetField(\"" + _field + "\") skill \"" + this.getID() + "\" does not have base values saved.");
			::MSU.Log.printStackTrace();
			return false;
		}

		this.m[_field] = this.b[_field];

		return true;
	}

	local setContainer = o.setContainer;
	o.setContainer = function( _c )
	{
		if (_c != null)
		{
			this.saveBaseValues();
		}

		setContainer(_c);
	}

	o.onMovementStarted <- function( _tile, _numTiles )
	{
	}

	o.onMovementFinished <- function( _tile )
	{
	}

	o.onMovementStep <- function( _tile, _levelDifference )
	{
	}

	o.onAfterDamageReceived <- function()
	{
	}

	o.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
	}

	o.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
	}

	o.onUpdateLevel <- function()
	{
	}

	o.getItemActionCost <- function( _items )
	{
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

	o.onDeathWithInfo <- function( _killer, _skill, _deathTile, _corpseTile, _fatalityType )
	{
	}

	o.onOtherActorDeath <- function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{			
	}

	o.onEnterSettlement <- function( _settlement )
	{		
	}

	local use = o.use;
	o.use = function( _targetTile, _forFree = false )
	{
		// Save the container as a local variable because some skills delete
		// themselves during use (e.g. Reload Bolt) causing this.m.Container
		// to point to null.
		local container = this.m.Container;
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;

		container.onBeforeAnySkillExecuted(this, _targetTile, targetEntity, _forFree);

		local ret = use(_targetTile, _forFree);

		container.onAnySkillExecuted(this, _targetTile, targetEntity, _forFree);

		return ret;
	}

	o.getDamageType <- function()
	{
		return this.m.DamageType;
	}

	o.verifyTargetAndRange <- function( _targetTile, _origin = null )
	{
		if (_origin == null)
		{
			_origin = this.getContainer().getActor().getTile();	
		}
		
		return this.onVerifyTarget(_origin, _targetTile) && this.isInRange(_targetTile, _origin);
	}

	local getDescription = o.getDescription;
	o.getDescription = function()
	{
		if (this.m.DamageType.len() == 0 || !::MSU.Mod.ModSettings.getSetting("ExpandedSkillDescriptions").getValue())
		{
			return getDescription();
		}

		local ret = "[color=" + ::Const.UI.Color.NegativeValue + "]Inflicts ";

		foreach (d in this.m.DamageType)
		{
			local probability = ::Math.round(this.m.DamageType.getProbability(d.Type) * 100);

			if (probability < 100)
			{
				ret += probability + "% ";
			}
			
			ret += ::Const.Damage.getDamageTypeName(d.Type) + ", ";
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

	o.getRangedTooltip <- function()
	{
		local tooltip = [];
		
		local rangeBonus = ", more";
		if (this.m.MaxRangeBonus == 0)
		{
			rangeBonus = " or"
		}
		else if (this.m.MaxRangeBonus < 0)
		{
			rangeBonus = ", less"
		}

		tooltip.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground" + rangeBonus + " if shooting downhill"
		});

		local accuText = "";
		if (this.m.AdditionalAccuracy != 0)
		{
			local color = this.m.AdditionalAccuracy > 0 ? ::Const.UI.Color.PositiveValue : ::Const.UI.Color.NegativeValue;
			local sign = this.m.AdditionalAccuracy > 0 ? "+" : "";
			accuText = "Has [color=" + color + "]" + sign + this.m.AdditionalAccuracy + "%[/color] chance to hit";
		}

		if (this.m.AdditionalHitChance != 0)
		{
			accuText += this.m.AdditionalAccuracy == 0 ? "Has" : ", and";
			local additionalHitChance = this.m.AdditionalHitChance + this.getContainer().getActor().getCurrentProperties().HitChanceAdditionalWithEachTile;
			local sign = additionalHitChance > 0 ? "+" : "";
			accuText += " [color=" + (additionalHitChance > 0 ? ::Const.UI.Color.PositiveValue : ::Const.UI.Color.NegativeValue) + "]" + sign + additionalHitChance + "%[/color]";
			accuText += this.m.AdditionalAccuracy == 0 ? " chance to hit " : "";
			accuText += " per tile of distance";
		}

		if (accuText.len() != 0)
		{
			tooltip.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = accuText
			});
		}

		return tooltip;
	}
});
