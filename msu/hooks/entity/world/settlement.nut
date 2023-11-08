::MSU.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.onEnter = @(__original) function()
	{
		local ret = __original();

		if (ret)
		{
			foreach (bro in ::World.getPlayerRoster().getAll())
			{
				bro.getSkills().onEnterSettlement(this);
			}
		}

		return ret;
	}
});
