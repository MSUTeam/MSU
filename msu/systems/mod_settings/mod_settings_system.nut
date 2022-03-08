this.MSU.Class.ModSettingsSystem <- class extends this.MSU.Class.System
{
	Panels = null;
	Locked = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.ModSettings, [this.MSU.SystemID.ModRegistry]);
		Locked = false;
		this.Panels = this.MSU.Class.OrderedMap();
	}

	function add( _modPanel )
	{
		if (this.Locked)
		{
			this.logError("Settings Manager is Locked, no more settings can be added");
		}
		else
		{
			if (!(_modPanel instanceof this.MSU.Class.SettingsPanel))
			{
				throw this.Exception.InvalidType;
			}
			this.Panels[_modPanel.getID()] <- _modPanel;
		}
	}

	function get( _id )
	{
		return this.Panels[_id];
	}

	function has( _id )
	{
		return _id in this.Panels
	}

	function finalize()
	{
		this.Locked = true;
		this.Panels.sort(this.sortPanelsByName);
	}

	function updateSetting( _modID, _settingID, _value )
	{
		local tab = {}
		tab[_modID] <- {}
		tab[_modID][_settingID] <- _value
		this.updateSettings(tab, false)
	}


	function updateSettings( _data, _informChange = true  )
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
				local setting = this.Panels[modID].getSetting(settingID)
				if (setting.getValue() != value)
				{
					setting.onChangedCallback(value);
					if (_informChange && setting.ParseChange == true)
					{
						this.MSU.PersistentDataManager.writeToLog("ModSetting", "MSU",  format("%s;%s", settingID, value.tostring()))
					}
				}

				setting.set(value);
			}
		}
	}

	function callPanelsFunction(_function, ...)
	{
		vargv.insert(0, null);

		foreach (panel in this.Panels)
		{
			vargv[0] = panel;
			panel[_function].acall(vargv);
		}
	}

	function importPersistentSettings()
	{
		this.MSU.PersistentDataManager.loadSettingForEveryMod("ModSetting")
	}

	function flagSerialize()
	{
		this.callPanelsFunction("flagSerialize");
	}

	function resetFlags()
	{
		this.callPanelsFunction("resetFlags");
	}

	function flagDeserialize()
	{
		this.callPanelsFunction("flagDeserialize");
	}

	function getUIData( _flags = null )
	{
		local ret = [];
		foreach (panel in this.Panels)
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

	function registerMod( _modID )
	{
		base.registerMod(_modID)
		local mod = this.MSU.Mods[_modID];
		local panel = this.MSU.Class.SettingsPanel(mod.getID(), mod.getName());
		this.Panels[mod.getID()] <- panel;
	}
}
