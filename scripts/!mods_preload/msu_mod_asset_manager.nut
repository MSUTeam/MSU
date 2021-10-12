local gt = this.getroottable();

gt.MSU.modAssetManager <- function ()
{
	// ::mods_hookNewObjectOnce("states/world/asset_manager", function(o) {
	// 	o.m.LastDayMorningEventCalled <- 0;
	// 	local update = o.update;
	// 	o.update = function( _worldState )
	// 	{
	// 		if (this.World.getTime().Hours == 1 && this.World.getTime().Hours != this.m.LastHourUpdated && this.World.getTime().Days > this.m.LastDayMorningEventCalled)
	// 		{
	// 			this.m.LastDayMorningEventCalled = this.World.getTime().Days;
	// 			local roster = this.World.getPlayerRoster().getAll();
	// 			foreach( bro in roster )
	// 			{
	// 				bro.getSkills().onNewMorning();
	// 			}
	// 		}

	// 		update( _worldState );
	// 	}

	// 	o.getLastDayMorningEventCalled <- function()
	// 	{
	// 		return this.m.LastDayMorningEventCalled;
	// 	}

	// 	o.setLastDayMorningEventCalled <- function( _day )
	// 	{
	// 		this.m.LastDayMorningEventCalled = _day;
	// 	}
	// });

	// ::mods_hookNewObjectOnce("states/world_state", function(o) {
	// 	local onSerialize = o.onSerialize;
	// 	o.onSerialize = function( _out )
	// 	{
	// 		this.World.Flags.set("MSU.LastDayMorningEventCalled", this.World.Assets.getLastDayMorningEventCalled())
	// 		onSerialize(_out);
	// 	}

	// 	local onDeserialize = o.onDeserialize;
	// 	o.onDeserialize = function( _in )
	// 	{
	// 		onDeserialize(_in)
	// 		if (this.World.Flags.has("MSU.LastDayMorningEventCalled"))
	// 		{
	// 			this.World.Assets.setLastDayMorningEventCalled(this.World.Flags.get("MSU.LastDayMorningEventCalled"));
	// 		}
	// 		else
	// 		{
	// 			this.World.Assets.setLastDayMorningEventCalled(0);
	// 		}
	// 	}
	// });
}
