::MSU.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.LastDayMorningEventCalled <- 0;
	q.update = @(__original) function( _worldState )
	{
		if (::World.getTime().Hours == 1 && ::World.getTime().Hours != this.m.LastHourUpdated && ::World.getTime().Days > this.m.LastDayMorningEventCalled)
		{
			this.m.LastDayMorningEventCalled = ::World.getTime().Days;
			local roster = ::World.getPlayerRoster().getAll();
			foreach (bro in roster)
			{
				bro.getSkills().onNewMorning();
			}
			::World.Assets.getOrigin().onNewMorning();
		}

		if (::World.getTime().Days > this.m.LastDayPaid && ::World.getTime().Hours > 8 && this.m.IsConsumingAssets)
		{
			::World.Assets.getOrigin().onNewDay();
		}

		return __original(_worldState);
	}

	q.getLastDayMorningEventCalled <- function()
	{
		return this.m.LastDayMorningEventCalled;
	}

	q.setLastDayMorningEventCalled <- function( _day )
	{
		this.m.LastDayMorningEventCalled = _day;
	}
});
