::MSU.Key <- {
	Environment = {
		SQ = 0,
		JS = 1
	},
	State = {
		World = 1,
		Tactical = 2,
		MainMenu = 4,
		All = 1 + 2 + 4
	},
	Input = {
		Keyboard = 0,
		Mouse = 1
	},
	KeyState = {
		Press = 1,
		Release = 2,
		Continuous = 4
	},

	function sortKeyString( _key )
	{
		local key = "";
		local keyArray = split(_key, "+");
		local mainKey = keyArray.pop();
		if (keyArray.len() > 1)
		{
			keyArray.sort();
			key = keyArray.reduce(@(_a, _b) _a + "+" + _b) + "+";
		}
		else if (keyArray.len() == 1)
		{
			key = keyArray[0] + "+";
		}

		key += mainKey;
		return key;
	}

	function sortKeyCombinationsString( _keyCombinations )
	{
		if (_keyCombinations == "") return "";
		local array = split(_keyCombinations, "/");
		array.apply(this.sortKeyString);
		return array.reduce(@(_a, _b) _a + "/" + _b);
	}

	function getKeyState( _rawKeyState )
	{
		switch (_rawKeyState)
		{
			case 0:
				return this.KeyState.Release;
			case 1:
				return this.KeyState.Press;
		}
	}

	function isKnownKey( _key )
	{
		return _key.getKey().tostring() in this.KeyMapSQ;
	}

	function isKnownMouse( _mouse )
	{
		return _mouse.getID().tostring() in this.MouseMapSQ;
	}

	// id 7 is scroll wheel, with state 3 being scroll up and 4 being scroll down
	// id 6 is any mouse movement
	MouseMapSQ = {
		"1" : "leftclick",
		"2" : "rightclick",
		// "3" : "middleclick", these are detected by squirrel, but not by JS, which means our current system can't handle setting these keybinds
		// "4" : "sidebackward",
		// "5" : "sideforward"
	},
	KeyMapSQ = {
		"1" : "1",
		"2" : "2",
		"3" : "3",
		"4" : "4",
		"5" : "5",
		"6" : "6",
		"7" : "7",
		"8" : "8",
		"9" : "9",
		"10" : "0",
		"11" : "a",
		"12" : "b",
		"13" : "c",
		"14" : "d",
		"15" : "e",
		"16" : "f",
		"17" : "g",
		"18" : "h",
		"19" : "i",
		"20" : "j",
		"21" : "k",
		"22" : "l",
		"23" : "m",
		"24" : "n",
		"25" : "o",
		"26" : "p",
		"27" : "q",
		"28" : "r",
		"29" : "s",
		"30" : "t",
		"31" : "u",
		"32" : "v",
		"33" : "w",
		"34" : "x",
		"35" : "y",
		"36" : "z",
		"37" : "backspace",
		"38" : "tab",
		"39" : "enter",
		"40" : "space",
		"41" : "escape",
		"44" : "end",
		"45" : "home",
		"46" : "pagedown",
		"47" : "pageup",
		"48" : "left",
		"49" : "up",
		"50" : "right",
		"51" : "down",
		"53" : "insert",
		"54" : "delete",
		"55" : "n0",
		"56" : "n1",
		"57" : "n2",
		"58" : "n3",
		"59" : "n4",
		"60" : "n5",
		"61" : "n6",
		"62" : "n7",
		"63" : "n8",
		"64" : "n9",
/*
		While technically present, these keys are unreliable
		"66" : "*",
		"67" : "+",
		"68" : "-",
		"70" : "/",
*/
		"71" : "f1",
		"72" : "f2",
		"73" : "f3",
		"74" : "f4",
		"75" : "f5",
		"76" : "f6",
		"77" : "f7",
		"78" : "f8",
		"79" : "f9",
		"80" : "f10",
		"81" : "f11",
		"82" : "f12",
		"83" : "f13",
		"84" : "f14",
		"85" : "f15",
		"86" : "f16",
		"87" : "f17",
		"88" : "f18",
		"89" : "f19",
		"90" : "f20",
		"91" : "f21",
		"92" : "f22",
		"93" : "f23",
		"94" : "f24",
		"95" : "ctrl",
		"96" : "shift",
		"97" : "alt"
	}
};
