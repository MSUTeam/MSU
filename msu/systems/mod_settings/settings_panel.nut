::MSU.Class.SettingsPanel <- class
{
	Pages = null;
	ID = null;
	Name = null;

	constructor( _id, _name = null )
	{
		this.ID = _id;
		this.Name = _name == null ? _id : _name;
		this.Pages = ::MSU.Class.OrderedMap();
	}

	function getPages()
	{
		return this.Pages;
	}

	function addPage( _page )
	{
		if (!(_page instanceof ::MSU.Class.SettingsPage))
		{
			throw ::MSU.Exception.InvalidType(_page);
		}
		_page.setParent(this);
		this.Pages[_page.getID()] <- _page;
	}

	function getSetting( _settingID )
	{
		foreach (page in this.Pages)
		{
			if (page.getSettings().contains(_settingID))
			{
				return page.get(_settingID);
			}
		}

		throw ::MSU.Exception.KeyNotFound(_settingID);
	}

	function hasSetting( _settingID )
	{
		foreach (page in this.Pages)
		{
			if (page.getSettings().contains(_settingID))
			{
				return true;
			}
		}

		return false;
	}

	function hasPage( _pageID )
	{
		return this.getPages().contains(_pageID);
	}

	function getPage( _pageID )
	{
		return this.Pages[_pageID];
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

	function callSettingsFunction( _function, ... )
	{
		vargv.insert(0, null);
		foreach (page in this.Pages)
		{
			foreach (setting in page.getSettings())
			{
				if (setting instanceof ::MSU.Class.AbstractSetting)
				{
					vargv[0] = setting;
					setting[_function].acall(vargv);
				}
			}
		}
	}

	function flagSerialize()
	{
		this.callSettingsFunction("flagSerialize", this.getID());
	}

	function flagDeserialize()
	{
		this.callSettingsFunction("flagDeserialize", this.getID());
	}

	function resetFlags()
	{
		this.callSettingsFunction("resetFlags", this.getID());
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

	function getLogicalData()
	{
		local ret = {};
		foreach (page in this.getPages())
		{
			foreach (setting in page.getSettings())
			{
				if (setting instanceof ::MSU.Class.AbstractSetting)
				{
					ret[setting.getID()] <- setting.getValue();
				}
			}
		}
		return ret;
	}
}
