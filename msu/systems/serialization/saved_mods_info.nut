::MSU.Class.SavedModsInfo <- class
{
	static ModIDsSeparator = ",";
	static ModInfoSeparator = "&&";
	static CompatInfoSeparator = "^^";
	static CompatModSeparator = ",";
	static MetaDataSavedIDsKey = "MSU.SavedModsInfoIDs";
	static MetaDataSavedInfoPrefix = "MSU.SavedModInfo";
	// Used to pass the required _metadata arg in Hooks Mod constructor
	static EmptyTable = {};

	// Table
	// Key: ModID
	// Value: Instance of ::Hooks.SQClass.Mod
	Mods = null;

	// Pass metadata to load saved mods info from that metadata.
	constructor( _metadata = null )
	{
		this.Mods = {};

		if (_metadata == null)
			return;

		local ids = _metadata.hasData(this.MetaDataSavedIDsKey) ? _metadata.getString(this.MetaDataSavedIDsKey) : "";
		if (ids == "")
		{
			this.__loadOldData(_metadata);
			return;
		}

		foreach (id in split(ids, this.ModIDsSeparator))
		{
			this.Mods[id] <- this.__getModFromInfoString(_metadata.getString(this.MetaDataSavedInfoPrefix + id));
		}
	}

	// Used to load saved mod data from MSU 1.8.0 and older.
	function __loadOldData( _metadata )
	{
		if (!_metadata.hasData("MSU.SavedModIDs"))
			return;

		local ids = split(_metadata.getString("MSU.SavedModIDs"), ",");
		foreach (id in ids)
		{
			this.Mods[id] <- ::Hooks.SQClass.Mod(id, _metadata.getString(id + "Version") == "" ? "1.0.0" : _metadata.getString(id + "Version"), "", this.EmptyTable);
		}
	}

	// Converts a saved string to a new string which can
	// be passed to a HooksMod.require or .conflictWith function.
	// _str must be formatted as follows:
	// id,name,operator,version
	// where "commas" represent this.CompatInfoSeparator.
	// Return example: "mod_msu >= 1.8.0"
	function __getCompatString( _str )
	{
		local info = split(_str, this.CompatInfoSeparator);
		local operator = info[2];
		local version = info[3];
		local name = info[1];
		return format("%s%s%s%s", info[0], operator == "x" ? "" : " " + operator + " ", version == "x" ? "" : " " + version + " ", name == "x" ? "" : " (" + name + ")");
	}

	// Converts a mod to the following string:
	// id,name,version,requirements,incompatibilities
	// where "commas" represent this.CompatModSeparator.
	function __getInfoStringFromMod( _mod )
	{
		local reqStr = "";
		local conflictStr = "";
		foreach (data in ::Hooks.getMod(_mod.getID()).getCompatibilityData())
		{
			local name = data.getModName();
			if (name == data.getModID() && ::Hooks.hasMod(data.getModID()))
			{
				name = ::Hooks.getMod(data.getModID()).getName();
			}
			local str = format("%s%s%s%s%s%s%s",
							data.getModID(), this.CompatInfoSeparator,
							name, this.CompatInfoSeparator,
							data.Operator == null ? "x" : data.Operator + "", this.CompatInfoSeparator,
							data.Version == null ? "x" : data.Version + "");
			switch (data.CompatibilityType)
			{
				case ::Hooks.CompatibilityType.Requirement:
					reqStr += str + this.CompatModSeparator;
					break;
				case ::Hooks.CompatibilityType.Incompatibility:
					conflictStr += str + this.CompatModSeparator;
					break;
			}
		}
		return format("%s%s%s%s%s%s%s%s%s",
						_mod.getID(), this.ModInfoSeparator,
						_mod.getName(), this.ModInfoSeparator,
						_mod.getVersionString(), this.ModInfoSeparator,
						reqStr == "" ? "x" : reqStr.slice(0, -this.CompatModSeparator.len()), this.ModInfoSeparator,
						conflictStr == "" ? "x" : conflictStr.slice(0, -this.CompatModSeparator.len()));
	}

	// Creates and returns a Hooks.SQClass.Mod instance from the info string.
	// _str must be formatted as follows:
	// id,name,version,requirements,incompatibilities
	// where "commas" represent this.CompatModSeparator.
	function __getModFromInfoString( _str )
	{
		local info = split(_str, this.ModInfoSeparator);

		local ret = ::Hooks.SQClass.Mod(info[0], info[2], info[1], this.EmptyTable);
		if (info[3] != "x")
		{
			foreach (req in split(info[3], this.CompatModSeparator))
			{
				ret.require(this.__getCompatString(req));
			}
		}
		if (info[4] != "x")
		{
			foreach (conflict in split(info[4], this.CompatModSeparator))
			{
				ret.conflictWith(this.__getCompatString(conflict));
			}
		}

		return ret;
	}

	function getMods()
	{
		return this.Mods;
	}

	function hasMod( _id )
	{
		return _id in this.Mods;
	}

	function getMod( _id )
	{
		return this.Mods[_id];
	}

	// Mods can use this to clear compatibility data from existing save for a mod.
	// Use Case: You create a compatibility patch for 2 mods
	// and want to remove the incompatibility declaration from the saved mod.
	// Use Case: You create a fork of a mod and want different compatibility data.
	// How to use: After clearing the compatibility data, you should define your own for that mod using
	// getMod(_id) and then using the Modern Hooks .require and .conflictWith functions on that mod.
	function clearCompatibilityData( _sourceModID, _targetModID )
	{
		local sourceMod = this.getMod(_sourceModID);
		for (local i = sourceMod.CompatibilityData.len() - 1; i >= 0; i--)
		{
			if (sourceMod.CompatibilityData[i].getModID() == _targetModID)
			{
				sourceMod.CompatibilityData.remove(i);
			}
		}
	}

	function validateMods()
	{
		// We allow mods to adjust the compatibility data before we validate it.
		::MSU.System.Serialization.onValidateSavedMods(this);

		local compatErrors = [];

		// Check compatibility of saved mods with installed mods.
		foreach (mod in this.getMods())
		{
			foreach (compatibilityData in mod.getCompatibilityData())
			{
				local result = compatibilityData.validate(::Hooks.getMods());
				if (result == ::Hooks.CompatibilityCheckResult.Success)
					continue;
				compatErrors.push({
					Source = mod,
					Target = compatibilityData,
					Reason = result,
					IsTargetSaved = false
				});
			}
		}

		// Check compatibility of installed mods with saved mods.
		foreach (mod in ::Hooks.getMods())
		{
			foreach (compatibilityData in mod.getCompatibilityData())
			{
				local result = compatibilityData.validate(this.getMods());
				if (result == ::Hooks.CompatibilityCheckResult.Success)
					continue;
				compatErrors.push({
					Source = mod,
					Target = compatibilityData,
					Reason = result,
					IsTargetSaved = true
				});
			}
		}

		if (compatErrors.len() == 0)
			return compatErrors;

		foreach (i, error in compatErrors)
		{
			local requireString = error.Target.CompatibilityType == ::Hooks.CompatibilityType.Requirement ? "requires" : "conflicts with";
			switch (error.Reason)
			{
				case ::Hooks.CompatibilityCheckResult.ModMissing:
					local name = error.Target.getModID() in ::Hooks.CachedModNames ? ::Hooks.CachedModNames[error.Target.getModID()] : error.Target.getModName();
					compatErrors[i] = format("%s %s (%s) %s %s %s (%s)%s", error.IsTargetSaved ? "Installed" : "Saved", error.Source.getID(), error.Source.getName(), requireString, error.IsTargetSaved ? "Saved" : "Installed", error.Target.getModID(), name, error.Target.getFormattedDetails());
					break;
				case ::Hooks.CompatibilityCheckResult.ModPresent:
					local mod = error.IsTargetSaved ? this.getMod(error.Target.getModID()) : ::Hooks.getMod(error.Target.getModID());
					compatErrors[i] = format("%s %s (%s) is incompatible with %s %s (%s)%s", error.IsTargetSaved ? "Saved" : "Installed", error.Source.getID(), error.Source.getName(), error.IsTargetSaved ? "Installed" : "Saved", mod.getID(), mod.getName(), error.Target.getFormattedDetails());
					break;
				case ::Hooks.CompatibilityCheckResult.TooSmall:
					local mod = error.IsTargetSaved ? this.getMod(error.Target.getModID()) : ::Hooks.getMod(error.Target.getModID());
					compatErrors[i] = format("%s %s (%s) version %s is outdated for %s %s (%s), which %s versions %s", error.IsTargetSaved ? "Saved" : "Installed", mod.getID(), mod.getName(), mod.getVersionString(), error.IsTargetSaved ? "Installed" : "Saved", error.Source.getID(), error.Source.getName(), requireString, error.Target.getErrorString());
					break;
				case ::Hooks.CompatibilityCheckResult.TooBig:
					local mod = error.IsTargetSaved ? this.getMod(error.Target.getModID()) : ::Hooks.getMod(error.Target.getModID());
					compatErrors[i] = format("%s %s (%s) version %s is too new for %s %s (%s), which %s versions %s", error.IsTargetSaved ? "Saved" : "Installed", mod.getID(), mod.getName(), mod.getVersionString(), error.IsTargetSaved ? "Installed" : "Saved", error.Source.getID(), error.Source.getName(), requireString, error.Target.getErrorString());
					break;
				case ::Hooks.CompatibilityCheckResult.Incorrect:
					local mod = error.IsTargetSaved ? this.getMod(error.Target.getModID()) : ::Hooks.getMod(error.Target.getModID());
					compatErrors[i] = format("%s %s (%s) version %s is wrong for %s %s (%s), which %s (a) version %s", error.IsTargetSaved ? "Saved" : "Installed", mod.getID(), mod.getName(), mod.getVersionString(), error.IsTargetSaved ? "Installed" : "Saved", error.Source.getID(), error.Source.getName(), requireString, error.Target.getErrorString());
					break;
			}
		}

		return compatErrors;
	}

	function __parseOperatorToString( _operator )
	{
		switch (_operator)
		{
			case ::Hooks.Operator.LT:
				return "<";
			case ::Hooks.Operator.LE:
				return "<=";
			case ::Hooks.Operator.EQ:
				return "==";
			case ::Hooks.Operator.NE:
				return "!=";
			case ::Hooks.Operator.GE:
				return ">=";
			case ::Hooks.Operator.GT:
				return ">";
		}
		return "";
	}

	function saveToMetaData( _metadata )
	{
		local modIds = "";
		foreach (mod in ::Hooks.getMods())
		{
			::MSU.Mod.Debug.printLog(format("MSU Serialization: Saving %s (%s), Version: %s", mod.getName(), mod.getID(), mod.getVersionString()));

			modIds += mod.getID() + this.ModIDsSeparator;
			_metadata.setString(this.MetaDataSavedInfoPrefix + mod.getID(), this.__getInfoStringFromMod(mod));
		}
		if (modIds != "")
		{
			modIds.slice(0, -this.ModIDsSeparator.len());
		}
		_metadata.setString(this.MetaDataSavedIDsKey, modIds);
	}
}
