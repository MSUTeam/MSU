this.MSU.Class.ModSettingsSystem <- class extends this.MSU.Class.System
{
	Panels = null;
	Locked = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.ModSettings);
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

	function getPanels()
	{
		return this.Panels;
	}

	function has( _id )
	{
		return this.Panels.contains(_id)
	}

	function finalize()
	{
		this.Locked = true;
		this.Panels.sort(this.sortPanelsByName);
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
				setting.set(value);
			}
		}
	}

	function setSettingFromPersistence( _modID, _settingID, _value )
	{
		if (!this.Panels.contains(_modID))
		{
			::printWarning(format("The mod %s has been removed", _modID), ::MSU.ID, this.MSU.System.Debug.MSUMainDebugFlag);
			return;
		}
		try
		{
			this.get(_modID).getSetting(_settingID).set(_value, true, false);
		}
		catch (error)
		{
			if (error == this.Exception.KeyNotFound)
			{
				::printWarning(format("Mod %s no longer has the setting %s", _modID, _settingID), ::MSU.ID, this.MSU.System.Debug.MSUMainDebugFlag);
				return;
			}
			throw error;
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

	function getLogicalData()
	{
		local ret = {};
		foreach (panel in this.getPanels())
		{
			ret[panel.getID()] <- panel.getLogicalData();
		}
		return ret;
	}

	function sortPanelsByName( _key1, _mod1, _key2, _mod2 )
	{
		return _mod1.getName() <=> _mod2.getName();
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod)

		_mod.ModSettings = ::MSU.Class.ModSettingsModAddon(_mod);
		local panel = this.MSU.Class.SettingsPanel(_mod.getID(), _mod.getName());
		this.Panels[_mod.getID()] <- panel;
	}
}
