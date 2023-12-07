// Is included during First QueueBucket
// VANILLAFIX: http://battlebrothersgame.com/forums/topic/oncombatstarted-is-not-called-for-ai-characters/
// This fix is spread out over 4 files: tactical_entity_manager, actor, player, standard_bearer
::MSU.HooksMod.hook("scripts/entity/tactical/humans/standard_bearer", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.m.Skills.removeByID("perk.inspiring_presence");
		::logWarning("MSU removed perk_inspiring_presence from standard_bearer. We do this to maintain unchanged vanilla behavior after our fix of onCombatStart for AI characters").
	}
});
