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

::MSU.EndQueue.add(function()
{
	::mods_hookExactClass("root_state", function (o)
	{
		local onInit = o.onInit;
		o.onInit = function()
		{
			::MSU.Utils.States[this.ClassName] <- this;
			::MSU.EarlyConnection.connect();
			this.add("MainMenuState", "scripts/states/main_menu_state"); // game immediately crashes if you don't do this
			::mods_callHook("root_state.onInit", this);
		}

		o.resumeOnInit <- function()
		{
			local add = this.add;
			this.add = function(...){};
			local mods_callHook = ::mods_callHook;
			::mods_callHook = function( ... )
			{
				if (vargv[0] != "root_state.onInit")
					mods_callHook.acall(vargv);
			}
			onInit();
			::mods_callHook = mods_callHook
			this.add = add;
		}
	});

	::mods_hookExactClass("states/main_menu_state", function (o)
	{
		o.resumeOnInit <- o.onInit;
		o.onInit = function()
		{
			::MSU.Utils.States[this.ClassName] <- this;
		}
	});
})

::mods_registerMod(::MSU.VanillaID, ::MSU.SemVer.formatVanillaVersion(::GameInfo.getVersionNumber()), "Vanilla");
::mods_registerMod(::MSU.ID, ::MSU.Version, ::MSU.Name);
::mods_queue(::MSU.ID, "vanilla(>=1.5.0-13), !mod_legends(<16.0.0)", function()
{
	::include("msu/load.nut");
});
