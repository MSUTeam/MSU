::mods_hookExactClass("root_state", function(o) {
	local onInit = o.onInit;
	o.onInit = function()
	{
		local ret = onInit();

		foreach (script in ::IO.enumerateFiles("scripts/ai/tactical/behaviors"))
		{
			::MSU.AI.BehaviorIDToScriptMap[::new(script).getID()] <- script;
		}

		return ret;
	}
});
