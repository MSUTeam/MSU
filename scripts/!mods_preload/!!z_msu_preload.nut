::MSU.Popup <- ::new("scripts/mods/msu/popup");

::mods_registerJS("msu/popup.js");
::mods_registerCSS("msu/css/popup.css");

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

::include("msu/squirrel_hooks/mod_hooks"); // patches mod_hooks to accept semver strings

if (::Const.DLC.Lindwurm) ::Hooks.register("dlc_lindwurm", 1, "Lindwurm");
if (::Const.DLC.Unhold) ::Hooks.register("dlc_unhold", 1, "Beasts & Exploration");
if (::Const.DLC.Wildmen) ::Hooks.register("dlc_wildmen", 1, "Warriors of the North");
if (::Const.DLC.Desert) ::Hooks.register("dlc_desert", 1, "Blazing Deserts");
if (::Const.DLC.Paladins) ::Hooks.register("dlc_paladins", 1, "Of Flesh and Faith");
