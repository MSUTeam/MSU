MSU.TimerObject = function(_id)
{
	this.ID = _id;
	this.Start = new Date();
	this.PauseStart = null;
	this.PauseIncrement = 0;
}

MSU.TimerObject.prototype.silentGet = function()
{
	var pauseIncrement = this.PauseIncrement;
	if (this.PauseStart != null)
		pauseIncrement += new Date().getTime() - this.PauseStart;
	return (new Date()).getTime() - this.Start.getTime() - this.PauseIncrement
}

MSU.TimerObject.prototype.get = function(_msg, _stop)
{
	// Make sure to substract paused timme
	var time = this.silentGet();
	var text = 'Timer: "' +  this.ID +  '" currently at ' +  time + 'ms';
	if (_stop) text = 'Timer: "' +  this.ID +  '" stopped at ' +  time + 'ms';
	if (_msg) text += " | Msg: " + _msg;
	console.error(text);
	return time;
}

MSU.TimerObject.prototype.pause = function()
{
	if (this.PauseStart != null && MSU.getSettingValue("mod_msu", "performanceLog"))
	{
		console.error("Timer " + this.ID + " paused despite already being paused!");
	}
	this.PauseStart = new Date();
}

MSU.TimerObject.prototype.unpause = function()
{
	if (this.PauseStart == null)
	{
		if (MSU.getSettingValue("mod_msu", "performanceLog"))
		{
			console.error("Timer " + this.ID + " resumed despite not being paused!");
		}
		return;
	}
	var pauseStop = new Date();
	this.PauseIncrement += pauseStop.getTime() - this.PauseStart.getTime();
	this.PauseStart = null;
}

MSU.TimerObject.prototype.stop = function(_msg)
{
	delete MSU.Utils.Timers[this.ID];
	return this.get(_msg, true);
}

MSU.TimerObject.prototype.silentStop = function()
{
	delete MSU.Utils.Timers[this.ID];
	return this.silentGet();
}

MSU.Utils.Timers = {};
MSU.Utils.Timer = function(_id)
{
	if (_id in MSU.Utils.Timers) return MSU.Utils.Timers[_id];
    MSU.Utils.Timers[_id] = new MSU.TimerObject(_id);
    return MSU.Utils.Timers[_id];
};
