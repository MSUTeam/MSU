::Hooks.registerJS("ui/mods/msu/popup.js");
::Hooks.registerCSS("ui/mods/msu/css/popup.css");

::Hooks.registerCSS("ui/mods/msu/css/misc.css");
::Hooks.registerCSS("ui/mods/msu/css/settings_screen.css");

::Hooks.registerJS("ui/mods/msu/utilities.js");

::Hooks.registerJS("ui/mods/msu/ui_hooks/main_menu_module.js");
::Hooks.registerJS("ui/mods/msu/ui_hooks/main_menu_screen.js");
::Hooks.registerJS("ui/mods/msu/ui_hooks/tooltip_module.js");
::Hooks.registerJS("ui/mods/msu/ui_hooks/turnsequencebar_module.js");

::Hooks.registerJS("ui/mods/msu/backend_connection.js");
::Hooks.registerJS("ui/mods/msu/msu_connection.js");
::Hooks.registerJS("ui/mods/msu/ui_screen.js");

foreach (file in ::IO.enumerateFiles("ui/mods/msu/mod_settings/"))
	::Hooks.registerJS(file + ".js");

::Hooks.registerJS("ui/mods/msu/keybinds/key_static.js");
::Hooks.registerJS("ui/mods/msu/keybinds/keybind.js");
::Hooks.registerJS("ui/mods/msu/keybinds/keybinds_system.js");
::Hooks.registerJS("ui/mods/msu/keybinds/document_events.js");


::MSU.includeFile("msu/ui/", "ui.nut");

::MSU.UI.JSConnection = ::new("scripts/mods/msu/msu_connection");
::MSU.UI.registerConnection(::MSU.UI.JSConnection);
