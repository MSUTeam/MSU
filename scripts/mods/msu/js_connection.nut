::js_connection <- {
	m = {
		JSHandle = null,
	},

	function create()
	{

	}

	function connect()
	{

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

	function isConnected()
	{
		return this.m.JSHandle != null;
	}
};
