::mods_hookNewObject("skills/skill_container", function(o) {
	o.m.BeforeSkillExecutedTile <- null;
	o.m.IsExecutingMoveSkill <- false;

	local update = o.update;
	o.update = function()
	{
		if (this.m.IsUpdating || !this.m.Actor.isAlive())
		{
			return;
		}

		foreach (skill in this.m.Skills)
		{
			skill.softReset();
		}

		update();

		foreach (skill in this.m.Skills)
		{
			skill.executeScheduledChanges();
		}
	}

	o.doOnFunction <- function( _function, _argsArray = null, _update = true, _aliveOnly = false )
	{
		if (_argsArray == null) _argsArray = [null];
		else _argsArray.insert(0, null);

		local wasUpdating = this.m.IsUpdating;
		this.m.IsUpdating = true;
		this.m.IsBusy = false;
		this.m.BusyStack = 0;

		foreach (skill in this.m.Skills)
		{
			if (_aliveOnly && !this.m.Actor.isAlive())
			{
				break;
			}

			if (!skill.isGarbage())
			{
				_argsArray[0] = skill;
				skill[_function].acall(_argsArray);
			}
		}

		this.m.IsUpdating = wasUpdating;
		
		if (_update)
		{
			this.update();
		}
	}

	o.doOnFunctionWhenAlive <- function( _function, _argsArray = null, _update = true )
	{
		this.doOnFunction(_function, _argsArray, _update, true);
	}

	o.buildProperties <- function( _function, _argsArray )
	{
		_argsArray.insert(0, null);
		_argsArray.push(this.m.Actor.getCurrentProperties().getClone());

		local wasUpdating = this.m.IsUpdating;
		this.m.IsUpdating = true;

		foreach (skill in this.m.Skills)
		{
			_argsArray[0] = skill;
			skill[_function].acall(_argsArray);
		}
		this.m.IsUpdating = wasUpdating;
		return _argsArray[_argsArray.len() - 1];
	}

	o.onMovementStarted <- function( _tile, _numTiles )
	{
		this.doOnFunction("onMovementStarted", [
			_tile,
			_numTiles
		]);
	}

	o.onMovementFinished <- function( _tile )
	{
		this.doOnFunction("onMovementFinished", [
			_tile
		]);
	}

	o.onMovementStep <- function( _tile, _levelDifference )
	{
		this.doOnFunction("onMovementStep", [
			_tile,
			_levelDifference
		], false);
	}

	o.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		// Don't update if using a movement skill e.g. Rotation because this leads
		// to crashes if any skill tries to access the current tile in its onUpdate
		// function as the tile at this point is not a valid tile.
		this.m.IsExecutingMoveSkill = !this.getActor().getTile().isSameTileAs(this.m.BeforeSkillExecutedTile);
		this.m.BeforeSkillExecutedTile = null;

		this.doOnFunction("onAnySkillExecuted", [
			_skill,
			_targetTile,
			_targetEntity,
			_forFree
		], !this.m.IsExecutingMoveSkill);

		this.m.IsExecutingMoveSkill = false;
	}

	o.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.BeforeSkillExecutedTile = this.getActor().getTile();
		this.doOnFunction("onBeforeAnySkillExecuted", [
			_skill,
			_targetTile,
			_targetEntity,
			_forFree
		]);
	}

	// o.onAttacked <- function( _skill, _attacker )
	// {
	// 	this.doOnFunction("onAttacked", [
	// 		_skill,
	// 		_attacker
	// 	]);
	// }

	// o.onHit <- function( _skill, _attacker, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	// {
	// 	this.doOnFunction("onHit", [
	// 		_skill,
	// 		_attacker,
	// 		_bodyPart,
	// 		_damageInflictedHitpoints,
	// 		_damageInflictedArmor
	// 	]);
	// }

	o.onUpdateLevel <- function()
	{
		this.doOnFunction("onUpdateLevel");
	}

	o.onNewMorning <- function()
	{
		this.doOnFunctionWhenAlive("onNewMorning");
	}

	o.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		this.doOnFunction("onGetHitFactors", [
			_skill,
			_targetTile,
			_tooltip
		], false);
	}

	o.onQueryTooltip <- function( _skill, _tooltip )
	{
		this.doOnFunction("onQueryTooltip", [
			_skill,
			_tooltip
		], false);
	}

	o.onDeathWithInfo <- function( _killer, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		this.doOnFunction("onDeathWithInfo", [
			_killer,
			_skill,
			_deathTile,
			_corpseTile,
			_fatalityType
		], false);
	}

	o.onOtherActorDeath <- function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		this.doOnFunction("onOtherActorDeath", [
			_killer,
			_victim,
			_skill,
			_deathTile,
			_corpseTile,
			_fatalityType
		]);
	}

	o.onEnterSettlement <- function( _settlement )
	{
		this.doOnFunction("onEnterSettlement", [
			_settlement
		]);
	}

	//Vanilla Overwrites start
	
	o.onAfterDamageReceived = function()
	{
		this.doOnFunctionWhenAlive("onAfterDamageReceived");
	}

	o.buildPropertiesForUse = function( _caller, _targetEntity )
	{
		_caller.resetField("HitChanceBonus");

		return this.buildProperties("onAnySkillUsed", [
			_caller,
			_targetEntity
		]);
	}

	o.buildPropertiesForDefense = function( _attacker, _skill )
	{
		return this.buildProperties("onBeingAttacked", [
			_attacker,
			_skill
		]);
	}

	o.buildPropertiesForBeingHit = function( _attacker, _skill, _hitinfo )
	{
		return this.buildProperties("onBeforeDamageReceived", [
			_attacker,
			_skill,
			_hitinfo
		]);
	}

	o.onBeforeActivation = function()
	{
		this.doOnFunctionWhenAlive("onBeforeActivation");
	}

	o.onTurnStart = function()
	{
		this.doOnFunctionWhenAlive("onTurnStart");
	}

	o.onResumeTurn = function()
	{
		this.doOnFunctionWhenAlive("onResumeTurn");
	}

	o.onRoundEnd = function()
	{
		this.doOnFunctionWhenAlive("onRoundEnd");
	}

	o.onTurnEnd = function()
	{
		this.doOnFunctionWhenAlive("onTurnEnd");
	}

	o.onWaitTurn = function()
	{
		this.doOnFunctionWhenAlive("onWaitTurn");
	}

	o.onNewRound = function()
	{
		this.doOnFunction("onNewRound");
	}

	o.onNewDay = function()
	{
		this.doOnFunctionWhenAlive("onNewDay");
	}

	o.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		this.doOnFunction("onDamageReceived", [
			_attacker,
			_damageHitpoints,
			_damageArmor
		]);
	}

	o.onBeforeTargetHit = function( _caller, _targetEntity, _hitInfo )
	{
		this.doOnFunction("onBeforeTargetHit", [
			_caller,
			_targetEntity,
			_hitInfo
		]);
	}

	o.onTargetHit = function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.doOnFunction("onTargetHit", [
			_caller,
			_targetEntity,
			_bodyPart,
			_damageInflictedHitpoints,
			_damageInflictedArmor
		]);
	}

	o.onTargetMissed = function( _caller, _targetEntity )
	{
		this.doOnFunction("onTargetMissed", [
			_caller,
			_targetEntity
		]);
	}

	o.onTargetKilled = function( _targetEntity, _skill )
	{
		this.doOnFunction("onTargetKilled", [
			_targetEntity,
			_skill
		]);
	}

	o.onMissed = function( _attacker, _skill )
	{
		this.doOnFunction("onMissed", [
			_attacker,
			_skill
		]);
	}

	o.onCombatStarted = function()
	{
		this.doOnFunction("onCombatStarted");
	}

	o.onCombatFinished = function()
	{
		this.doOnFunction("onCombatFinished");
	}

	o.onDeath = function( _fatalityType )
	{
		this.doOnFunction("onDeath", [_fatalityType]);
	}

	o.onDismiss = function()
	{
		this.doOnFunction("onDismiss");
	}

	//Vanilla Ovewrites End
	
	o.getItemActionCost <- function( _items )
	{
		local info = [];
		foreach (skill in this.m.Skills)
		{
			local cost = skill.getItemActionCost(_items);
			if (cost != null)
			{
				info.push({Skill = skill, Cost = cost});
			}
		}

		return info;
	}

	o.onPayForItemAction <- function( _skill, _items )
	{
		this.doOnFunction("onPayForItemAction", [
			_skill,
			_items
		]);
	}

	o.getSkillsByFunction <- function( _self, _function )
	{
		local ret = [];
		foreach (skill in this.m.Skills)
		{
			if (!skill.isGarbage() && _function.call(_self, skill))
			{
				ret.push(skill);
			}
		}

		return ret;
	}

	foreach (event in ::MSU.Skills.EventsToAdd)
	{
		o[event.Name] <- @(...) this.doOnFunction(event.Name, vargv, event.Update, event.AliveOnly);
	}
});
