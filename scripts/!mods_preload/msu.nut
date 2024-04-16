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
	::MSU.IsDebugSave <- false;
	::MSU.DebugSave <- null;
	::MSU.DebugSerEmu <- null;
	::MSU.DebugDeserEmu <- null;
	::MSU.createDebugSave <- function()
	{
		::MSU.DebugSave <- ::MSU.Class.SerializationData();
		::MSU.DebugSerEmu = ::MSU.DebugSave.getSerializationEmulator();
		::MSU.IsDebugSave = true;
		::World.State.saveCampaign("msu_debug_save");
		::MSU.IsDebugSave = false;
		::MSU.Mod.PersistentData.createFile("debug_save", ::MSU.DebugSave);
	}
	::MSU.loadDebugSave <- function()
	{
		::MSU.DebugSave = ::MSU.Mod.PersistentData.readFile("debug_save");
		::MSU.DebugDeserEmu = ::MSU.DebugSave.getDeserializationEmulator();
		::MSU.IsDebugSave = true;
		::World.State.loadCampaign("msu_debug_save");
		::MSU.IsDebugSave = false;
	}

	foreach (script in ::IO.enumerateFiles("scripts"))
	{
		::MSU.MH.hook(script, function(q) {
			if (q.contains("onSerialize"))
			{
				q.onSerialize = @(__original) function( _out )
				{
					__original(::MSU.IsDebugSave ? ::MSU.DebugSerEmu : _out);
				}
			}
		});

		if (script == "scripts/tools/tag_collection")
		{
			::MSU.MH.hook(script, function(q) {
				q.onDeserialize = @(__original) function( _in, _clearCurrent = true )
				{
					__original(::MSU.IsDebugSave ? ::MSU.DebugDeserEmu : _in, _clearCurrent);
				}
			});
		}
		else
		{
			::MSU.MH.hook(script, function(q) {
				if (q.contains("onDeserialize"))
				{
					q.onDeserialize = @(__original) function( _in )
					{
						__original(::MSU.IsDebugSave ? ::MSU.DebugDeserEmu : _in);
					}
				}
			});
		}
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
