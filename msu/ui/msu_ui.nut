::mods_registerCSS("msu_css.css");
::mods_registerJS("msu_ui_screen.js");

::mods_registerJS("msu_settings_screen.js");
::mods_registerCSS("msu_settings_screen.css");

::mods_registerJS("msu_mod_screens.js");

::mods_registerJS("~~msu_backend_connection.js")


this.MSU.UI <- {
	m = {
		JSHandle = this.UI.connect("MSUBackendConnection", this),
		Screens = [],
	},

	function registerScreenToConnect( _screen )
	{
		this.Screens.push(_screen);
	}

	function connectScreens() // Want to make this call another function which acts as a very late time to run code, eg I want to lock the settingsmanager at this point (this runs after main menu load)
	{
		foreach (screen in this.Screens)
		{
			screen.connect();
		}
		this.Screens = [];
	}

	function passKeybinds()
	{
		this.m.JSHandle.asyncCall("setCustomKeybinds", this.MSU.CustomKeybinds.CustomBindsJS);
	}
}
