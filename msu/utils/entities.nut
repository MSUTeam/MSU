::MSU.Entities <- {
	EntityTypeToDefaultFactionMap = {},
	HighestIDDiff = -99,
	HighestID = -99,

	// Utility function that puts all the required info of an entity in all the right places
	function addEntity( _info )
	{
		// _info is a table that must contain the following keys:
		// EntityType, EntityIcon, DefaultFaction, EntityName, EntityNamePlural, TroopDef, ActorDef

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

		this.EntityTypeToDefaultFactionMap[_info.EntityType] <- _info.DefaultFaction;
		::Const.EntityType[_info.EntityType] <- ++this.HighestID;
		::Const.EntityIcon.push(_info.EntityIcon);
		::Const.Strings.EntityName.push(_info.EntityName);
		::Const.Strings.EntityNamePlural.push(_info.EntityNamePlural);
		::Const.World.Spawn.Troops[_info.EntityType] <- _info.TroopDef;
		::Const.Tactical.Actor[_info.EntityType] <- _info.ActorDef;
	}
}
