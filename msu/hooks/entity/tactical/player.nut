::MSU.HooksMod.hook("scripts/entity/tactical/player", function(q) {
	q.m.LevelUpsSpent <- 0;

	q.getMovementSpeedMult <- function()
	{
		return 1.0;
	}

	q.setAttributeLevelUpValues = @(__original) function( _v )
	{
		__original(_v);
		this.m.LevelUpsSpent++;
	}

	q.onSerialize = @(__original) function( _out )
	{
		this.getFlags().set("LevelUpsSpent", this.m.LevelUpsSpent);
		__original(_out);
		this.getFlags().remove("LevelUpsSpent");
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		this.m.LevelUpsSpent = this.getFlags().has("LevelUpsSpent") ? this.getFlags().get("LevelUpsSpent") : 0;
	}
});
