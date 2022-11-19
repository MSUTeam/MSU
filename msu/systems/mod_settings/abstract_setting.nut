::MSU.Class.AbstractSetting <- class extends ::MSU.Class.SettingsElement
{
	static Type = "Abstract";
	Value = null;
	BaseValue = null;
	Locked = null;
	LockReason = null;
	BeforeChangeCallbacks = null;
	AfterChangeCallbacks = null;
	Persistence = null; //if it should print change to log for further manipulation

	constructor( _id, _value, _name = null, _description = null )
	{
		base.constructor(_id, _name, _description)
		this.Value = _value;
		this.BaseValue = _value;
		this.Locked = false;
		this.LockReason = "";
		this.Persistence = true;
		this.BeforeChangeCallbacks = [];
		this.AfterChangeCallbacks = [];
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
		::MSU.System.PersistentData.writeToLog(_tag, this.getMod().getID(), [this.getID(), payload]);
	}

	function onBeforeChangeCallback( _newValue )
	{
		foreach (callback in this.BeforeChangeCallbacks)
		{
			callback.call(this, _newValue);
		}
	}

	function onAfterChangeCallback( _oldValue )
	{
		foreach (callback in this.AfterChangeCallbacks)
		{
			callback.call(this, _oldValue);
		}
	}

	function addBeforeChangeCallback( _callback )
	{
		this.BeforeChangeCallbacks.push(_callback);
	}

	function addAfterChangeCallback( _callback )
	{
		this.AfterChangeCallbacks.push(_callback);
	}

	function reset()
	{
		this.set(this.BaseValue, {Force = true});
	}

	function setBaseValue( _value, _reset = false)
	{
		this.m.BaseValue = _value;
		if (_reset)
		{
			this.reset();
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
		local ret = base.getDescription();
		if (this.isLocked())
		{
			ret += "\n\n[color=" + ::Const.UI.Color.NegativeValue + "]Locked[/color]\n";
			if (this.LockReason != "")
			{
				ret += this.getLockReason();
			}
		}
		return ret;
	}

	function isLocked()
	{
		return this.Locked;
	}

	function getLockReason()
	{
		return this.LockReason == "" ? "" : this.LockReason.slice(0, -5);
	}

	function lock( _lockReason = "" )
	{
		this.Locked = true;
		if (_lockReason != "") this.LockReason += _lockReason + " +++ ";
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
		local modID = this.getMod().getID();
		this.setFlagForProperty("Value", modID);
		this.setFlagForProperty("Locked", modID);
		this.setFlagForProperty("LockReason", modID);
	}

	function flagDeserialize()
	{
		local modID = this.getMod().getID();
		this.setPropertyIfFlagExists("Locked", modID);
		this.setPropertyIfFlagExists("LockReason", modID);

		local valueFlag = this.getPropertyFlag(modID, "Value");
		if (::World.Flags.has(valueFlag) && ::World.Flags.get(valueFlag) != "(null : 0x00000000)")
		{
			this.set(::World.Flags.get(valueFlag), {UpdatePersistence = false});
		}
	}

	function resetFlags()
	{
		local modID = this.getMod().getID();
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

	// Deprecated
	function addCallback( _callback )
	{
		this.addBeforeChangeCallback(_callback);
	}
	function set(){}

	set = ::MSU.Class.KwargsFunction(
	{
		UpdateJS = true,
		UpdatePersistence = true,
		UpdateBeforeChangeCallback = true,
		UpdateAfterChangeCallback = true,
		Force = false
	},
	function(_newValue, _kwargs = null)
	{
		::logInfo("?????");
		if (this.Locked)
		{
			::logError("Setting \'" + this.Name + "\'' is locked and its value cannot be changed. Lock reason: " + this.getLockReason());
			return false;
		}

		if ((_newValue == this.Value) && !_kwargs.Force)
		{
			return false;
		}

		local oldValue = this.Value;
		if (_kwargs.UpdateBeforeChangeCallback)
		{
			this.onBeforeChangeCallback(_newValue);
		}
		this.Value = _newValue;
		if (_kwargs.UpdateAfterChangeCallback)
		{
			this.onAfterChangeCallback(oldValue);
		}
		if (_kwargs.UpdatePersistence && this.Persistence)
		{
			this.printForParser();
		}
		if (_kwargs.UpdateJS)
		{
			::MSU.System.ModSettings.updateSettingInJS(this.getPanelID(), this.getID(), _newValue);
		}

		return true;
	});
}
