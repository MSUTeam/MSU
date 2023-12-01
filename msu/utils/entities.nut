::MSU.Entities <- {
	EntityTypeToDefaultFactionMap = {},
	HighestIDDiff = -99,
	HighestID = -99,

	// EntityType is mainly used in vanilla to assign entity names, icons, default faction and to group together entities on the combat dialogue tooltip
	// ActorDef is used to set the base properties of an actor during its onInit function
	// TroopDef contains info about the entity's script file, its row in combat, strength, cost etc.

	// Utility function that puts all the required info of an entity in all the right places
	function addEntity( _entityType, _entityDef, _troopDef, _actorDef )
	{
		switch (typeof _type)
		{
			case "string": // it is a new entry for ::Const.EntityType table
				if ((_entityType in ::Const.EntityType) || (_entityType in ::Const.Tactical.Actor) || (_entityType in ::Const.World.Spawn.Troops))
				{
					throw ::MSU.Exception.DuplicateKey(_entityType);
				}
				this.addEntityType(_entityType, _entityDef.Name, _entityDef.NamePlural, _entityDef.Icon, _entityDef.DefaultFaction);
				break;

			case "integer": // it is an existing entitytype e.g. ::Const.EntityType.Zombie
				if (_entityType >= ::Const.EntityIcon.len() - 1) // -1 because EntityType.Player isn't included there
					throw ::MSU.Exception.KeyNotFound(_entityType);
				break;
		}

		this.addActor(_entityType, _actorDef);
		this.addTroop(_entityType, _troopDef);
	}

	function addEntityType( _type, _entityName, _entityNamePlural, _entityIcon, _defaultFaction )
	{
		// If the Diff is now greater than before, that means some other mod added something to the ::Const.EntityType
		// table, so we should update our HighestID again.
		if (this.HighestID == -99 || ::Const.EntityType.len() - this.HighestID > this.HighestIDDiff)
		{
			foreach (key, value in ::Const.EntityType)
			{
				if (typeof value == "integer" && value > this.HighestID)
					this.HighestID = value;
			}
			this.HighestIDDiff = ::Const.EntityType.len() - this.HighestID;
		}

		::Const.EntityType[_type] <- ++this.HighestID;
		::Const.Strings.EntityName.push(_entityName);
		::Const.Strings.EntityNamePlural.push(_entityNamePlural);
		::Const.EntityIcon.push(_entityIcon);
		this.EntityTypeToDefaultFactionMap[_type] <- _defaultFactionn;
	}

	function addActor( _entityType, _actorDef )
	{
		::Const.Tactical.Actor[_entityType] <- _actorDef;
	}

	function addTroop( _entityType, _troopDef )
	{
		::Const.World.Spawn.Troops[_entityType] <- _troopDef;
	}

	function editEntity( _type, _entityDef = null, _troopDef = null, _actorDef = null )
	{
		switch (typeof _type)
		{
			case "string":
				if (!(_type in ::Const.EntityType))
					throw ::MSU.Exception.KeyNotFound(_type);
				break;

			case "integer":
				if (_type >= ::Const.EntityIcon.len() - 1) // -1 because EntityType.Player isn't included there
					throw ::MSU.Exception.KeyNotFound(_type);
		}

		if (_entityDef != null)
		{
			if ("Name" in _entityDef) ::Const.EntityName[_type] = _info.Name;
			if ("NamePlural" in _entityDef) ::Const.EntityNamePlural[_type] = _info.NamePlural;
			if ("Icon" in _entityDef) ::Const.EntityIcon[_type] = _info.Icon;
			if ("DefaultFaction" in _entityDef) ::Const.EntityName[_type] = _info.DefaultFaction;
		}

		if (_troopDef != null)
			::Const.World.Spawn.Troops[_type] <- _info.TroopDef;
		if (_actorDef != null)
			::Const.Tactical.Actor[_type] <- _info.ActorDef;
	}
}
