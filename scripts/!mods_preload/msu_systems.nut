local gt = this.getroottable();

gt.MSU.setupSystems <- function()
{
	this.MSU.Systems <- [];
	this.MSU.SystemDefinitions <- {};

	this.MSU.System <- class
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

	this.MSU.RequiredModSystem <- class extends this.MSU.System
	{
		function onModRegistered( _mod )
		{
		}
	}
}
