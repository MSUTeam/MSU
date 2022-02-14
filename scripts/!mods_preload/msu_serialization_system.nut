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

	this.MSU.Systems.Serialization <- this.MSU.Class.SerialiationSystem();

	::isSavedVersionAtLeast <- function( _modID, _version )
	{
		return this.MSU.Mods[_modID].compareToVersionString(_version) > -1;
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
				this.logInfo(mod.getName() + " Save Version " + mod.getVersionString());
			}
		}

		local onBeforeDeserialize = o.onBeforeDeserialize;
		o.onBeforeDeserialize = function( _in )
		{
			onBeforeDeserialize(_in);
			foreach (mod in this.MSU.Systems.Serialization.Mods)
			{
				this.logInfo("Loading " + mod.getName() + " Version " + _in.getMetaData().getString(mod.getID() + "Version"));
			}
		}
	});
}
