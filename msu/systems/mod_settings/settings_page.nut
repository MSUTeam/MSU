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