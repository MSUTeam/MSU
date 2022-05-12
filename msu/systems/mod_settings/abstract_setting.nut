::MSU.Class.AbstractSetting <- class extends ::MSU.Class.SettingsElement
{
	static Type = "Abstract";
	Value = null;
	BaseValue = null;
	Locked = null;
	LockReason = null;
	Callbacks = null;
	Persistence = null; //if it should print change to log for further manipulation

	constructor( _id, _value, _name = null, _description = null )
	{
		base.constructor(_id, _name, _description)
		this.Value = _value;
		this.BaseValue = _value;
		this.Locked = false;
		this.LockReason = "";
		this.Persistence = true;
		this.Callbacks = [];
		this.Data.IsSetting <- true;
	}

	function setPersistence( _bool )
	{
		this.Persistence = _bool;
	}

	function getPersistence()
	{
		return this.Persistence;
	}

	function printForParser( _tag = "ModSetting" )
	{
		local payload = this.getValue();
		if (typeof payload == "string")
		{
			payload = "\"" + payload + "\"";
		}
		::MSU.System.PersistentData.writeToLog(_tag, this.getModID(), [this.getID(), payload]);
	}

	function onChangedCallback( _newValue )
	{
		foreach (callback in this.Callbacks)
		{
			callback.call(this, _newValue);
		}
	}

	function addCallback( _callback )
	{
		this.Callbacks.push(_callback);
	}

	function reset()
	{
		this.set(this.BaseValue, true, true, true, true);
	}

	function setBaseValue( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true, _force = false )
	{
		this.m.BaseValue = _value;
		this.set(_value, _updateJS, _updatePersistence, _updateCallback, _force);
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true, _force = false)
	{
		if (this.Locked)
		{
			::logError("Setting \'" + this.Name + "\'' is locked and its value can't be changed");
			return;
		}

		if (_value != this.Value || _force)
		{
			if (_updateCallback)
			{
				this.onChangedCallback(_value);
			}
			this.Value = _value;
			if (_updatePersistence && this.Persistence)
			{
				this.printForParser();
			}
			if (_updateJS)
			{
				::MSU.System.ModSettings.updateSettingInJS(this.getPanelID(), this.getID(), _value);
			}
		}
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
			ret += "[color=" + ::Const.UI.Color.NegativeValue + "]Locked[/color]\n";
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
		if (_lockReason != "") this.LockReason = _lockReason;
	}

	function unlock()
	{
		this.Locked = false;
		this.LockReason = "";
	}

	function getUIData(_flags = [])
	{
		local ret = base.getUIData(_flags);
		ret.locked <- this.isLocked();
		ret.value <- this.getValue();
		ret.currentValue <- this.getValue();
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
		::World.Flags.set(this.getPropertyFlag(_modID, _property), this[_property]);
	}

	function setPropertyIfFlagExists( _property, _modID )
	{
		local flag = this.getPropertyFlag(_modID, _property);
		if (::World.Flags.has(flag))
		{
			this[_property] = ::World.Flags.get(flag);
		}
	}

	function clearFlagForProperty( _property, _modID )
	{
		local flag = this.getPropertyFlag(_modID, _property);
		if (::World.Flags.has(flag))
		{
			::World.Flags.remove(flag);
		}
	}


	function flagSerialize()
	{
		local modID = this.getModID();
		this.setFlagForProperty("Value", modID);
		this.setFlagForProperty("Locked", modID);
		this.setFlagForProperty("LockReason", modID);
	}

	function flagDeserialize()
	{
		local modID = this.getModID();
		this.setPropertyIfFlagExists("Locked", modID);
		this.setPropertyIfFlagExists("LockReason", modID);

		local valueFlag = this.getPropertyFlag(modID, "Value");
		if (::World.Flags.has(valueFlag) && ::World.Flags.get(valueFlag) != "(null : 0x00000000)")
		{
			this.set(::World.Flags.get(valueFlag), true, false, true);
		}
	}

	function resetFlags()
	{
		local modID = this.getModID();
		this.clearFlagForProperty("Value", modID);
		this.clearFlagForProperty("Locked", modID);
		this.clearFlagForProperty("LockReason", modID);
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
