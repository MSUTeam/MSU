local gt = this.getroottable();

gt.MSU.setupSerializationSystem <- function ()
{
	this.MSU.Class.SerialiationSystem <- class extends this.MSU.Class.System
	{
		Mods = [],

		constructor()
		{
			base.constructor(this.MSU.SystemIDs.Serialization, [this.MSU.SystemIDs.ModRegistry]);
		}

		function registerMod( _modID )
		{
			base.registerMod(_modID);
			this.Mods.push(this.MSU.Mods[_modID]);
		}
	}

	this.MSU.Systems.Serialization <- this.MSU.Class.SerializationSystem();

	::isSavedVersionAtLeast <- function( _modID, _version )
	{
		return _version == "" || this.MSU.Mods[_modID].compareVersion(_version) > -1;
	}

	::mods_hookExactClass("states/world_state", function(o) {
		local onBeforeSerialize = o.onBeforeSerialize;
		o.onBeforeSerialize = function( _out )
		{
			onBeforeSerialize(_out);
			local meta = _out.getMetaData();
			foreach (mod in this.MSU.Systems.Serialization.Mods)
			{
				meta.setString(mod.getID() + "Version", mod.getVersionString());
				::printLog(format("MSU Serialization: Saving %s (%s), Version: %s", mod.getName(), mod.getID(), mod.getVersionString()), this.MSU.MSUModName);
			}
		}

		local onBeforeDeserialize = o.onBeforeDeserialize;
		o.onBeforeDeserialize = function( _in )
		{
			onBeforeDeserialize(_in);
			foreach (mod in this.MSU.Systems.Serialization.Mods)
			{
				local oldVersion = _in.getMetaData().getString(mod.getID() + "Version");
				if (oldVersion == "") return;

				switch (mod.compareVersion(oldVersion))
				{
					case -1:
						this.logInfo(format("MSU Serialization: Loading old save for mod %s (%s), %s => %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()));
						break;
					case 0:
						::printLog(format("MSU Serialization: Loading %s (%s), version %s", mod.getName(), mod.getID(), mod.getVersionString()), this.MSU.MSUModName);
						break;
					case 1:
						this.logWarning(format("MSU Serialiation: Loading save from newer version for mod %s (%s), %s => %s", mod.getName(), mod.getID(), oldVersion, mod.getVersionString()))
						break;
					default:
						this.logError("Something has gone very wrong with MSU Serialization");
						this.MSU.Systems.Debug.printStackTrace();
				}
			}
		}
	});
}
