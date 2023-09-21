::MSU.HooksMod.hook("scripts/root_state", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		::MSU.System.Keybinds.importPersistentSettings();
		::MSU.System.ModSettings.importPersistentSettings();
	}
});
