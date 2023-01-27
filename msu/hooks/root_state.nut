::mods_hookExactClass("root_state", function(o) {
	local onInit = o.onInit;
	o.onInit = function()
	{
		foreach (script in ::IO.enumerateFiles("scripts/ai/tactical/behaviors"))
		{
			try
			{
				local behavior = ::new(script);
				local id = behavior.getID();
				::MSU.AI.BehaviorIDToScriptMap[id] <- script;
				if ("PossibleSkills" in behavior.m)
				{
					foreach (skillID in behavior.m.PossibleSkills)
					{
						::MSU.AI.SkillIDToBehaviorIDMap[skillID] <- id;
					}
				}
			}
			catch (error)
			{
				::logError("Could not instantiate or get ID of behavior: " + script);
			}
		}

		return onInit();
	}
});
