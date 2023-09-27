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

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.HooksMod.hookTree("scripts/scenarios/world/starting_scenario", function(q) {
		q.onUpdateLevel = @(__original) function( _bro )
		{
			__original(_bro);
			_bro.getSkills().onUpdateLevel();
		}
	});
});
