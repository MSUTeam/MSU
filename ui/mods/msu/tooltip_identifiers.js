MSU.TooltipIdentifiers = {
	SettingsIdentifier : "msu-settings",
	GeneralIdentifier : "msu-general",
	ModSettings : {
		Main : {
			Cancel : "",
			OK : ""
		},
		Keybind : {
			Popup : {
				Cancel : "",
				Add : "",
				OK : "",
				Modify : "",
				Delete : "",
			}
		}
	}
}

var keyCache = [MSU.TooltipIdentifiers.GeneralIdentifier];
var curObj = null;
var idx = 0;
var recursiveTravel = function(_key, _value)
{
	keyCache.push(_key);
	if (typeof _value == "object")
	{
		idx = 0;
   		curObj = _value;
		return MSU.iterateObject(_value, recursiveTravel);
	}
	idx++;
    if (_value != "")
    {
        keyCache.pop();
  	    return false;
    }
    keyCache.forEach(function(_cachedKey){
        _value += _cachedKey + ".";
    })
    curObj[_key] = _value.slice(0, -1);
    keyCache.pop()
    if (idx == Object.keys(curObj).length) keyCache.pop();
}

MSU.iterateObject(MSU.TooltipIdentifiers, recursiveTravel);
delete keyCache;
delete curObj;
delete idx;
delete recursiveTravel;
