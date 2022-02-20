local gt = this.getroottable();

local testSettingsSystem = function()
{
	for (local i = 0; i < 5; ++i)
	{
		local modPanel = this.MSU.Class.SettingsPanel("MSU" + i, "M" + i)
		local numPages = rand() % 5 + 1;
		for (local j = 0; j < numPages; ++j)
		{
			local testPage = this.MSU.Class.SettingsPage("Page" + j, "Page Name " + j);

			local test = this.MSU.Class.RangeSetting("TestRange" + j, 100, 10, 300, 10);
			local test1 = this.MSU.Class.BooleanSetting("TestBool" + j, rand() % 2 == 0, "Test Bool Taro");
			test1.addCallback(function(_data = null){
				this.logInfo("worked?")
			})
			// test1.lock()
			local test2 = this.MSU.Class.BooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
			test2.addFlags("NewCampaign", "NewCampaignOnly")
			local test3 = this.MSU.Class.EnumSetting("TestEnum" + j, ["hi", "hello", "goodbye"], "goodbye");
			test3.lock()
			local test4 = this.MSU.Class.EnumSetting("TestEnum" + j + 1, ["hi", "hello", "goodbye"]);
			local divider = this.MSU.Class.SettingsDivider("divider")

			local test5 = this.MSU.Class.EnumSetting("TestEnum" + j + 2, ["hi", "hello", "goodbye"]);

			testPage.add(test);
			testPage.add(test1);
			testPage.add(test2);
			testPage.add(test3);
			testPage.add(divider);
			testPage.add(test4);
			testPage.add(test5);

			modPanel.addPage(testPage);
		}
		this.MSU.Systems.ModSettings.add(modPanel);
	}
}

gt.MSU.setupSettingsSystem <- function()
{
	this.MSU.Class.ModSettingsSystem <- class extends this.MSU.Class.RequiredModSystem
	{
		Panels = null;
		Locked = null;

		constructor()
		{
			base.constructor(this.MSU.SystemIDs.ModSettings, [this.MSU.SystemIDs.ModRegistry]);
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
						if(_informChange && setting.ParseChange == true)
						{
							this.MSU.PersistentDataManager.writeToLog("ModSetting", "MSU",  format("%s;%s", settingID, value.tostring()))
						}
					}

					setting.set(value);
				}
			}
		}

		function doPanelsFunction(_function, ...)
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

		function onModRegistered( _mod )
		{
			if (!base.onModRegistered(_mod))
			{
				return false;
			}
			local panel = this.MSU.Class.SettingsPanel(_mod.getName());
			this.Panel[_mod.getID()] <- panel;

			return true;
		}
	}

	this.MSU.Systems.ModSettings <- this.MSU.Class.ModSettingsSystem();
	this.MSU.SettingsScreen <- this.new("scripts/ui/mods/msu_settings_screen");

	this.MSU.PersistentDataManager <- this.new("scripts/mods/msu_persistent_data_manager");

	this.MSU.UI.registerScreenToConnect(this.MSU.SettingsScreen);

	::getModSetting <- function( _modID, _settingID )
	{
		return this.MSU.Systems.ModSettings.get(_modID).get(_settingID);
	}

	this.MSU.SettingsFlags <- {
		NewCampaign = {
			required = [
				"NewCampaign"
			]
		}
		World = {
			excluded = [
				"NewCampaignOnly"
			]
		}
		Tactical = {
			excluded = [
				"NewCampaignOnly"
			]
		}
		Main = {
			excluded = [
				"NewCampaignOnly"
			]
		}
	}

	local panel = this.MSU.Class.SettingsPanel("MSU");
	local logPage = this.MSU.Class.SettingsPage("Logging");
	local logToggle = this.MSU.Class.BooleanSetting("logall", false, "Enable all mod logging");
	logToggle.addCallback(function(_data){
		this.MSU.Debug.FullDebug = _data;
	})
	this.MSU.Systems.ModSettings.add(panel);
	panel.addPage(logPage);
	logPage.add(logToggle);

	// this.MSU.Systems.ModSettings.addSetting("MSU", "Logging", "Boolean", "logall", false, "Enable all mod logging", function(_data){
	// 	this.MSU.Debug.FullDebug = _data;
	// }))

	local verboseModeToggle = this.MSU.Class.BooleanSetting("verbose", false, "Enable VerboseMode");
	verboseModeToggle.addCallback(function(_data){
		this.Const.AI.VerboseMode = _data
	})
	logPage.add(verboseModeToggle);

	this.MSU.Systems.ModSettings.importPersistentSettings()


	//this neeeds to be moved into a hook
	this.MSU.PersistentDataManager.loadSettingForEveryMod("Keybind")
	this.MSU.CustomKeybinds.parseForUI();


	// Testing Code
	testSettingsSystem();
}
