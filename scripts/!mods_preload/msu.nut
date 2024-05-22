::MSU.MH <- ::Hooks.register(::MSU.ID, ::MSU.Version, ::MSU.Name);
::MSU.MH.require("vanilla" + " >= 1.5.0-13");
::MSU.MH.conflictWith("mod_legends < 16.0.0");

::MSU.MH.queue(function() {
	::include("msu/load.nut");
});

::MSU.MH.queue(function() {
	::include("msu/hooks/entity/tactical/humans/standard_bearer"); // Remove perk_inspiring_presence from standard_bearer as part of our fix of onCombatStart
}, ::Hooks.QueueBucket.First);

::MSU.MH.queue(function() {
	foreach (func in ::MSU.QueueBucket.VeryLate)
	{
		func();
	}
	::MSU.QueueBucket.VeryLate.clear();
}, ::Hooks.QueueBucket.VeryLate);

::MSU.MH.queue(function() {
	foreach (func in ::MSU.QueueBucket.AfterHooks)
	{
		func();
	}
	::MSU.QueueBucket.AfterHooks.clear();
}, ::Hooks.QueueBucket.AfterHooks);

::MSU.MH.queue(function() {
	foreach (func in ::MSU.QueueBucket.FirstWorldInit)
	{
		func();
	}
	::MSU.QueueBucket.FirstWorldInit.clear();
	delete ::MSU.QueueBucket;
	delete ::MSU.HooksHelper;
}, ::Hooks.QueueBucket.FirstWorldInit);

::MSU.QueueBucket.FirstWorldInit.push(function() {
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
});
