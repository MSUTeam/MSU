this.msu_settings_manager <- {
	m = {
		Panels = null,
		Locked = false
	},

	function create()
	{
		this.m.Panels = this.MSU.OrderedMap();
	}
	
	function add( _modPanel )
	{
		if (this.m.Locked)
		{
			this.logError("Settings Manager is Locked, no more settings can be added");
		}
		else
		{
			if (!(_modPanel instanceof this.MSU.SettingsPanel))
			{
				throw this.Exception.InvalidTypeException;
			}
			this.m.Panels[_modPanel.getID()] <- _modPanel;
		}
	}

	function get( _id )
	{
		return this.m.Panels[_id];
	}

	function finalize()
	{
		this.m.Locked = true;
		this.m.Panels.sort(this.sortPanelsByName);
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

		foreach (modID, panel in _data)
		{
			foreach (settingID, value in panel)
			{
				local setting = this.m.Panels[modID].get(settingID)
				if (setting.getValue() != value)
				{
					setting.onChangedCallback(value);
				}
				setting.set(value);
			}
		}
	}

	function doPanelsFunction(_function, ...)
	{
		vargv.insert(0, null);

		foreach (panel in this.m.Panels)
		{
			vargv[0] = panel;
			panel[_function].acall(vargv);
		}
	}

	function flagSerialize()
	{
		this.doPanelsFunction("flagSerialize");
	}

	function resetFlags()
	{
		this.doPanelsFunction("resetFlags");
	}

	function flagDeserialize()
	{
		this.doPanelsFunction("flagDeserialize");	
	}

	function getUIData( _flags = null )
	{
		local ret = [];
		foreach (panel in this.m.Panels)
		{
			if (panel.verifyFlags(_flags))
			{
				ret.push(panel.getUIData(_flags));
			}
		}
		ret.reverse() //No idea why conversion to JS reverses the array, but it does so I am pre-empting this.
		return ret;
	}
	
	function sortPanelsByName( _key1, _mod1, _key2, _mod2 )
	{
		return _mod1.getName() <=> _mod2.getName();
	}
}
