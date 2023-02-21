this.early_js_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},
	function create()
	{
		this.m.ID = "MSUEarlyConnection";
	}

	function getEarlyJSHooks()
	{
		return ::MSU.EarlyJSHooks;
	}

	function resumeOnInit()
	{
		::MSU.Utils.getState("root_state").resumeOnInit()
		::MSU.Utils.getState("main_menu_state").resumeOnInit()
		delete ::MSU.EarlyConnection;
	}
});
