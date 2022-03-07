this.msu_connection <- this.inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = this.UI.connect("MSUBackendConnection", this);
	}

	function passKeybinds()
	{
		this.m.JSHandle.asyncCall("setCustomKeybinds", this.MSU.CustomKeybinds.CustomBindsJS);
	}
});
