::mods_hookBaseClass("ai/tactical/agent", function(o) {
	o = o[o.SuperName];

	o.m.MSU_BehaviorStacks <- {};

	local addBehavior = o.addBehavior;
	o.addBehavior = function( _behavior )
	{
		if (_behavior.getID() in this.m.MSU_BehaviorStacks)
		{
			++this.m.MSU_BehaviorStacks[_behavior.getID()];
			return;
		}

		this.m.MSU_BehaviorStacks[_behavior.getID()] <- 1;
		return addBehavior(_behavior);
	}

	local removeBehavior = o.removeBehavior;
	o.removeBehavior = function( _id )
	{
		if (_id in this.m.MSU_BehaviorStacks) delete this.m.MSU_BehaviorStacks[_id];
		return removeBehavior(_id);
	}

	// TODO: This function's name is temporary and is currently undocumented while we search for a better name
	// Once we find a better name we will change it and add it to documentation
	o.removeBehaviorByStack <- function( _id )
	{
		if (!(_id in this.m.MSU_BehaviorStacks) || --this.m.MSU_BehaviorStacks[_id] == 0)
			return this.removeBehavior(_id);
	}
});
