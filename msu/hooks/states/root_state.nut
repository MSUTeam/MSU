::mods_addHook("root_state.onInit", function(r) // executed once per game session
{
	::MSU.System.Keybinds.importPersistentSettings();
	::MSU.System.ModSettings.importPersistentSettings();
});
