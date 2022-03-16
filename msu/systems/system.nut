this.MSU.Class.System <- class
{
	ID = null;
	constructor( _id, _dependencies = null )
	{
		if (_dependencies == null) _dependencies = []

		foreach (dependency in _dependencies)
		{
			local found = false;
			foreach (system in this.MSU.System)
			{
				if (dependency == system.getID())
				{
					found = true;
					break;
				}
			}
			if (!found)
			{
				throw "Dependencies not yet initialized";
			}
		}
		this.ID = _id;
	}

	function getID()
	{
		return this.ID;
	}

	function registerMod( _mod )
	{
		if (!(_mod.getID() in this.MSU.Mods))
		{
			this.logError("Register your mod with this.MSU.registerMod first before registering it with MSU systems, and use the same ID");
			throw this.Exception.KeyNotFound;
		}
	}
}
