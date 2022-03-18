::MSU.Skills <- {
	// Vanilla Events:
	// onTargetKilled
	// onTargetMissed
	// onNewDay
	// onDamageReceived
	// onAfterDamageReceived (but in vanilla it doesn't exist in skill.nut, only skill_container)
	// onDeath
	// onWaitTurn
	// onBeforeTargetHit
	// onTargetHit
	// onCombatFinished
	// onCombatStarted
	// onBeforeActivation
	// onResumeTurn
	// onMissed
	// onTurnStart
	// onTurnEnd
	// onRoundEnd
	// onNewRound

	// Vanilla buildProperties
	// buildPropertiesForUse -> onAnySkillUsed
	// buildPropertiesForDefense -> onBeingAttacked
	// buildPropertiesForBeingHit -> onBeforeDamageReceived

	IsAllEventsMode = false,
	IsAllEventsModeCheckDone = false,
	EventsDirectory = {
		onAnySkillUsed = null,
		onBeingAttacked = null,
		onBeforeDamageReceived = null			
	},
	EventsToAdd = [],
	AlwaysRunEvents = [
		"onCombatFinished"
	],

	function addEvent( _name, _isEmpty = true, _function = null, _update = false, _aliveOnly = false )
	{
		this.EventsToAdd.push({
			Name = _name,
			Update = _update,
			AliveOnly = _aliveOnly
		});

		this.MSU.Skills.EventsDirectory[_name] <- null;
		if (!_isEmpty) this.MSU.Skills.AlwaysRunEvents.push(_name);

		::mods_hookBaseClass("skills/skill", function(o) {
			o = o[o.SuperName];
			o[_name] <- _function == null ? function() {} : _function;
		});
	}
}
