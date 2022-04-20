::MSU.Class.SettingsPage <- class
{
	Name = null;
	ID = null;
	Settings = null;
	Panel = null;

	constructor( _id, _name = null )
	{
		this.ID = _id;	
		this.Name = _name == null ? _id : _name;
		this.Settings = ::MSU.Class.OrderedMap();
	}

	function add( _element )
	{
		if (!(_element instanceof ::MSU.Class.SettingsElement))
		{
			::logError("Failed to add element: element needs to extend SettingsElement");
			throw ::MSU.Exception.InvalidType(_element);
		}
		_element.setPage(this);
		this.Settings[_element.getID()] <- _element;
		return _element
	}

	function setPanel( _panel )
	{
		this.Panel = _panel.weakref();
	}

	function getPanel()
	{
		return this.Panel;
	}

	function getPanelID()
	{
		return this.getPanel().getID();
	}

	function getModID()
	{
		return this.getPanel().getModID();
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
		};

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
			ret += " " + setting;
		}
	}

	function _tostring()
	{
		return this.tostring();
	}
}
