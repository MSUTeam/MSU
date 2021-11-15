this.mod_settings_manager <- {
	m = {
		Pages = {}
	},
	
	function add( _page )
	{
		this.m.Pages[_page.ModID] <- _page;
	}

	function get( _modID )
	{
		return this.m.Pages[_modID];
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

	function getUIData()
	{
		local ret = {};
		foreach (page in this.m.Pages)
		{
			ret[page.getModID()] <- page.getUIData();
		}

		this.MSU.Log.printStackTrace(10, 20)
		return ret;
	}
}