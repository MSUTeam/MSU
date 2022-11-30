this.early_js_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},
	function create()
	{
		::logInfo("create");
		this.m.ID = "MSURootState";
	}

	function getEarlyJSHooks()
	{
		::logInfo("getEarlyJSHooks");
		return ::MSU.EarlyJSHooks;
	}

	function resumeOnInit()
	{
		::logInfo("resumeOnInit");
		::MSU.Utils.getState("root_state").resumeOnInit()
		::MSU.Utils.getState("main_menu_state").resumeOnInit()
		::MSU.Utils.getState("main_menu_state").show()
	}
});
