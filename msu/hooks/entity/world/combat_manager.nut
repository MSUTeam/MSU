::MSU.MH.hook("scripts/entity/world/combat_manager", function(q) {
	/* Compatibility for mods that add factions. At least two areas need to get changed,
	combat_manager and getLocalCombatProperties of world_state. The problem is that the
	Factions array is initialised with fixed size 32, which is not large enough once
	custom factions (or more towns etc) are added. This hook is the cleanest way to
	fix combat_manager, so you don't need to overwrite multiple functions instead. */
	q.joinCombat = @(__original) function( _combat, _party )
	{
		while (_combat.Factions.len() < 256)
		{
			_combat.Factions.push([]);
		}
		return __original(_combat, _party);
	}
});
