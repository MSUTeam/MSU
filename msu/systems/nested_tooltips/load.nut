local function includeFile( _file )
{
	::includeFile("msu/systems/nested_tooltips/", _file + ".nut" );
}

includeFile("nested_tooltips_system")

::MSU.System.NestedTooltips <- ::MSU.Class.NestedTooltipSystem();

::MSU.Mod.Keybinds.addSQKeybind("toggleExtendedKeybinds", "alt", ::MSU.Key.State.All, function ()
{
	::MSU.System.NestedTooltips.Extended = !::MSU.System.NestedTooltips.Extended;
	// should also force refresh tooltip
}, "Toggle Extended Keybinds", ::MSU.Key.KeyState.Press | ::MSU.Key.KeyState.Release);
