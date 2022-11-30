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

		var js = document.createElement("script");
		js.src = _data[_data.length-1];
		js.onload = function()
		{
			registerScreen("ConsoleScreen", new ConsoleScreen());
			registerScreen("LoadingScreen", new LoadingScreen());
			registerScreen("TooltipScreen", new TooltipScreen());
			registerScreen("DialogScreen", new DialogScreen());
			registerScreen("TacticalScreen", new TacticalScreen());
			registerScreen("TacticalCombatResultScreen", new TacticalCombatResultScreen());
			registerScreen("TacticalDialogScreen", new TacticalDialogScreen());
			registerScreen("WorldScreen", new WorldScreen());
			registerScreen("WorldTownScreen", new WorldTownScreen());
			registerScreen("WorldGameFinishScreen", new WorldGameFinishScreen());
			registerScreen("WorldEventPopupScreen", new WorldEventPopupScreen());
			registerScreen("WorldEventScreen", new WorldEventScreen());
			registerScreen("WorldCombatDialog", new WorldCombatDialog());
			registerScreen("WorldRelationsScreen", new WorldRelationsScreen());
			registerScreen("WorldObituaryScreen", new WorldObituaryScreen());
			registerScreen("WorldCampfireScreen", new WorldCampfireScreen());
			registerScreen("MainMenuScreen", new MainMenuScreen());
			registerScreen("WorldMenuScreen", new IngameMenuScreen());
			registerScreen("TacticalMenuScreen", new IngameMenuScreen());
			registerScreen("WorldCharacterScreen", new CharacterScreen(false));
			registerScreen("TacticalCharacterScreen", new CharacterScreen(true));

			Screens["Tooltip"] = Screens["TooltipScreen"];
			SQ.call(this.mSQHandle, "resumeOnInit", null)
		}.bind(this)
		document.body.appendChild(js);
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
