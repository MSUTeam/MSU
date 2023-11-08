if ("mods_registerJS" in getroottable())
	::mods_registerJS("msu/connect_screens.js")
else
	::Hooks.registerLateJS("ui/mods/msu/connect_screens.js");
