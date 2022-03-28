::mods_hookNewObject("skills/skill_container", function(o) {
	o.m.LastLevelOnUpdateLevelCalled <- 0;
	o.m.ScheduledChangesSkills <- [];
	o.m.IsPreviewing <- false;

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

		foreach (skill in this.m.ScheduledChangesSkills)
		{
			skill.executeScheduledChanges();
		}

		this.m.ScheduledChangesSkills.clear();
	}

	o.callSkillsFunction <- function( _function, _argsArray = null, _update = true, _aliveOnly = false )
	{
		if (_argsArray == null) _argsArray = [null];
		else _argsArray.insert(0, null);

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

		this.m.IsUpdating = false;
		
		if (_update)
		{
			this.update();
		}
	}

	o.callSkillsFunctionWhenAlive <- function( _function, _argsArray = null, _update = true )
	{
		this.callSkillsFunction(_function, _argsArray, _update, true);
	}

	o.buildProperties <- function( _function, _argsArray )
	{
		_argsArray.insert(0, null);
		_argsArray.push(this.m.Actor.getCurrentProperties().getClone());

		this.m.IsUpdating = true;

		foreach (skill in this.m.Skills)
		{
			_argsArray[0] = skill;
			skill[_function].acall(_argsArray);
		}
		this.m.IsUpdating = false;
		return _argsArray[_argsArray.len() - 1];
	}

	o.onMovementStarted <- function( _tile, _numTiles )
	{
		this.callSkillsFunction("onMovementStarted", [
			_tile,
			_numTiles
		]);
	}

	o.onMovementFinished <- function( _tile )
	{
		this.callSkillsFunction("onMovementFinished", [
			_tile
		]);
	}

	o.onMovementStep <- function( _tile, _levelDifference )
	{
		this.callSkillsFunction("onMovementStep", [
			_tile,
			_levelDifference
		], false);
	}

	o.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		// Don't update if using a skill that sets Tile to ID 0 e.g. Rotation because this leads
		// to crashes if any skill tries to access the current tile in its onUpdate
		// function as the tile at this point is not a valid tile.

		this.callSkillsFunction("onAnySkillExecuted", [
			_skill,
			_targetTile,
			_targetEntity,
			_forFree
		], this.getActor().isPlacedOnMap());
	}

	o.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.callSkillsFunction("onBeforeAnySkillExecuted", [
			_skill,
			_targetTile,
			_targetEntity,
			_forFree
		]);
	}
	
	o.onUpdateLevel <- function()
	{
		local currLevel = this.getActor().getLevel();
		if (currLevel > this.m.LastLevelOnUpdateLevelCalled)
		{
			this.m.LastLevelOnUpdateLevelCalled = currLevel;
			this.callSkillsFunction("onUpdateLevel");
		}
	}

	o.onNewMorning <- function()
	{
		this.callSkillsFunctionWhenAlive("onNewMorning");
	}

	o.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		this.callSkillsFunction("onGetHitFactors", [
			_skill,
			_targetTile,
			_tooltip
		], false);
	}

	o.onQueryTooltip <- function( _skill, _tooltip )
	{
		this.callSkillsFunction("onQueryTooltip", [
			_skill,
			_tooltip
		], false);
	}

	o.onDeathWithInfo <- function( _killer, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		this.callSkillsFunction("onDeathWithInfo", [
			_killer,
			_skill,
			_deathTile,
			_corpseTile,
			_fatalityType
		], false);
	}

	o.onOtherActorDeath <- function( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		this.callSkillsFunction("onOtherActorDeath", [
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
		this.callSkillsFunction("onEnterSettlement", [
			_settlement
		]);
	}

	o.onAffordablePreview <- function( _skill, _movementTile )
	{
		foreach (skill in this.m.Skills)
		{
			skill.PreviewField.clear();
			skill.PreviewProperty.clear();
		}

		this.callSkillsFunction("onAffordablePreview", [
			_skill,
			_movementTile,
		], false);
	}

	//Vanilla Overwrites start
	
	o.onAfterDamageReceived = function()
	{
		this.callSkillsFunctionWhenAlive("onAfterDamageReceived");
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
		this.callSkillsFunctionWhenAlive("onBeforeActivation");
	}

	o.onTurnStart = function()
	{
		this.callSkillsFunctionWhenAlive("onTurnStart");
	}

	o.onResumeTurn = function()
	{
		this.callSkillsFunctionWhenAlive("onResumeTurn");
	}

	o.onRoundEnd = function()
	{
		this.callSkillsFunctionWhenAlive("onRoundEnd");
	}

	o.onTurnEnd = function()
	{
		this.callSkillsFunctionWhenAlive("onTurnEnd");
	}

	o.onWaitTurn = function()
	{
		this.callSkillsFunctionWhenAlive("onWaitTurn");
	}

	o.onNewRound = function()
	{
		this.callSkillsFunction("onNewRound");
	}

	o.onNewDay = function()
	{
		this.callSkillsFunctionWhenAlive("onNewDay");
	}

	o.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		this.callSkillsFunction("onDamageReceived", [
			_attacker,
			_damageHitpoints,
			_damageArmor
		]);
	}

	o.onBeforeTargetHit = function( _caller, _targetEntity, _hitInfo )
	{
		this.callSkillsFunction("onBeforeTargetHit", [
			_caller,
			_targetEntity,
			_hitInfo
		]);
	}

	o.onTargetHit = function( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.callSkillsFunction("onTargetHit", [
			_caller,
			_targetEntity,
			_bodyPart,
			_damageInflictedHitpoints,
			_damageInflictedArmor
		]);
	}

	o.onTargetMissed = function( _caller, _targetEntity )
	{
		this.callSkillsFunction("onTargetMissed", [
			_caller,
			_targetEntity
		]);
	}

	o.onTargetKilled = function( _targetEntity, _skill )
	{
		this.callSkillsFunction("onTargetKilled", [
			_targetEntity,
			_skill
		]);
	}

	o.onMissed = function( _attacker, _skill )
	{
		this.callSkillsFunction("onMissed", [
			_attacker,
			_skill
		]);
	}

	o.onCombatStarted = function()
	{
		this.callSkillsFunction("onCombatStarted");
	}

	o.onCombatFinished = function()
	{
		this.callSkillsFunction("onCombatFinished");
	}

	o.onDeath = function( _fatalityType )
	{
		this.callSkillsFunction("onDeath", [_fatalityType]);
	}

	o.onDismiss = function()
	{
		this.callSkillsFunction("onDismiss");
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
		this.callSkillsFunction("onPayForItemAction", [
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
		o[event.Name] <- @(...) this.callSkillsFunction(event.Name, vargv, event.Update, event.AliveOnly);
	}
});
