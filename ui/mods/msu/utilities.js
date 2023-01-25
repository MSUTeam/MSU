var MSU = {
	ID : "mod_msu"
};
MSU.Utils = {};
MSU.Utils.Timers = {};
MSU.printData = function( _data, _depth, _maxLen )
{
	if (_depth === undefined) _depth = 1;
	if (_maxLen === undefined) _maxLen = 0;
	var length = 1;
	var isArray = false;
	if (typeof _data == "object" && _data !== null)
	{
		if (Array.isArray(_data))
		{
			isArray = true;
			length = _data.length;
		}
		else
		{
			length = Object.keys(_data).length;
		}
	}
	var string = MSU.getLocalString("Data: ", _data, Math.max(length, _maxLen), _depth, isArray);
	for (var i = 0; i < string.length; i = i + 900)
	{
		console.error(string.slice(i, Math.min(i + 900, string.length)));
	}
};

MSU.getLocalString = function( _key, _value, _maxLen, _depth, _isArray )
{
	if (_isArray === undefined) _isArray = false;
	var string = "";

	if (!_isArray)
	{
		string += _key + " = ";
	}

	switch(typeof _value)
	{
		case "object":
			if (_value === null)
			{
				string += "null, ";
				break;
			}
			if (Array.isArray(_value))
			{
				if (_value.length > _maxLen || _depth <= 0)
				{
					string += "array, ";
					break;
				}

				string += '[';
				for (var i = 0; i < _value.length; i++)
				{
					string += MSU.getLocalString(i, _value[i], _maxLen, _depth - 1, true);
				}

				if (_value.length > 0)
				{
					string = string.slice(0, string.length - 2);
				}
				string += '], ';
			}
			else
			{
				var keys = Object.keys(_value);
				if (keys.length > _maxLen || _depth <= 0)
				{
					string += "object, ";
					break;
				}

				string += '{';
				for (var i = 0; i < keys.length; i++)
				{
					string += MSU.getLocalString(keys[i], _value[keys[i]], _maxLen, _depth - 1, false);
				}

				if (keys.length > 0)
				{
					string = string.slice(0, string.length - 2);
				}
				string += "}, ";
			}
			break;
		default:
			string += "(" + typeof _value + ") " + _value + ", ";
	}

	return string;
};

MSU.capitalizeFirst = function ( _string )
{
	return _string.charAt(0).toUpperCase() + _string.slice(1);
};

MSU.iterateObject = function(_object, _func, _every)
{
	if (_every === true)
	{
		Object.keys(_object).every(function(_key)
		{
		    return _func(_key, _object[_key]);
		})
	}
	else
	{
		Object.keys(_object).forEach(function(_key)
		{
		    return _func(_key, _object[_key]);
		})
	}
}

// https://stackoverflow.com/a/2641047, allows binding an evenListener before other eventListeners
$.fn.bindFirst = function(name, fn) {
    // bind as you normally would
    // don't want to miss out on any jQuery magic
    this.on(name, fn);

    // Thanks to a comment by @Martin, adding support for
    // namespaced events too.
    this.each(function() {
        var handlers = $._data(this, 'events')[name.split('.')[0]];
        // take out the handler we just inserted from the end
        var handler = handlers.pop();
        // move it at the beginning
        handlers.splice(0, 0, handler);
    });
};

$.fn.resizePopup = function(_contentHeight, _contentWidth)
{
    var popupProper = this.findPopupDialog();
    var popupContent = this.findPopupDialogContentContainer();

    _contentHeight = _contentHeight || popupContent.height();
    _contentWidth = _contentWidth || popupContent.width();

    var popupProperHeight = popupProper.height();
    var popupContentHeight = popupContent.height();
    var headerHeight = this.find(".header").height();
    var footerHeight = this.find(".footer").height();
    var subHeaderHeight = this.find(".sub-header").height();
    var baseHeight = 8 + headerHeight + subHeaderHeight + footerHeight;
    var totalWidth = Math.max(popupProper.width(), _contentWidth);
    var totalHeight = baseHeight + _contentHeight;

    popupProper.css("height",  totalHeight);
    popupProper.css("width", totalWidth);
    popupProper.css("background-size", totalWidth + " " + totalHeight)
    popupContent.css("height", _contentHeight)
    popupContent.css("width", _contentWidth)
    popupProper.centerPopupDialogWithinParent()
};

// triggers remove events for elements when they get removed in any way https://stackoverflow.com/a/18410186
MSU.$_cleanData = $.cleanData;
$.cleanData = function( elems ) {
    for ( var i = 0, elem; (elem = elems[i]) != null; i++ ) {
        try {
            $( elem ).triggerHandler( "remove" );
        // http://bugs.jquery.com/ticket/8235
        } catch( e ) {}
    }
    MSU.$_cleanData( elems );
};

MSU.toggleDisplay = function(_object, _bool)
{
    if(_bool === false)
    {
        _object.removeClass('display-block').addClass('display-none');
    }
    else if (_bool === true)
    {
        _object.removeClass('display-none').addClass('display-block');
    }
    else
    {
        if (_object.hasClass('display-block'))
        {
            _object.removeClass('display-block').addClass('display-none');
            return false;
        }
        else
        {
            _object.removeClass('display-none').addClass('display-block');
            return true;
        }
    }
    return _bool;
}

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

MSU.Utils.Timer = function(_id)
{
	if (_id in MSU.Utils.Timers) return MSU.Utils.Timers[_id];
    MSU.Utils.Timers[_id] = new MSU.TimerObject(_id);
    return MSU.Utils.Timers[_id];
};
