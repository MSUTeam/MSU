this.msu_JS_connection <- {
	m = {
		JSHandle = null,
	},

	function create()
	{
		this.m.JSHandle = this.UI.connect("MSUBackendConnection", this);
	}

	function destroy()
	{
		this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
	}

	function isVisible()
	{
		return false
	}

	function isAnimating()
	{
		return false
	}

	function passKeybinds(){
		this.m.JSHandle.asyncCall("setCustomKeybinds", this.MSU.CustomKeybinds.CustomBindsJS);
	}

};


