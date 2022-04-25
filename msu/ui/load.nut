::mods_registerCSS("msu/css/misc.css");
::mods_registerCSS("msu/css/settings_screen.css");

::mods_registerJS("msu/utilities.js");

::mods_registerJS("msu/ui_hooks/main_menu_module.js");
::mods_registerJS("msu/ui_hooks/main_menu_screen.js");

::mods_registerJS("msu/backend_connection.js");
::mods_registerJS("msu/msu_connection.js");
::mods_registerJS("msu/ui_screen.js");

::mods_registerJS("msu/mod_settings/boolean_setting.js");
::mods_registerJS("msu/mod_settings/button_setting.js");
::mods_registerJS("msu/mod_settings/divider_setting.js");
::mods_registerJS("msu/mod_settings/title_setting.js");
::mods_registerJS("msu/mod_settings/enum_setting.js");
::mods_registerJS("msu/mod_settings/keybind_setting.js");
::mods_registerJS("msu/mod_settings/range_setting.js");
::mods_registerJS("msu/mod_settings/string_setting.js");
::mods_registerJS("msu/mod_settings/color_picker_setting.js");
::mods_registerJS("msu/mod_settings/settings_screen.js");


::mods_registerJS("msu/keybinds/key_static.js");
::mods_registerJS("msu/keybinds/keybind.js");
::mods_registerJS("msu/keybinds/keybinds_system.js");
::mods_registerJS("msu/keybinds/document_events.js");


::includeFile("msu/ui/", "ui.nut");

::MSU.UI.JSConnection = ::new("scripts/mods/msu/msu_connection");
::MSU.UI.registerConnection(::MSU.UI.JSConnection);
