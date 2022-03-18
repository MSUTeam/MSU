::MSU <- {};
::MSU.Version <- "1.0.0-alpha";
::MSU.ID <- "mod_MSU";
::MSU.Name <- "Modding Standards & Utilities";

::MSU.VanillaID <- "vanilla";

::mods_registerMod(::MSU.ID, 1.0, ::MSU.Name);
::mods_queue(null, null, function()
{
	this.include("msu/load.nut");
});
