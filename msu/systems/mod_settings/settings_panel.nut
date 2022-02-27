this.MSU.Class.SettingsPanel <- class
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