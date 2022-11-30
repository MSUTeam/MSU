::MSU.Popup <- ::new("scripts/mods/msu/popup");
::MSU.EarlyConnection <- ::new("scripts/mods/msu/early_js_connection");

::MSU.EarlyJSHooks <- []
::MSU.registerEarlyJSHook <- function( _scriptFile )
{
	this.EarlyJSHooks.push("mods/" + _scriptFile);
}

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

::include("msu/squirrel_hooks/mod_hooks"); // patches mod_hooks to accept semver strings

if (::Const.DLC.Lindwurm) ::mods_registerMod("dlc_lindwurm", 1, "Lindwurm");
if (::Const.DLC.Unhold) ::mods_registerMod("dlc_unhold", 1, "Beasts & Exploration");
if (::Const.DLC.Wildmen) ::mods_registerMod("dlc_wildmen", 1, "Warriors of the North");
if (::Const.DLC.Desert) ::mods_registerMod("dlc_desert", 1, "Blazing Deserts");
if (::Const.DLC.Paladins) ::mods_registerMod("dlc_paladins", 1, "Of Flesh and Faith");
