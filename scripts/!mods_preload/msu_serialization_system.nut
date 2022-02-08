local gt = this.getroottable();

gt.MSU.setupSerializationSystem <- function ()
{
	gt.MSU.Serialization <- {
		Mods = [],

		function registerMod( _mod, _ver )
		{
			this.MSU.requireString(_mod, _ver);
			this.MSU.Serialization.Mods.push({ Name = _mod,	Version = _ver });
		}

		function compareSavedVersionTo( _ver, _mod, _metaData )
		{
			local savedVer = _metaData.getString(_mod + "Version");

		    if (savedVer == "") return -1;

		    _ver = split(_ver, ".").map(@(a) a.tointeger());
		    savedVer = split(savedVer, ".").map(@(a) a.tointeger());

		    foreach (i, num in _ver)
		    {
		        if (num > savedVer[i])
		        {
		            return -1;
		        }
		        else if (num < savedVer[i])
		        {
		            return 1;
		        }
		    }
		    
		    return 0;
		}
	}	

	::isSavedVersionAtLeast <- function( _ver, _mod, _metaData )
	{
		return this.MSU.Serialization.compareSavedVersionTo(_ver, _mod, _metaData) > -1;
	}

	::mods_hookExactClass("states/world_state", function(o) {
		local onBeforeSerialize = o.onBeforeSerialize;
		o.onBeforeSerialize = function( _out )
		{
			onBeforeSerialize(_out);
			local meta = _out.getMetaData();
			foreach (mod in this.MSU.Serialization.Mods)
			{
				meta.setString(mod.Name + "Version", mod.Version);
				this.logInfo(mod.Name + " Save Version " + mod.Version);
			}
		}

		local onBeforeDeserialize = o.onBeforeDeserialize;
		o.onBeforeDeserialize = function( _in )
		{
			onBeforeDeserialize(_in);
			foreach (mod in this.MSU.Serialization.Mods)
			{
				this.logInfo("Loading " + mod.Name + " Version " + _in.getMetaData().getString(mod.Name + "Version"));
			}
		}
	});
}
