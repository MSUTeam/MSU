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
	// Try catch block to allow the game to continue if something in the queue
	// throws an exception e.g. incompatible mod version. Otherwise gets stuck
	// at black screen on startup without any info to the user.
	try
	{
		_mods_runQueue();
	}
	catch (error)
	{
	}
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
		}

		o.resumeOnInit <- function()
		{
			local add = this.add;
			this.add = function(...){};
			onInit();
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
