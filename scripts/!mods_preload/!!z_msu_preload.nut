::MSU.Popup <- ::new("scripts/mods/msu/popup");

::Hooks.registerJS("ui/mods/msu/popup.js");
::Hooks.registerCSS("ui/mods/msu/css/popup.css");

// TODO: This won't work as the MSU mod isn't initialized with Modern Hooks this early
// @Enduriel take a look please
::Hooks.getMod(::MSU.ID).hook("scripts/ui/screens/menu/modules/main_menu_module", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::MSU.Popup.quitGame = o.onQuitButtonPressed.bindenv(this);
	}

	q.connectBackend <- function()
	{
		::MSU.Popup.connect();
		if ("UI" in ::MSU)
		{
			::MSU.UI.connect();
		}
	}
});
