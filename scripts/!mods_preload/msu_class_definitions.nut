local gt = this.getroottable();
gt.MSU.defineClasses <- function()
{
	this.MSU.Class <- {};
	this.MSU.Class.OrderedMap <- class
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
			throw this.Exception.KeyNotFound;
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
			for (local i = 1; i < this.Array.len(); ++i)
			{
				local key = this.Array[i];
				local j = i - 1;
				while (j >= 0 && _function(key, this.Table[key], this.Array[j], this.Table[this.Array[j]]) <= 0)
				{
					this.Array[j+1] = this.Array[j];
					--j;
				}

				this.Array[j+1] = key;
			}
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

		function shuffle()
		{
			this.MSU.Array.shuffle(this.Array);
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

	this.MSU.Class.WeightedContainer <- class
	{
		Total = null;
		Array = null;

		constructor()
		{
			this.Total = 0;
			this.Array = [];
		}

		function extend( _array )
		{
			foreach (i in _array)
			{
				this.push(i);
			}
		}

		function push( _item )
		{
			if (typeof _item != "array") _item = [1, _item];

			this.Total += _item[0];
			this.Array.push(_item);
		}

		function roll()
		{
			local roll = this.Math.rand(1, this.Total);
			local weight = 0;
			foreach (pair in this.Array)
			{
				if (roll <= pair[0]) return pair;
				roll -= pair[0];
			}

			return null;
		}

		function rollChance(_chance)
		{
			return _chance < this.Math.rand(1, 100) ? this.roll() : null;
		}

		function _nexti( _idx )
		{
			if (_idx == null) _idx = -1;

			return ++_idx == this.len() ? _idx : null;
		}

		function _get(_idx)
		{
			return this.Array[_idx];
		}

		function len()
		{
			return this.Array.len();
		}

		function onSerialize( _out )
		{
			_out.writeU32(this.Total);
			_out.writeU32(this.len());
			foreach (pair in this.Array)
			{
				_out.writeU16(pair[0]);
				_out.writeString(pair[1]);
			}
		}

		function onDeserialize( _in )
		{
			this.Total = _in.readU32();
			for (local i = 0; i < _in.readU32(); ++i)
			{
				this.Array.push([_in.readU16(), _in.readString()]);
			}
		}
	}

	gt.MSU.Class.SettingsElement <- class
	{
		Name = null;
		ID = null;
		static Type = "Element";
		Flags = null;
		Description = null;

		constructor(_id, _name = null)
		{
			if (_id.find(" ") != null)
			{
				this.logError("The ID of a Setting Element should not have spaces");
				throw this.Exception.InvalidType;
			}
			this.Name = _name == null ? _id : _name;
			this.ID = _id;
			this.Flags = [];
			this.Description = "";
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

		function addFlags( ... )
		{
			this.Flags.extend(vargv);
		}

		function getFlags()
		{
			return this.Flags;
		}

		function verifyFlags( _flags )
		{
			if (_flags != null)
			{
				if ("required" in _flags)
				{
					foreach (required in _flags.required)
					{
						if (this.Flags.find(required) == null)
						{
							return false;
						}
					}
				}
				if ("excluded" in _flags)
				{
					foreach (excluded in _flags.excluded)
					{
						if (this.Flags.find(excluded) != null)
						{
							return false;
						}
					}
				}
			}
			return true;
		}

		function getUIData()
		{
			return {
				type = this.getType(),
				id = this.getID(),
				name = this.getName()
			};
		}
	}

	gt.MSU.Class.AbstractSetting <- class extends this.MSU.Class.SettingsElement
	{
		
		static Type = "Abstract";
		Value = null;// Serialized
		Locked = null; // Serialized
		LockReason = null; // Serialized
		Callbacks = null;
		ParseChange = null; //if it should print change to log for further manipulation
		
		constructor( _id, _value, _name = null )
		{
			base.constructor(_id, _name)
			this.Value = _value; 
			this.Locked = false;
			this.LockReason = "";
			this.ParseChange = true;
			this.Callbacks = [];
		}

		function setParseChange(_bool)
		{
			this.ParseChange = _bool;
		}

		function getParseChange()
		{
			return this.ParseChange
		}

		function onChangedCallback(_newValue)
		{
			foreach(callback in this.Callbacks)
			{
				callback.call(this, _newValue);
			}
		}

		function addCallback(_callback)
		{
			this.Callbacks.push(_callback);
		}

		function set( _value )
		{
			if (this.Locked)
			{
				this.logError("Setting \'" + this.Name + "\'' is locked and its value can't be changed")
				return;
			}

			this.Value = _value
		}

		function getValue()
		{
			return this.Value;
		}

		function setDescription( _description )
		{
			this.Description = _description;
		}

		function getDescription()
		{
			local ret = "";
			if (this.isLocked())
			{
				ret += "[color=" + this.Const.UI.Color.NegativeValue + "]Locked[/color]\n"
				if (this.LockReason != "")
				{
					ret += this.LockReason + "\n";
				}
			}
			ret += base.getDescription();
			return ret;
		}

		function isLocked()
		{
			return this.Locked;
		}

		function getLockReason()
		{
			return this.LockReason;
		}

		function lock( _lockReason = "" )
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
			local ret = base.getUIData();
			ret.locked <- this.isLocked();
			ret.value <- this.getValue();
			return ret;
		}

		function getSerDeFlag( _modID )
		{
			return "ModSetting." + _modID + "." + this.getID();
		}

		function getPropertyFlag( _modID, _property )
		{
			return this.getSerDeFlag(_modID) + "." + _property;
		}

		function setFlagForProperty( _property, _modID )
		{
			this.World.Flags.set(this.getPropertyFlag(_modID, _property), this[_property]);
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
			return "Type: " + this.getType() + " | ID: " + this.getID() + " | Name: " + this.getName() + " | Value: " + this.getValue();
		}

		function _tostring()
		{
			return this.tostring();
		}
	}

	gt.MSU.Class.BooleanSetting <- class extends gt.MSU.Class.AbstractSetting
	{
		static Type = "Boolean";

		constructor( _id, _value, _name = null)
		{
			if (typeof _value != "bool")
			{
				this.logError("The value for Boolean Setting must be a boolean");
				throw this.Exception.InvalidType;
			}
			base.constructor(_id, _value, _name);
		}

		function set( _value )
		{
			if (typeof _value != "bool")
			{
				this.logError("The value for Boolean Setting must be a boolean");
				throw this.Exception.InvalidType;
			}
			base.set(_value);
		}
	}

	gt.MSU.Class.StringSetting <- class extends gt.MSU.Class.AbstractSetting
	{
		static Type = "String";

		constructor( _id, _value, _name = null)
		{
			if (typeof _value != "string")
			{
				this.logError("The value for String Setting must be a string");
				throw this.Exception.InvalidType;
			}
			base.constructor(_id, _value, _name);
		}

		function set( _value )
		{
			if (typeof _value != "string")
			{
				this.logError("The value for String Setting must be a string");
				throw this.Exception.InvalidType;
			}
			base.set(_value);
		}
	}

	gt.MSU.RangeSetting <- class extends gt.MSU.AbstractSetting
	{
		Min = null;
		Max = null;
		Step = null;
		static Type = "Range";

		constructor( _id, _value, _min, _max, _step, _name = null )
		{
			base.constructor(_id, _value, _name);

			foreach (num in [_min, _max, _step])
			{
				if ((typeof num != "integer") && (typeof num != "float"))
				{
					this.logError("Max, Min and Step in a Range Setting have to be integers or floats");
					throw this.Exception.InvalidType;
				}
			}

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

		function tostring()
		{
			return base.tostring() + " | Min: " + this.getMin() + " | Max: " + this.getMax() + " | Step: " + this.getStep();
		}
	}

	gt.MSU.Class.EnumSetting <- class extends gt.MSU.Class.AbstractSetting
	{
		Array = null;
		static Type = "Enum";

		constructor( _id, _array, _value = null, _name = null )
		{
			if (_value == null)
			{
				_value = _array[0];
			}
			else if (_array.find(_value) == null)
			{
				this.logError("Value must be an element in the Array");
				throw this.Exception.KeyNotFound;
			}
			base.constructor(_id, _value, _name);
			this.Array = _array;
		}

		function getUIData()
		{
			local ret = base.getUIData();
			ret.array <- this.Array;
			return ret;
		}

		function tostring()
		{
			local ret = base.tostring() + " | Array: \n";
			foreach (value in this.Array)
			{
				ret += value + "\n";
			}
			return ret;
		}

		function flagDeserialize(_modID)
		{
			base.flagDeserialize(_modID);
			if (this.Array.find(this.Value) == null)
			{
				this.logError("Value \'" + this.Value + "\' not contained in array for setting " + this.getID() + " in mod " + _modID);
				this.Value = this.Array[0];
			}
		}

		//Note the Array ISN'T serialized
	}

	gt.MSU.Class.SettingsDivider <- class extends gt.MSU.Class.SettingsElement
	{
		static Type = "Divider";
		constructor(_id, _name = "")
		{
			base.constructor(_id, _name);
		}
	}

	gt.MSU.Class.SettingsPanel <- class
	{
		Pages = null;
		ID = null;
		Name = null;

		constructor( _id, _name = null )
		{
			this.ID = _id;
			this.Name = _name == null ? _id : _name;
			this.Pages = this.MSU.Class.OrderedMap();
		}

		function getPages()
		{
			return this.Pages;
		}

		function addPage( _page )
		{
			if (!(_page instanceof this.MSU.Class.SettingsPage))
			{
				throw this.Exception.InvalidType;
			}
			this.Pages[_page.getID()] <- _page;
		}

		function getSetting( _settingID )
		{
			foreach (page in this.Pages)
			{
				if ( page.Settings.Array.find(_settingID) != null)
				{
					return page.get(_settingID);
				}
			}

			throw this.Exception.KeyNotFound;
		}

		function hasPage( _pageID )
		{
			return this.getPages().contains(_pageID)
		}

		function getPage( _pageID )
		{
			return this.Pages[_pageID]
		}

		function verifyFlags( _flags )
		{
			foreach (page in this.Pages)
			{
				if (page.verifyFlags(_flags))
				{
					return true;
				}
			}
			return false;
		}

		function getName()
		{
			return this.Name;
		}

		function getID()
		{
			return this.ID;
		}

		function doSettingsFunction( _function, ... )
		{
			vargv.insert(0, null);
			foreach (page in this.Pages)
			{
				foreach (setting in page.getSettings())
				{
					if (setting instanceof this.MSU.Class.AbstractSetting)
					{
						vargv[0] = setting;
						setting[_function].acall(vargv);
					}
				}
			}
		}

		function flagSerialize()
		{
			this.doSettingsFunction("flagSerialize", this.getID());
		}

		function flagDeserialize()
		{
			this.doSettingsFunction("flagDeserialize", this.getID());
		}

		function resetFlags()
		{
			this.doSettingsFunction("resetFlags", this.getID());
		}

		function getUIData( _flags )
		{
			local ret = {
				id = this.getID(),
				name = this.getName(),
				pages = []
			}

			foreach (pageID, page in this.Pages)
			{
				if (page.verifyFlags(_flags))
				{
					ret.pages.push(page.getUIData(_flags));
				}
			}

			return ret;
		}
	}

	this.MSU.Class.SettingsPage <- class
	{
		Name = null;
		ID = null;
		Settings = null;

		constructor( _id, _name = null )
		{
			this.ID = _id;	
			this.Name = _name == null ? _id : _name;
			this.Settings = this.MSU.Class.OrderedMap();
		}

		function add( _element )
		{
			if (!(_element instanceof this.MSU.Class.SettingsElement))
			{
				this.logError("Failed to add element: element needs to be one of the Setting elements inheriting from SettingsElement");
				throw this.Exception.InvalidType;
			}
			this.Settings[_element.getID()] <- _element;
		}

		function getID()
		{
			return this.ID;
		}

		function getName()
		{
			return this.Name;
		}

		function getSettings()
		{
			return this.Settings;
		}

		function get( _settingID )
		{
			return this.Settings[_settingID];
		}

		function verifyFlags( _flags )
		{
			foreach (setting in this.Settings)
			{
				if (setting.verifyFlags(_flags))
				{
					return true;
				}
			}
			return false;
		}

		function getUIData( _flags )
		{
			local ret = {
				name = this.getName(),
				id = this.getID(),
				settings = []
			}

			foreach (setting in this.Settings)
			{
				if (setting.verifyFlags(_flags))
				{
					ret.settings.push(setting.getUIData());
				}
			}
			return ret;
		}

		function tostring()
		{
			local ret = "Name: " + this.getName() + " | ID: " + this.getID() + " | Settings:\n";

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
