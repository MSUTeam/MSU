::MSU.Class.ModSettingsSystem <- class extends ::MSU.Class.System
{
	Panels = null;
	Locked = null;
	Screen = null; //settings_screen

	constructor()
	{
		base.constructor(::MSU.SystemID.ModSettings);
		this.Locked = false;
		this.Panels = ::MSU.Class.OrderedMap();
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);

		_mod.ModSettings = ::MSU.Class.ModSettingsModAddon(_mod);
		local panel = ::MSU.Class.SettingsPanel(_mod.getID(), _mod.getName());
		panel.setMod(_mod);
		this.Panels[_mod.getID()] <- panel;
	}

	function addPanel( _modPanel )
	{
		if (this.Locked)
		{
			::logError("Settings Manager is Locked, no more settings can be added");
		}
		else
		{
			if (!(_modPanel instanceof ::MSU.Class.SettingsPanel))
			{
				throw ::MSU.Exception.InvalidType(_modPanel);
			}
			this.Panels[_modPanel.getID()] <- _modPanel;
		}
	}

	function getPanel( _id )
	{
		return this.Panels[_id];
	}

	function getPanels()
	{
		return this.Panels;
	}

	function hasPanel( _id )
	{
		return this.Panels.contains(_id);
	}

	function finalize()
	{
		this.Locked = true;
		this.Panels.sort(this.sortPanelsByName);
		local idx = 0;
		foreach (panel in this.Panels)
		{
			panel.Order = idx;
			idx++
		}
	}

	function updateSettings( _data, _informChange = true )
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
				local setting = this.Panels[modID].getSetting(settingID);
				setting.set(value);
			}
		}
	}

	function onSettingPressed( _data )
	{
		local setting = this.Panels[_data.modID].getSetting(_data.settingID);
		setting.onPressedCallback();
	}

	function setSettingFromPersistence( _modID, _settingID, _value )
	{
		if (!this.Panels.contains(_modID))
		{
			::MSU.Mod.Debug.printWarning(format("The mod %s has been removed", _modID), "debug");
			return;
		}
		if (!this.getPanel(_modID).hasSetting(_settingID))
		{
			::MSU.Mod.Debug.printWarning(format("Mod %s no longer has the setting %s", _modID, _settingID), "debug");
			return;
		}
		::getModSetting(_modID, _settingID).set(_value, true, false, true);
	}

	function updateSettingFromJS( _data )
	{
		::getModSetting(_data.mod, _data.id).set(_data.value, false);
	}

	function updateSettingInJS( _modID, _settingID, _value )
	{
		this.Screen.updateSettingInJS( _modID, _settingID, _value );
	}

	function callPanelsFunction( _function, ... )
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
		::MSU.System.PersistentData.loadFileForEveryMod("ModSetting");
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
		local ret = {};
		foreach (panel in this.getPanels())
		{
			ret[panel.getID()] <- panel.getUIData(_flags);
		}
		return ret;
	}

	function isVisibleWithFlags( _flags )
	{
		foreach (panel in this.getPanels())
		{
			if (panel.verifyFlags(_flags)) return true;
		}
		return false;
	}

	function sortPanelsByName( _key1, _mod1, _key2, _mod2 )
	{
		return _mod1.getName() <=> _mod2.getName();
	}
}
