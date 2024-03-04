MSU.Hooks.XBBCODE_process = XBBCODE.process
XBBCODE.process = function (config)
{
	config.text = MSU.Loc.translate(config.text);
	var ret = MSU.Hooks.XBBCODE_process.call(this, config);
	ret.html = "<span class=\"MSU_BBCODE_Translated\">" + ret.html + "</span>"
	return ret;
}
