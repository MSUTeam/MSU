"use strict";
var onConnection = MainMenuScreen.prototype.onConnection;
MainMenuScreen.prototype.onConnection = function(handle)
{
	onConnection.bind(this)(handle);

	SQ.call(this.mSQHandle, "getRegisteredCSSHooks", null, function(a) {
		for(var i=0; i<a.length; i++)
		{
			var link = document.createElement("link");
			link.rel = "stylesheet";
			link.type = "text/css";
			link.href = a[i];
			document.body.appendChild(link);
		}
	}.bind(this));

	SQ.call(this.mSQHandle, "getRegisteredJSHooks", null, function(a) {
		for(var i=0; i<a.length; i++)
		{
			var js = document.createElement("script");
			js.src = a[i];
			document.body.appendChild(js);
		}
	}.bind(this));
}

var MSUEarlyConnection = function ()
{
	this.mSQHandle = null;
};
var oldRegisterScreens = registerScreens;
MSUEarlyConnection.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
	SQ.call(this.mSQHandle, "getEarlyJSHooks", null, function (_data)
	{
		for (var i = 0; i < _data.length-1; i++)
		{
			var js = document.createElement("script");
			js.src = _data[i];
			document.body.appendChild(js);
		}
		var resumeInit = function()
		{
			var tempCall = engine.call;
			engine.call = function(_functionName, _target, _arg1, _arg2)
			{
				if (_functionName == "registrationFinished") return;
				if (_functionName == "registerScreen" && _target == "RootScreen") return;
				return tempCall.call(this, _functionName, _target, _arg1, _arg2);
			}
			oldRegisterScreens();
			engine.call = tempCall;
			SQ.call(this.mSQHandle, "resumeOnInit", null)
		}

		if (_data == undefined || _data.length == 0) resumeInit.call(this);
		else
		{
			var js = document.createElement("script");
			js.src = _data[_data.length-1];
			js.onload = function()
			{
				resumeInit.call(this);
			}.bind(this);
			document.body.appendChild(js);
		}
	}.bind(this));
};

MSUEarlyConnection.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	delete Screens.MSUEarlyConnection;
};

registerScreens = function(){}; // need to do this so the document.ready in main.html does nothing
$(document).ready(function() // we instead replace that handler with this
{
	registerScreen("MSUEarlyConnection", new MSUEarlyConnection())
	registerScreen("RootScreen", new RootScreen()); // RootScreen needs to be init, main menu screen never shows otherwise
	engine.call("registrationFinished");
});
