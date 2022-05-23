::MSU.Class.Timer <- class
{
	ID = null;
	Start = null;

	constructor(_id)
	{
		this.ID = _id;
		this.Start = ::Time.getExactTime();
	}

	function get(_msg = "", _stop = false)
	{
	    local time = (::Time.getExactTime() - this.Start) * 1000;
	    local text = format("Timer: %s %s at %f ms", this.ID, _stop ? "stopped" : "currently", time);
	    if(_msg != "") text += " | Msg: " + _msg;
	    ::logInfo(text);
	    return time;
	}

	function stop(_msg = "")
	{
		local time = this.get(_msg, true);
	    delete ::MSU.Utils.Timers[this.ID];
	    return time;
	}
}
