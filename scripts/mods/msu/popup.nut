this.popup <- ::inherit("scripts/mods/msu/ui_screen", {
	m = {
		JSHandle = null,
		TextCache = ""
	}

	function showRawText( _text )
	{
		if (this.m.JSHandle == null)
		{
			if (this.m.TextCache != "") this.m.TextCache += "<br>";
			this.m.TextCache += _text;
		}
		else
		{
			this.m.JSHandle.asyncCall("showRawText", _text);
		}
	}

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUPopup", this);
		if (this.m.TextCache != "")
		{
			this.showRawText(this.m.TextCache)
			this.m.TextCache = "";
		}
	}
});
