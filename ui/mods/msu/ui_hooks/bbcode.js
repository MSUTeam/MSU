MSU.Hooks.XBBCODE_process = XBBCODE.process
XBBCODE.process = function (config)
{
	config.text = MSU.Loc.translate(config.text);
	return MSU.Hooks.XBBCODE_process.call(this, config);
}
