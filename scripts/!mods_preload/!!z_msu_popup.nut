::MSU.Popup <- ::new("scripts/mods/msu/popup");

::mods_registerJS("msu/popup.js");
::mods_registerCSS("msu/css/popup.css");

::mods_hookExactClass("ui/screens/menu/modules/main_menu_module", function(o)
{
	local create = o.create;
	o.create <- function()
	{
		create();
		::MSU.Popup.quitGame = o.onQuitButtonPressed.bindenv(this);
	}
	o.connectBackend <- function()
	{
		::MSU.Popup.connect();
		if ("UI" in ::MSU)
		{
			::MSU.UI.connect();
		}
	}
});
