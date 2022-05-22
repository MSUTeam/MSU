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

::mods_registerMod(::MSU.VanillaID, ::MSU.SemVer.formatVanillaVersion(::GameInfo.getVersionNumber()), "Vanilla");
::mods_registerMod(::MSU.ID, ::MSU.Version, ::MSU.Name);
::mods_queue(::MSU.ID, "vanilla(>=1.5.0-0), !mod_legends(<16.0.0)", function()
{
	::include("msu/load.nut");
});
