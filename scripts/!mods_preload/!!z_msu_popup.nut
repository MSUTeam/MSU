::MSU <- {};
::MSU.Popup <- ::new("scripts/mods/msu/popup");

::mods_registerJS("msu/popup.js");
::mods_registerCSS("msu/css/popup.css");

::mods_hookExactClass("ui/screens/menu/modules/main_menu_module", function(o)
{
	o.connectBackend <- function()
	{
		this.logInfo("connectBackend");
		::MSU.Popup.connect();
		if ("UI" in ::MSU)
		{
			::MSU.UI.connect();
		}
	}
});
