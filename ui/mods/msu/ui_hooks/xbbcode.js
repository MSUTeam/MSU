MSU.Hooks.XBBCODE_process = XBBCODE.process;
XBBCODE.process = function( config )
{
	// super ugly hack to get around main menu trying to process xbbcode before settings are set up
	if ($.isEmptyObject(Screens.ModSettingsScreen.mModSettings) || !MSU.getSettingValue("mod_msu", "VanillaBBCode")) {
		config.text = config.text.replace(/\[(b|i)\](.*?)\[\/\1\]/gm, "$2");
	}
	config.text = config.text.replace(/\[m(b|i)\](.*?)\[\/m\1\]/gm, "[$1]$2[\/$1]");
	return MSU.Hooks.XBBCODE_process(config);
}