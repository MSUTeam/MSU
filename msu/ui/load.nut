::mods_registerCSS("msu/css/misc.css");
::mods_registerCSS("msu/css/settings_screen.css");

::mods_registerJS("msu/ui_hooks/main_menu_module.js");
::mods_registerJS("msu/ui_hooks/main_menu_screen.js");
::mods_registerJS("msu/ui_hooks/character_screen_inventory_list_module.js");

::mods_registerJS("msu/backend_connection.js");
::mods_registerJS("msu/msu_connection.js");
::mods_registerJS("msu/ui_screen.js");
::mods_registerJS("msu/settings_screen.js");

::mods_registerJS("msu/keybinds.js")

::mods_registerJS("msu/~~connect_screens.js");

::includeFile("msu/ui/", "ui.nut");

this.MSU.UI.JSConnection = this.new("scripts/mods/msu/msu_connection");
this.MSU.UI.registerConnection(this.MSU.UI.JSConnection);
