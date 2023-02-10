local function includeJSFilesInFolder( _folder )
{
	foreach (file in ::IO.enumerateFiles(_folder))
	{
		local splitFile = split(file, "/");
		local shortArray = splitFile.slice(2, splitFile.len());
		local shortenedString = shortArray.reduce(@(a, b) a + "/" + b);
		::MSU.registerEarlyJSHook(shortenedString + ".js");
	}
}

::mods_registerCSS("msu/css/misc.css");
::mods_registerCSS("msu/css/settings_screen.css");

::MSU.registerEarlyJSHook("msu/main.js");

includeJSFilesInFolder("ui/mods/msu/misc");

::MSU.registerEarlyJSHook("msu/nested_tooltips.js");

includeJSFilesInFolder("ui/mods/msu/ui_hooks");

::MSU.registerEarlyJSHook("msu/backend_connection.js");
::MSU.registerEarlyJSHook("msu/msu_connection.js");
::MSU.registerEarlyJSHook("msu/ui_screen.js");

includeJSFilesInFolder("ui/mods/msu/mod_settings");
includeJSFilesInFolder("ui/mods/msu/keybinds");

::mods_registerJS("msu/register_screens.js")

::MSU.includeFile("msu/ui/", "ui.nut");

::MSU.UI.JSConnection = ::new("scripts/mods/msu/msu_connection");
::MSU.UI.registerConnection(::MSU.UI.JSConnection);
