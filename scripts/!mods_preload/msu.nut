::MSU <- {};
::MSU.Version <- "1.0.0-alpha";
::MSU.ID <- "mod_msu";
::MSU.Name <- "Modding Standards & Utilities";
::MSU.VanillaID <- "vanilla";

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

::mods_registerMod(::MSU.ID, 1.0, ::MSU.Name);
::mods_queue(null, null, function()
{
	::include("msu/load.nut");
});
