::MSU.HooksMod <- ::Hooks.register(::MSU.ID, ::MSU.Version, ::MSU.Name);
::MSU.HooksMod.require(::MSU.VanillaID + ">= 1.5.0-13");
::MSU.HooksMod.incompatibleWith("mod_legends < 16.0.0");

::MSU.HooksMod.queue(function() {
	::include("msu/load.nut");
});

::MSU.HooksMod.queue(function() {
	foreach (func in ::MSU.VeryLateBucket)
	{
		func();
	}
	::MSU.VeryLateBucket.clear();
}, ::Hooks.QueueBucket.VeryLate);

::MSU.HooksMod.queue(function() {
	foreach (script in ::IO.enumerateFiles("scripts/ai/tactical/behaviors"))
	{
		try
		{
			::MSU.AI.BehaviorIDToScriptMap[::new(script).getID()] <- script;
		}
		catch (error)
		{
			::logError("Could not instantiate or get ID of behavior: " + script);
		}
	}
}, ::Hooks.QueueBucket.FirstWorldInit);
