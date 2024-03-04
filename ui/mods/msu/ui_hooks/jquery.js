MSU.Hooks.$_fn_html = $.fn.html;
$.fn.html = function (_html)
{
	var ret = MSU.Hooks.$_fn_html.call(this, _html);
	if (_html != undefined)
	{
		MSU.Loc.translateObject(ret);
	}
	return ret;
}

MSU.Hooks.$_fn_text = $.fn.text;
$.fn.text = function (_text)
{
	var ret = MSU.Hooks.$_fn_text.call(this, _text);
	if (_text != undefined)
	{
		MSU.Loc.translateObject(ret);
	}
	return ret;
}

MSU.Hooks.$_init = $.prototype.init;
$.prototype.init = function (_selector, _context, rootjQuery)
{
	var ret = new MSU.Hooks.$_init(_selector, _context, rootjQuery);
	MSU.Loc.translateObject(ret);
	return ret;
}
