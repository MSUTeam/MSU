::mods_registerCSS("msu/css/misc.css");
::mods_registerCSS("msu/css/settings_screen.css");

::mods_registerJS("msu/utilities.js");

::mods_registerJS("msu/ui_hooks/main_menu_module.js");
::mods_registerJS("msu/ui_hooks/main_menu_screen.js");
::mods_registerJS("msu/ui_hooks/tooltip_module.js");

::mods_registerJS("msu/backend_connection.js");
::mods_registerJS("msu/msu_connection.js");
::mods_registerJS("msu/ui_screen.js");

foreach (file in this.IO.enumerateFiles("ui/mods/msu/mod_settings/"))
{
	local splitFile = split(file, "/");
	local shortArray = splitFile.slice(2, splitFile.len());
	local shortenedString = shortArray.reduce(@(a, b) a + "/" + b);
	::mods_registerJS(shortenedString + ".js");
}

::mods_registerJS("msu/keybinds/key_static.js");
::mods_registerJS("msu/keybinds/keybind.js");
::mods_registerJS("msu/keybinds/keybinds_system.js");
::mods_registerJS("msu/keybinds/document_events.js");


::includeFile("msu/ui/", "ui.nut");

::MSU.UI.JSConnection = ::new("scripts/mods/msu/msu_connection");
::MSU.UI.registerConnection(::MSU.UI.JSConnection);

