::mods_registerJS("msu/keybinds.js");
::mods_registerJS("msu/ui_hooks/character_screen_inventory_list_module.js");

local function includeFile(_file)
{
	::includeFile("msu/keyhandling/", _file);
}
includeFile("custom_keybinds.nut");
includeFile("global_keyhandler.nut");
includeFile("vanilla_keybinds.nut");
