::mods_hookNewObjectOnce("entity/world/combat_manager", function(o) {
	local joinCombat = o.joinCombat;
	o.joinCombat = function( _combat, _party )
	{
		if (_combat.Factions.len() <= 100)
		{
			_combat.Factions.resize(256, []);
		}
		joinCombat(_combat, _party);
	}
});