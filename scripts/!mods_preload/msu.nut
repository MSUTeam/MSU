::MSU.EndQueue <- {
	Queue = [],

	function add( _function )
	{
		this.Queue.push(_function);
	}

	function run()
	{
		foreach (func in this.Queue)
		{
			func();
		}
	}
};

local _mods_runQueue = ::_mods_runQueue;
::_mods_runQueue = function()
{
	_mods_runQueue();
	::MSU.EndQueue.run();
}

::MSU.EarlyConnection <- ::new("scripts/mods/msu/early_js_connection");

::MSU.EarlyJSHooks <- []
::MSU.registerEarlyJSHook <- function( _scriptFile )
{
	this.EarlyJSHooks.push(_scriptFile);
}

::MSU.EndQueue.add(function()
{
	::mods_hookExactClass("root_state", function (o)
	{
		local onInit = o.onInit;
		o.resumeOnInit <- function()
		{
			local add = this.add;
			this.add = function(...);
			onInit();
			this.add = add;
		}

		o.onInit = function()
		{
			::MSU.Utils.States[this.ClassName] <- this;

			::MSU.EarlyConnection.connect();
			this.add("MainMenuState", "scripts/states/main_menu_state");
		}
	});

	::mods_hookExactClass("states/main_menu_state", function (o)
	{
		o.resumeOnInit <- o.onInit;
		o.onInit = function()
		{
			::MSU.Utils.States[this.ClassName] <- this;
			// this.initLoadingScreenHandler();
			this.show();
		}
		o.resumeOnShow <- o.onShow;
		o.onShow = function(){};
	});

	::mods_hookNewObjectOnce("ui/screens/menu/main_menu_screen", function (o)
	{
		o.onScreenShown = function()
		{
			::logInfo("onScreenShown");
			this.m.Visible = true;

			if (this.m.OnScreenShownListener != null)
			{
				this.m.OnScreenShownListener();
			}
		}
	})
})

::mods_registerMod(::MSU.VanillaID, ::MSU.SemVer.formatVanillaVersion(::GameInfo.getVersionNumber()), "Vanilla");
::mods_registerMod(::MSU.ID, ::MSU.Version, ::MSU.Name);
::mods_queue(::MSU.ID, "vanilla(>=1.5.0-13), !mod_legends(<16.0.0)", function()
{
	::include("msu/load.nut");
});
