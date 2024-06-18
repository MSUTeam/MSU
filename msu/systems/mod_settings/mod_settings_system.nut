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

	function getAllElementsAsArray( _filter = null )
	{
		local ret = [];
		foreach (panel in this.getPanels())
		{
			ret.extend(panel.getAllElementsAsArray(_filter));
		}
		return ret;
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

	function updateSettingsFromJS( _data )
	{
		/*
		_data = {
			modID = {
				settingID =
				{
					type,
					value
				}
			}
		}
		*/
		local persistentData = ::MSU.Mod.PersistentData.hasFile("ModSettings") ? ::MSU.Mod.PersistentData.readFile("ModSettings") : {};
		foreach (modID, panel in _data)
		{
			if (!(modID in persistentData)
				persistentData[modID] <- {};

			foreach (settingID, data in panel)
			{
				this.updateSettingFromJS({
					mod = modID,
					id = settingID,
					type = data.type,
					value = data.value
				});

				if (::getModSetting(modID, settingID).getPersistence())
					persistentData[modID][settingID] <- data.value;
			}
		}

		::MSU.Mod.PersistentData.createFile("ModSettings", persistentData);
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
		if (_data.type == "float") _data.value = _data.value.tofloat();
		::getModSetting(_data.mod, _data.id).set(_data.value, true, false);
	}

	function updateSettingInJS( _modID, _settingID, _value )
	{
		this.Screen.updateSettingInJS( _modID, _settingID, _value );
	}

	function callPanelsFunction( _function, _argsArray )
	{
		_argsArray.insert(0, null);

		foreach (panel in this.Panels)
		{
			_argsArray[0] = panel;
			panel[_function].acall(_argsArray);
		}
	}

	function exportSettingToPersistentData( _setting )
	{
		local data;
		if (::MSU.Mod.PersistentData.hasFile("ModSettings"))
		{
			data = ::MSU.Mod.PersistentData.readFile("ModSettings");
			local modID = _setting.getMod().getID();
			if (!(modID in data))
				data[modID] <- {};

			data[modID][_setting.getID] <- _setting.getValue();
		}
		else
		{
			data = {
				[_setting.getMod().getID()] = {
					[_setting.getID()] = _setting.getValue()
				}
			};
		}

		::MSU.Mod.PersistentData.createFile("ModSettings", data);
	}

	function exportPersistentSettings()
	{
		local persistentData = {};
		foreach (modID, panel in this.Panels)
		{
			local panelData = {};
			persistentData[modID] <- panelData;

			foreach (page in panel.getPages())
			{
				foreach (setting in page.getSettings())
				{
					if (setting instanceof ::MSU.Class.AbstractSetting && setting.getPersistence())
					{
						panelData[setting.getID()] <- setting.getValue();
					}
				}
			}
		}
		::MSU.Mod.PersistentData.createFile("ModSettings", persistentData);
	}

	function importPersistentSettings()
	{
		if (::MSU.System.Serialization.SerializationMetaData.isSavedVersionAtLeast("1.3.0-rc5"))
		{
			if (!::MSU.Mod.PersistentData.hasFile("ModSettings"))
				return;

			foreach (modID, data in ::MSU.Mod.PersistentData.readFile("ModSettings"))
			{
				if (!(modID in this.Panels))
					continue;

				local panel = this.Panels[modID];

				foreach (settingID, value in data)
				{
					if (panel.hasSetting(settingID))
					{
						panel.getSetting(settingID).set(value, true, false);
					}
				}
			}
		}
		// Legacy support for deprecated BBParser
		else
		{
			::MSU.System.PersistentData.loadFileforEveryMod("ModSetting");
		}
	}

	function flagSerialize( _out )
	{
		this.callPanelsFunction("flagSerialize", [_out]);
	}

	function flagDeserialize( _in )
	{
		this.callPanelsFunction("flagDeserialize", [_in]);
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
