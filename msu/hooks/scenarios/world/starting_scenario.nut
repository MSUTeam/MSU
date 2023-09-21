::MSU.HooksMod.hook("scripts/scenarios/world/starting_scenario", function(q) {
	q.onNewDay <- function()
	{
	}

	q.onNewMorning <- function()
	{
	}

	q.getMovementSpeedMult <- function()
	{
		return 1.0;
	}
});

::MSU.VeryLateBucket.add(function() {
	::MSU.HooksMod.leafHook("scripts/scenarios/world/starting_scenario", function(q) {
		q.onUpdateLevel <- @(__original) function( _bro )
		{
			onUpdateLevel(_bro);
			_bro.getSkills().onUpdateLevel();
		}
	});
});
