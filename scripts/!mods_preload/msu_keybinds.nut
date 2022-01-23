local gt = this.getroottable();

gt.MSU.setupCustomKeybinds <- function() {
	::mods_registerJS("msu_keybinds.js")
	gt.MSU.CustomKeybinds <- {
		KeyMapSQ = {
            "1" : 1,
            "2" : 2,
            "3" : 3,
            "4" : 4,
            "5" : 5,
            "6" : 6,
            "7" : 7,
            "8" : 8,
            "9" : 9,
            "0" : 10,
            "a" : 11,
            "b" : 12,
            "c" : 13,
            "d" : 14,
            "e" : 15,
            "f" : 16,
            "g" : 17,
            "h" : 18,
            "i" : 19,
            "j" : 20,
            "k" : 21,
            "l" : 22,
            "m" : 23,
            "n" : 24,
            "o" : 25,
            "p" : 26,
            "q" : 27,
            "r" : 28,
            "s" : 29,
            "t" : 30,
            "u" : 31,
            "v" : 32,
            "w" : 33,
            "x" : 34,
            "y" : 35,
            "z" : 36,
            "backspace" : 37,
            "tab" : 38,
            "enter" : 39,
            "space" : 40,
            "escape" : 41,
            "end" : 44,
            "home" : 45,
            "pagedown" : 46,
            "pageup" : 47,
            "left" : 48,
            "up" : 49,
            "right" : 50,
            "down" : 51,
            "insert" : 53,
            "delete" : 54,
            "n0" : 55,
            "n1" : 56,
            "n2" : 57,
            "n3" : 58,
            "n4" : 59,
            "n5" : 60,
            "n6" : 61,
            "n7" : 62,
            "n8" : 63,
            "n9" : 64,
            "*" : 66,
            "+" : 67,
            "-" : 68,
            "/" : 70,
            "f1" : 71,
            "f2" : 72,
            "f3" : 73,
            "f4" : 74,
            "f5" : 75,
            "f6" : 76,
            "f7" : 77,
            "f8" : 78,
            "f9" : 79,
            "f10" : 80,
            "f11" : 81,
            "f12" : 82,
            "f13" : 83,
            "f14" : 84,
            "f15" : 85,
            "f16" : 86,
            "f17" : 87,
            "f18" : 88,
            "f19" : 89,
            "f20" : 90,
            "f21" : 91,
            "f22" : 92,
            "f23" : 93,
            "f24" : 94,
            "ctrl" : 95,
            "shift" : 96,
            "alt" : 97,
        },
        KeyMapJS = {
            "backspace" : 8,
            "tabulator" : 9,
            "return" : 13,
            "shift" : 16,
            "ctrl" : 17,
            "alt" : 18,
            "pause" : 19,
            "capslock" : 20,
            "escape" : 27,
            "space" : 32,
            "pageup" : 33,
            "pagedown" : 34,
            "end" : 35,
            "home" : 36,
            "left" : 37,
            "up" : 38,
            "right" : 39,
            "down" : 40,
            "insert" :  45,
            "delete" : 46,
            "0" : 48,
            "1" : 49,
            "2" : 50,
            "3" : 51,
            "4" : 52,
            "5" : 53,
            "6" : 54,
            "7" : 55,
            "8" : 56,
            "9" : 57,
            "a" : 65,
            "b" : 66,
            "c" : 67,
            "d" : 68,
            "e" : 69,
            "f" : 70,
            "g" : 71,
            "h" : 72,
            "i" : 73,
            "j" : 74,
            "k" : 75,
            "l" : 76,
            "m" : 77,
            "n" : 78,
            "o" : 79,
            "p" : 80,
            "q" : 81,
            "r" : 82,
            "s" : 83,
            "t" : 84,
            "u" : 85,
            "v" : 86,
            "w" : 87,
            "x" : 88,
            "y" : 89,
            "z" : 90,
            "leftwindowkey" : 91,
            "rightwindowkey" : 92,
            "selectkey" : 93,
            "n0" : 96,
            "n1" : 97,
            "n2" : 98,
            "n3" : 99,
            "n4" : 100,
            "n5" : 101,
            "n6" : 102,
            "n7" : 103,
            "n8" : 104,
            "n9" : 105,
            "*" : 106,
            "+" : 107,
            "-" : 109,
            "???" : 110,
            "/" : 111,
            "f1" : 112,
            "f2" :  113,
            "f3" :  114,
            "f4" :  115,
            "f5" :  116,
            "f6" :  117,
            "f7" :  118,
            "f8" :  119,
            "f9" :  120,
            "f10" : 121,
            "f11" : 122,
            "f12" : 123,
            "f13" : 124,
            "f14" : 125,
            "f15" : 126,
            "f16" : 127,
            "f17" : 128,
            "f18" : 129,
            "f19" : 130,
            "f20" : 131,
            "f21" : 132,
            "f22" : 133,
            "f23" : 134,
            "f24" : 135,
            "numlock" : 144,
            "scrolllock" : 145,
            "semicolon" : 186,
            "equalsign" : 187,
            "," : 188,
            "-" : 189,
            "." : 190,
            "/" : 191,
            "`" : 192,
            "[" : 219,
            "\\" : 220,
            "]" : 221,
            "'" : 222
        },
		ReverseKeyMapJS = {},
		ReverseKeyMapSQ = {},
		CustomBindsJS = {}, //JS and SQ use different binds
		CustomBindsSQ = {},
		set = function(_actionID, _key, _inSQ = true, _override = false){
			
			if ((typeof _actionID != "string") || (typeof _key != "string")){
				this.logError(format("Trying to bind key " + _key + " to action " + _actionID + " but either is not a string!"));
			}
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			local keyMap = _inSQ ? this.KeyMapSQ : this.KeyMapJS;
			if (_actionID in environment && !_override){
				this.logError(format("Trying to bind key %s to action %s but is already bound and override not specified!", _key, _actionID));
				return
			}
			if (!_key in keyMap){
				this.logError(format("Trying to bind key %s to action %s but key is not found in keymap!", _key, _actionID));
				return
			}
			::printWarning(format("Setting key %s (internal value %i ) for ID %s.", _key, keyMap[_key], _actionID), this.MSU.MSUModName, "keybinds");
			if(_override){
				::printWarning("Override specified", this.MSU.MSUModName, "keybinds");
			}
			environment[_actionID] <- keyMap[_key];
			
		},
		get = function(_actionID, _defaultKey, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			local keyMap = _inSQ ? this.KeyMapSQ : this.KeyMapJS;
			local reverseKeyMap = _inSQ ? this.ReverseKeyMapSQ : this.ReverseKeyMapJS;
			::printWarning("Getting key for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			if (_actionID in environment){
				::printWarning(format("Returning key %s (internal value %i ) for ID %s.", reverseKeyMap[environment[_actionID]], environment[_actionID], _actionID), this.MSU.MSUModName, "keybinds");
				return environment[_actionID]
			}
			::printWarning(format("Returning default key %s (internal value %i ) for ID %s.", _defaultKey, keyMap[_defaultKey], _actionID), this.MSU.MSUModName, "keybinds");
			return _defaultKey
		}
		remove = function(_actionID, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			::printWarning("Removing  keybinds for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			environment.rawdelete(_actionID)
		},
	}
	foreach(key, value in gt.MSU.CustomKeybinds.KeyMapSQ){
		gt.MSU.CustomKeybinds.ReverseKeyMapSQ[value] <- key;
	}
	foreach(key, value in gt.MSU.CustomKeybinds.KeyMapJS){
		gt.MSU.CustomKeybinds.ReverseKeyMapJS[value] <- key;
	}

	local customKeybindsArray = this.IO.enumerateFiles("mod_config/keybinds/"); //returns either null if not valid path or no files, otherwise array with strings
	if (customKeybindsArray != null){
		foreach (filename in customKeybindsArray){
			this.include(filename);
		}
	}
	if (this.MSU.Debug.isEnabledForMod(this.MSU.MSUModName,"keybinds")){
		gt.MSU.CustomKeybinds.set("testKeybind", "3", false); //set new key in JS
		gt.MSU.CustomKeybinds.set("testKeybind", "f1"); //set new key in SQ
		gt.MSU.CustomKeybinds.get("testKeybind", "f2"); //get key, returns f1
		gt.MSU.CustomKeybinds.get("wrongActionID", "f2"); //get key, returns default key f2 as actionID not bound

		gt.MSU.CustomKeybinds.set("testKeybind", "f3"); //override not specified
		gt.MSU.CustomKeybinds.set("testKeybind", "f3", true, true); //override specified
	}
}
