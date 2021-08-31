local gt = this.getroottable();

gt.Const.MSU.modAssetManager <- function ()
{
	::mods_hookNewObjectOnce("states/world/asset_manager", function(o) {
		o.m.LastDayMorningEventCalled <- 0;
		local update = o.update;
		o.update = function( _worldState )
		{
			if (this.World.getTime().Hours == 1 && this.World.getTime().Hours != this.m.LastHourUpdated && this.World.getTime().Days > this.m.LastDayMorningEventCalled);
			{
				this.m.LastDayMorningEventCalled = this.World.getTime().Days;
				local roster = this.World.getPlayerRoster().getAll();
				foreach( bro in roster )
				{
					bro.getSkills().onNewMorning();
				}
			}

			update( _worldState );
		}

		local onSerialize = o.onSerialize;
		o.onSerialize = function(_out)
		{
			onSerialize(_out);
			_out.writeBool(this.m.LastDayMorningEventCalled);
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function(_in)
		{
			onDeserialize(_in);
			this.m.LastDayMorningEventCalled = _in.readBool();
		}
	});
}
