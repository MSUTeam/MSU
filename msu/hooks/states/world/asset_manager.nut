::mods_hookNewObjectOnce("states/world/asset_manager", function(o) {
	o.m.LastDayMorningEventCalled <- 0;
	local update = o.update;
	o.update = function( _worldState )
	{
		if (this.World.getTime().Hours == 1 && this.World.getTime().Hours != this.m.LastHourUpdated && this.World.getTime().Days > this.m.LastDayMorningEventCalled)
		{
			this.m.LastDayMorningEventCalled = this.World.getTime().Days;
			local roster = this.World.getPlayerRoster().getAll();
			foreach ( bro in roster )
			{
				bro.getSkills().onNewMorning();
			}
			this.World.Assets.getOrigin().onNewMorning();
		}

		if (this.World.getTime().Days > this.m.LastDayPaid && this.World.getTime().Hours > 8 && this.m.IsConsumingAssets)
		{
			this.World.Assets.getOrigin().onNewDay();
		}

		update( _worldState );
	}

	o.getLastDayMorningEventCalled <- function()
	{
		return this.m.LastDayMorningEventCalled;
	}

	o.setLastDayMorningEventCalled <- function( _day )
	{
		this.m.LastDayMorningEventCalled = _day;
	}
});
