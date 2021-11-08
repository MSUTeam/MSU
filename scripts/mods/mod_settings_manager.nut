this.mod_settings_manager <- {
	m = {
		Pages = {}
	},
	
	function addPage( _page )
	{
		this.m.Pages[_page.ModID] = _page;
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

		foreach (modID, page in data)
		{
			foreach (setting, value in page)
			{
				this.m.Pages[modID].get(setting).set(value);
			}
		}
	}

	function getUIData()
	{
		local ret = [];
		foreach (page in Pages)
		{
			ret[page.getModID()] <- page.getPageForUI();
		}
		return ret;
	}
}