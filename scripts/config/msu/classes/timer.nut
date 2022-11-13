::MSU.Class.Timer <- class
{
	ID = null;
	Start = null;
	PauseStart = null;
	PauseIncrement = null;

	constructor( _id )
	{
		this.ID = _id;
		this.Start = ::Time.getExactTime();
		this.PauseIncrement = 0;
	}

	function get( _msg = "", _stop = false, _printMsg = true )
	{
		// Make sure to substract paused timme
		if (this.PauseStart != null)
			this.unpause();

	    local time = (::Time.getExactTime() - this.Start - this.PauseIncrement) * 1000;
	    if (_printMsg)
	    {
		    local text = format("Timer: %s %s at %f ms", this.ID, _stop ? "stopped" : "currently", time);
		    if(_msg != "") text += " | Msg: " + _msg;
		    ::logInfo(text);
	    }
	    return time;
	}

	function pause()
	{
		if (this.PauseStart != null)
		{
			::MSU.Mod.Debug.printWarning(format("Timer %s paused despite already being paused!", this.ID), "performance");
		}
		this.PauseStart = ::Time.getExactTime();
	}

	function unpause()
	{
		if (this.PauseStart == null)
		{
			::MSU.Mod.Debug.printWarning(format("Timer %s resumed despite not being paused!", this.ID), "performance");
			return;
		}
		this.PauseIncrement += ::Time.getExactTime() - this.PauseStart;
		this.PauseStart = null;
	}

	function stop( _msg = "", _printMsg = true )
	{
		local time = this.get(_msg, true, _printMsg);
	    delete ::MSU.Utils.Timers[this.ID];
	    return time;
	}
}
