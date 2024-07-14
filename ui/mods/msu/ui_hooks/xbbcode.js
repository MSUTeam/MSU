MSU.Hooks.XBBCODE_process = XBBCODE.process;
XBBCODE.process = function( config )
{
	var ret = MSU.Hooks.XBBCODE_process(config);
	ret.html = ret.html.replace(/(?:\[|&#91;)(mi|mb)(?:\]|&#93;)(.*?)(?:\[|&#91;)\/\1(?:\]|&#93;)/gm, '<class="msu-font-$1">$2</>');
	return ret;
}
