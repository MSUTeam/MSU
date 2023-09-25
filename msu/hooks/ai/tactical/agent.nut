::MSU.HooksMod.hook("scripts/ai/tactical/agent", function(q) {
	q.m.MSU_BehaviorStacks <- {};
	q.m.MSU_BehaviorToRemove <- null;

	q.addBehavior = @(__original) function( _behavior )
	{
		if (_behavior.getID() in this.m.MSU_BehaviorStacks)
		{
			++this.m.MSU_BehaviorStacks[_behavior.getID()];
			return;
		}

		this.m.MSU_BehaviorStacks[_behavior.getID()] <- 1;
		return __original(_behavior);
	}

	q.removeBehavior = @(__original) function( _id )
	{
		if (_id in this.m.MSU_BehaviorStacks) delete this.m.MSU_BehaviorStacks[_id];
		return __original(_id);
	}

	// TODO: This function's name is temporary and is currently undocumented while we search for a better name
	// Once we find a better name we will change it and add it to documentation
	q.removeBehaviorByStack <- function( _id )
	{
		if (!(_id in this.m.MSU_BehaviorStacks) || --this.m.MSU_BehaviorStacks[_id] == 0)
			return this.removeBehavior(_id);
	}
});

::MSU.VeryLateBucket.push(function() {
	::MSU.HooksMod.hook("scripts/ai/tactical/agent", function(q) {
		q.execute = @(__original) function( _entity )
		{
			local ret = __original(_entity);
			if (this.m.MSU_BehaviorToRemove != null)
			{
				this.removeBehaviorByStack(this.m.MSU_BehaviorToRemove.getID());
				this.m.MSU_BehaviorToRemove = null;
			}
			return ret;
		}
	});
});
