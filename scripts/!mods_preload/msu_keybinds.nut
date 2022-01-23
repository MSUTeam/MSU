local gt = this.getroottable();

gt.MSU.setupCustomKeybinds <- function() {
	::mods_registerJS("msu_keybinds.js")
	gt.MSU.CustomKeybinds <- {
		CustomBindsJS = {},
		CustomBindsSQ = {},
		set = function(_actionID, _key, _inSQ = true, _override = false){
			::printWarning("Setting key " + _key + " for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS
			if (_actionID in environment && !_override){
				this.logError(format("Trying to bind key %s to action %s but is already bound and override not specified!"));
				return
			}
			environment[_actionID] <- _key
			
		},
		get = function(_actionID, _defaultKey, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS
			::printWarning("Getting key for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			if (_actionID in environment){
				::printWarning("Returning key " + this.CustomBinds[_actionID] + " for ID " + _actionID, this.MSU.MSUModName, "keybinds")
				return environment[_actionID]
			}
			::printWarning("Returning default key " + _defaultKey + " for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			return _defaultKey
		}
		remove = function(_actionID, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS
			::printWarning("Removing  keybinds for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			environment.rawdelete(_actionID)
		},
	}

	local customKeybindsArray = this.IO.enumerateFiles("mod_config/keybinds/"); //returns either null if not valid path or no files, otherwise array with strings
	if (customKeybindsArray == null) return
	foreach (filename in customKeybindsArray){
		this.include(filename);
	}
	
	gt.MSU.CustomKeybinds.set("testKeybind", 51, false)
}
