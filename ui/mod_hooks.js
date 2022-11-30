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

var MSURootState = function ()
{
	this.mSQHandle = null;
};

MSURootState.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
	var self = this;
	SQ.call(this.mSQHandle, "getEarlyJSHooks", null, function (_data)
	{
		for (var i = 0; i < _data.length; i++)
		{
			var js = document.createElement("script");
			js.src = _data[i];
			document.body.appendChild(js);
		}
		console.error("getEarlyJSHooks JS")
		registerScreen("RootScreen", new RootScreen());
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
		SQ.call(self.mSQHandle, "resumeOnInit", null)
	});
};

MSURootState.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	console.error(Screens.MSURootState)
	delete Screens.MSURootState;

};

registerScreen("MSURootState", new MSURootState())

engine.call("registrationFinished");

