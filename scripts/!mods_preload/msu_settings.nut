local gt = this.getroottable();

gt.MSU.setupSettingsSystem <- function()
{
	gt.MSU.GenericSetting <- class
	{
		Name = null;
		ID = null;
		Value = null; // Serialized
		static Type = "Generic";
		Description = null;
		Locked = null; // Serialized
		LockReason = null; // Serialized
		
		constructor( _name, _value, _id = null)
		{
			Name = _name;
			ID = _id == null ? _name : _id;
			Value = _value; 
			Description = "";
			Locked = false;
			LockReason = "";
		}

		function set( _value )
		{
			if (Locked)
			{
				this.logError("Setting " + Name + " is locked and its value can't be changed")
				return;
			}

			Value = _value
		}

		function getValue()
		{
			return Value;
		}

		function setDescription( _description )
		{
			Description = _description;
		}

		function getName()
		{
			return Name;
		}

		function lock( _lockReason = "" ) //uncertain if this won't fuck up
		{
			Locked = true;
			LockReason = _lockReason;
		}

		function unlock()
		{
			Locked = false;
			LockReason = "";
		}

		function getUIData()
		{
			return {
				type = Type,
				name = Name,
				value = Value
			}
		}

		function getFlag( _modID )
		{
			return "ModSetting." + _modID + "." + Name;
		}

		function getPropertyFlag( _modID, _property )
		{
			return this.getFlag(_modID) + "." + _property;
		}

		function setFlagForProperty( _property, _modID )
		{
			this.World.Flags.set(this.getPropertyFlag(_modID, _property), this[_property]) 
		}

		function setPropertyIfFlagExists( _property, _modID )
		{
			local flag = this.getPropertyFlag(_modID, _property);
			if (this.World.Flags.has(flag))
			{
				this[_property] = this.World.Flags.get(flag);
			}
		}

		function clearFlagForProperty( _property, _modID )
		{
			local flag = this.getPropertyFlag(_modID, _property);
			if (this.World.Flags.has(flag))
			{
				this.World.Flags.remove(flag);
			}
		}

		function flagSerialize( _modID )
		{
			this.setFlagForProperty("Value", _modID);
			this.setFlagForProperty("Locked", _modID);
			this.setFlagForProperty("LockReason"_modID);
		}

		function flagDeserialize( _modID )
		{
			this.setPropertyIfFlagExists("Value", _modID);
			this.setPropertyIfFlagExists("Locked", _modID);
			this.setPropertyIfFlagExists("LockReason", _modID);
		}

		function resetFlags( _modID )
		{
			this.clearFlagForProperty("Value", _modID);
			this.clearFlagForProperty("Locked", _modID);
			this.clearFlagForProperty("LockReason", _modID);
		}

		function tostring()
		{
			return "Type: " + Type + " | Name: " + Name + " | Value: " + Value;
		}

		function _tostring()
		{
			return this.tostring();
		}
	}

	gt.MSU.BooleanSetting <- class extends gt.MSU.GenericSetting
	{
		static Type = "Boolean";

		constructor( _name, _value )
		{
			if (typeof _value != "bool")
			{
				this.logError("Boolean value must be a boolean");
				throw "Wrong Type";
			}
			base.constructor(_name, _value);
		}

		function set( _value )
		{
			if (typeof _value != "bool")
			{
				this.logError("Boolean value must be a boolean");
				throw "Wrong Type";
			}
			base.set(_value);
		}

		function getUIData()
		{
			local ret = base.getUIData();
			return ret;
		}
	}

	gt.MSU.RangeSetting <- class extends gt.MSU.GenericSetting
	{
		Min = null;
		Max = null;
		static Type = "Range";

		constructor( _name, _value, _min, _max )
		{
			base.constructor(_name, _value);
			Min = _min;
			Max = _max;
		}

		function getUIData()
		{
			local ret = base.getUIData();
			ret.min <- Min;
			ret.max <- Max;
			return ret;
		}

		function flagSerialize( _modID )
		{
			base.flagSerialize(_modID);
			this.setFlagForProperty("Min", _modID)
			this.setFlagForProperty("Max", _modID)
		}

		function flagDeserialize( _modID )
		{
			base.flagDeserialize(_modID);
			this.setPropertyIfFlagExists("Min", _modID);
			this.setPropertyIfFlagExists("Max", _modID);
		}

		function resetFlags( _modID )
		{
			base.resetFlags(_modID);
			this.clearFlagForProperty("Min", _modID);
			this.clearFlagForProperty("Max", _modID);
		}

		function tostring()
		{
			return base.tostring() + " | Min: " + Min + " | Max: " + Max;
		}
	}

	gt.MSU.TableSetting <- class extends gt.MSU.GenericSetting
	{
		Table = null;
		static Type = "Table";

		constructor( _name, _value, _table )
		{
			if (typeof _value != "string")
			{
				this.logError("Table value must be a string");
				throw "Wrong Type";
			}
			else if (!(_value in _table))
			{
				this.logError("Value must be a key in the Table");
				throw "Key not Found";
			}
			base.constructor(_name, _value);
			Table = _table
		}

		function getUIData()
		{
			local ret = base.getUIData();
			ret.table = [];
			foreach (key, value in Table)
			{
				ret.table.push([key, value.tostring()])
			}
			return ret;
		}

		function tostring()
		{
			local ret = base.tostring() + " | Table: \n";
			foreach (key, value in Table)
			{
				ret += " " + key + ": " + value + "\n";
			}
			return ret;
		}

		function flagDeserialize(_modID)
		{
			local flag = this.getPropertyFlag(_modID, "Value");
			if (this.World.Flags.has(flag))
			{
				local value = this.World.Flags.get(flag);
				if (value in Table)
				{
					Value = value;
				}
				else
				{
					this.logError("Value \'" + value + "\' not contained in table for Setting " + Name + " in mod " + _modID);
					throw "Key not Found"
				}
			}
			this.setPropertyIfFlagExists(_modID, "Locked")
			this.setPropertyIfFlagExists(_modID, "LockReason")
		}

		//Note the Table ISN'T serialized
	}

	gt.MSU.SettingsPage <- class
	{
		PageName = null;
		ModID = null;
		Settings = null;

		constructor( _name, _modID )
		{
			PageName = _name;
			ModID = _modID;	
			Settings = {};
		}

		function add( _setting )
		{
			if (!(_setting instanceof this.MSU.GenericSetting))
			{
				this.logError("Failed to add setting: setting needs to be one of the Setting types inheriting from GenericSetting");
				return;
			}
			Settings[_setting.getName()] <- _setting;
		}

		function getModID()
		{
			return ModID;
		}

		function get( _settingName )
		{
			return Settings[_settingName];
		}

		function doSettingsFunction(_function, ...)
		{
			vargv.insert(0, null);

			foreach (setting in Settings)
			{
				vargv[0] = setting;
				setting[_function].acall(vargv);
			}
		}

		function flagSerialize()
		{
			this.doSettingsFunction("flagSerialize", ModID);
		}

		function flagDeserialize()
		{
			this.doSettingsFunction("flagDeserialize", ModID);
		}

		function resetFlags()
		{
			this.doSettingsFunction("resetFlags", ModID);
		}

		function getUIData()
		{
			local ret = {
				name = PageName,
				mod = ModID,
				settings = []
			}

			foreach (setting in Settings)
			{
				ret.settings.push(setting.getUIData())
			}
			return ret;
		}

		function _tostring()
		{
			local ret = "Name: " + PageName + " | ModID: " + ModID + " | Settings:\n";

			foreach (setting in Settings)
			{
				ret += " " + setting
			}
		}
	}

	this.logInfo("test");

	this.MSU.SettingsManager <- this.new("scripts/mods/mod_settings_manager");
	this.MSU.SettingsScreen <- this.new("scripts/ui/mods/mod_settings_screen");


	local test = this.MSU.BooleanSetting("TestBool", true);
	local testPage = this.MSU.SettingsPage("TestPage", "MSU");
	testPage.add(test);
	this.MSU.SettingsManager.addPage(testPage);
}