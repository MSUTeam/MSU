this.MSU.Class.AbstractSetting <- class extends this.MSU.Class.SettingsElement
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
		foreach (callback in this.Callbacks)
		{
			callback.call(this, _newValue);
		}
	}

	function addCallback(_callback)
	{
		this.Callbacks.push(_callback);
	}

	function set( _value, _updateJS = true, _updatePersistence = true )
	{
		if (this.Locked)
		{
			this.logError("Setting \'" + this.Name + "\'' is locked and its value can't be changed")
			return;
		}

		if (_value != this.Value)
		{
			this.onChangedCallback(_value);
			if (_updatePersistence && this.ParseChange == true)
			{
				this.MSU.PersistentDataManager.writeToLog("ModSetting", "MSU",  format("%s;%s", this.getID(), _value.tostring()))
			}
			this.Value = _value
			if (_updateJS)
			{
				this.MSU.UI.JSConnection.updateSetting(this.getPanelID(), this.getID(), _value)
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
