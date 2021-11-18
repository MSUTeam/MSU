this.mod_settings_manager <- {
	m = {
		Pages = null,
		Locked = false
	},

	function create()
	{
		this.m.Pages = this.MSU.OrderedMap();
	}
	
	function add( _page )
	{
		if (this.m.Locked)
		{
			this.logError("Settings Manager is Locked, no more settings can be added");
		}
		else
		{
			if (!(_page instanceof this.MSU.SettingsPage))
			{
				throw this.Exception.InvalidTypeException;
			}
			this.m.Pages[_page.getModID()] <- _page;
		}
	}

	function get( _modID )
	{
		return this.m.Pages[_modID];
	}

	function finalize()
	{
		this.m.Locked = true;
		this.m.Pages.sort(this.sortPagesByName);
	}

	function updateSettings( _data )
	{
		/*
		_data = {
			modID = {
				settingID = value
			}
		}
		*/

		foreach (modID, page in _data)
		{
			foreach (setting, value in page)
			{
				this.m.Pages[modID].get(setting).set(value);
			}
		}
	}

	function doPagesFunction(_function, ...)
	{
		vargv.insert(0, null);

		foreach (page in this.m.Pages)
		{
			vargv[0] = page;
			page[_function].acall(vargv);
		}
	}

	function flagSerialize()
	{
		this.doPagesFunction("flagSerialize");
	}

	function resetFlags()
	{
		this.doPagesFunction("resetFlags");
	}

	function flagDeserialize()
	{
		this.doPagesFunction("flagDeserialize");	
	}

	function getUIData()
	{
		local ret = [];
		foreach (page in this.m.Pages)
		{
			ret.push(page.getUIData());
		}
		ret.reverse() //No idea why conversion to JS reverses the array, but it does so I am pre-empting this.
		return ret;
	}
	
	function sortPagesByName( _page1, _page2 )
	{
		return _page1.getName() <=> _page2.getName();
	}
}