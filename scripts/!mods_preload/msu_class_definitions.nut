local gt = this.getroottable();
gt.MSU.defineClasses <- function()
{
	gt.MSU.OrderedMap <- class
	{
		Array = null;
		Table = null;
		constructor()
		{
			this.Array = [];
			this.Table = {};
		}

		function _newslot( _key, _value )
		{
			this.Array.push(_key);
			this.Table[_key] <- _value;
		}

		function _delslot( _key )
		{
			for (local i = 0; i < this.Array; ++i)
			{
				if (this.Array[i] == _key)
				{
					this.Array.remove(i)
					delete this.Table[_key];
					return;
				}
			}
			throw "The index \'" + _key + "\' does not exist and couldn't be removed";
		}

		function _set( _key, _value )
		{
			this.Table[_key] = _value;
		}

		function _get( _key )
		{
			return this.Table[_key]
		}

		function _nexti( _prev )
		{
			_prev = _prev == null ? 0 : this.Array.find(_prev) + 1;

			return _prev == this.Array.len() ? null : this.Array[_prev];
		}

		function sort( _function )
		{
			this.Array.sort(_function)
		}

		function reverse()
		{
			this.Array.reverse();
		}

		function clear()
		{
			this.Array.clear();
			this.Table.clear();
		}

		function len()
		{
			return this.Array.len();
		}

		function contains( _value )
		{
			return _value in this.Table;
		}
	}

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
			this.Name = _name;
			this.ID = _id == null ? _name : _id;
			this.Value = _value; 
			this.Description = "";
			this.Locked = false;
			this.LockReason = "";
		}

		function set( _value )
		{
			if (Locked)
			{
				this.logError("Setting " + this.Name + " is locked and its value can't be changed")
				return;
			}

			this.Value = _value
		}

		function getValue()
		{
			return this.Value;
		}

		function getType()
		{
			return this.Type;
		}

		function setDescription( _description )
		{
			this.Description = _description;
		}

		function getDescription()
		{
			return this.Description;
		}

		function getName()
		{
			return this.Name;
		}

		function getID()
		{
			return this.ID;
		}

		function isLocked()
		{
			return this.Locked;
		}

		function getLockReason()
		{
			return this.LockReason;
		}

		function lock( _lockReason = "" ) //uncertain if this won't fuck up
		{
			this.Locked = true;
			this.LockReason = _lockReason;
		}

		function unlock()
		{
			this.Locked = false;
			this.LockReason = "";
		}

		function getUIData()
		{
			return {
				type = this.getType(),
				id = this.getID(),
				name = this.getName(),
				locked = this.isLocked(),
				value = this.getValue()
			}
		}

		function getFlag( _modID )
		{
			return "ModSetting." + _modID + "." + this.getName();
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
			return "Type: " + this.getType() + " | Name: " + this.getName() + " | Value: " + this.getValue();
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
		Step = null;
		static Type = "Range";

		constructor( _name, _value, _min, _max, _step )
		{
			base.constructor(_name, _value);
			this.Min = _min;
			this.Max = _max;
			this.Step = _step;
		}

		function getMin()
		{
			return this.Min;
		}

		function getMax()
		{
			return this.Max;
		}

		function getStep()
		{
			return this.Step;
		}

		function getUIData()
		{
			local ret = base.getUIData();
			ret.min <- this.getMin();
			ret.max <- this.getMax();
			ret.step <- this.getStep();
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
			return base.tostring() + " | Min: " + this.getMin() + " | Max: " + this.getMax() + " | Step: " + this.getStep();
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
			this.Table = _table
		}

		function getUIData()
		{
			local ret = base.getUIData();
			ret.table = [];
			foreach (key, value in this.Table)
			{
				ret.table.push([key, value.tostring()])
			}
			return ret;
		}

		function tostring()
		{
			local ret = base.tostring() + " | Table: \n";
			foreach (key, value in this.Table)
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
				if (value in this.Table)
				{
					Value = value;
				}
				else
				{
					this.logError("Value \'" + value + "\' not contained in table for Setting " + this.getName() + " in mod " + _modID);
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
			this.PageName = _name;
			this.ModID = _modID;	
			this.Settings = this.MSU.OrderedMap();
		}

		function add( _setting )
		{
			if (!(_setting instanceof this.MSU.GenericSetting))
			{
				this.logError("Failed to add setting: setting needs to be one of the Setting types inheriting from GenericSetting");
				return;
			}
			this.Settings[_setting.getID()] <- _setting;
		}

		function getModID()
		{
			return this.ModID;
		}

		function get( _settingID )
		{
			return this.Settings[_settingID];
		}

		function doSettingsFunction(_function, ...)
		{
			vargv.insert(0, null);

			foreach (setting in this.Settings)
			{
				vargv[0] = setting;
				setting[_function].acall(vargv);
			}
		}

		function flagSerialize()
		{
			this.doSettingsFunction("flagSerialize", this.ModID);
		}

		function flagDeserialize()
		{
			this.doSettingsFunction("flagDeserialize", this.ModID);
		}

		function resetFlags()
		{
			this.doSettingsFunction("resetFlags", this.ModID);
		}

		function getUIData()
		{
			local ret = {
				name = this.PageName,
				modID = this.getModID(),
				settings = []
			}

			foreach (setting in this.Settings)
			{
				ret.settings.push(setting.getUIData());
			}
			return ret;
		}

		function tostring()
		{
			local ret = "Name: " + this.PageName + " | ModID: " + this.getModID + " | Settings:\n";

			foreach (setting in this.Settings)
			{
				ret += " " + setting
			}
		}

		function _tostring()
		{
			return this.tostring();
		}
	}
}