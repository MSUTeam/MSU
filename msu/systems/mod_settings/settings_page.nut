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

	function addElement( _element )
	{
		if (!(_element instanceof ::MSU.Class.SettingsElement))
		{
			::logError("Failed to add element: element needs to extend SettingsElement");
			throw ::MSU.Exception.InvalidType(_element);
		}
		_element.setPage(this);
		this.Settings[_element.getID()] <- _element;
		return _element;
	}

	function addDivider( _id )
	{
		return this.addElement(::MSU.Class.SettingsDivider(_id));
	}

	function addTitle( _id, _name, _description = null )
	{
		return this.addElement(::MSU.Class.SettingsTitle(_id, _name, _description));
	}

	function addSpacer( _id, _width, _height )
	{
		return this.addElement(::MSU.Class.SettingsSpacer(_id, _width, _height));
	}

	function addBooleanSetting( _id, _value, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.BooleanSetting(_id, _value, _name, _description));
	}

	function addButtonSetting( _id, _value, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.ButtonSetting(_id, _value, _name, _description));
	}

	function addEnumSetting( _id, _value, _array, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.EnumSetting(_id, _value, _array, _name, _description));
	}

	function addRangeSetting( _id, _value, _min, _max, _step, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.RangeSetting(_id, _value, _min, _max, _step, _name, _description));
	}

	function addStringSetting( _id, _value, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.StringSetting(_id, _value, _name, _description));
	}

	function addColorPickerSetting( _id, _value, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.ColorPickerSetting(_id, _value, _name, _description));
	}

	function addArraySetting( _id, _value, _name = null, _description = null )
	{
		return this.addElement(::MSU.Class.ArraySetting(_id, _value, _name, _description));
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

	function getUIData( _flags = [] )
	{
		local ret = {
			name = this.getName(),
			id = this.getID(),
			settings = [],
			hidden = !this.verifyFlags(_flags)
		};

		foreach (setting in this.Settings)
		{
			ret.settings.push(setting.getUIData(_flags));
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
