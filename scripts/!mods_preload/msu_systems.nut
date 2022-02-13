local gt = this.getroottable();

gt.MSU.setupSystems <- function()
{
	this.MSU.Systems <- {};
	this.MSU.SystemDefinitions <- {};
	this.MSU.SystemIDs <- {
		Serialization = 0,
		ModSettings = 1,
		ModRegistry = 2,
		Debug = 3
	}

	this.MSU.Class.System <- class
	{
		ID = null;
		constructor( _id, _dependencies = null )
		{
			if (_dependencies == null) _dependencies = []

			foreach (dependency in _dependencies)
			{
				local found = false;
				foreach (system in this.MSU.Systems)
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
	}

	this.MSU.Class.RequiredModSystem <- class extends this.MSU.Class.System
	{
		function onModRegistered( _mod )
		{
			return _mod.Options.find(this.getID()) != null;
		}
	}
}
