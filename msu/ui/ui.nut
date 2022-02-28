::mods_registerCSS("msu/css.css");
::mods_registerJS("msu/backend_connection.js");
::mods_registerJS("msu/ui_screen.js");

::mods_registerJS("msu/settings_screen.js");
::mods_registerCSS("msu/settings_screen.css");

::mods_registerJS("msu/mod_screens.js");

::mods_registerJS("msu/~~connect_screens.js")


this.MSU.UI <- {
	Connections = [],
	JSConnection = null,

	function registerConnection( _connection )
	{
		this.Connections.push(_connection);
	}

	function connect() // Want to make this call another function which acts as a very late time to run code, eg I want to lock the settingsmanager at this point (this runs after main menu load)
	{
		foreach (screen in this.Connections)
		{
			screen.connect();
		}
		this.MSU.UI.Connections = [];
	}
}

this.MSU.UI.JSConnection = this.new("msu/ui/msu_connection");
this.MSU.UI.registerConnection(this.MSU.UI.JSConnection);
