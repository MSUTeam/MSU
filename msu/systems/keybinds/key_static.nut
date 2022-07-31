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

	function isValidCombination( _keyCombinations, _sq = true)
	{
		local mouseMap = _sq ? this.ReverseMouseMapSQ : this.ReverseMouseMapJS;
		local keyMap = _sq ? this.ReverseKeyMapSQ : this.ReverseKeyMapJS;

		foreach (combination in _keyCombinations)
		{
			local splitArray = split(combination, "+");
			foreach(entry in splitArray)
			{
				if (!(entry in mouseMap || entry in keyMap))
				{
					::logError(format("Keybind %s is not valid!", combination));
					throw ::MSU.Exception.KeyNotFound(entry);
				}
			}
		}
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
	ReverseMouseMapSQ = {
		"leftclick" : "1",
		"rightclick" : "2",
	},
	ReverseKeyMapSQ = {
		"1" : "1",
		"2" : "2",
		"3" : "3",
		"4" : "4",
		"5" : "5",
		"6" : "6",
		"7" : "7",
		"8" : "8",
		"9" : "9",
		"0" : "10",
		"a" : "11",
		"b" : "12",
		"c" : "13",
		"d" : "14",
		"e" : "15",
		"f" : "16",
		"g" : "17",
		"h" : "18",
		"i" : "19",
		"j" : "20",
		"k" : "21",
		"l" : "22",
		"m" : "23",
		"n" : "24",
		"o" : "25",
		"p" : "26",
		"q" : "27",
		"r" : "28",
		"s" : "29",
		"t" : "30",
		"u" : "31",
		"v" : "32",
		"w" : "33",
		"x" : "34",
		"y" : "35",
		"z" : "36",
		"backspace" : "37",
		"tab" : "38",
		"enter" : "39",
		"space" : "40",
		"escape" : "41",
		"end" : "44",
		"home" : "45",
		"pagedown" : "46",
		"pageup" : "47",
		"left" : "48",
		"up" : "49",
		"right" : "50",
		"down" : "51",
		"insert" : "53",
		"delete" : "54",
		"n0" : "55",
		"n1" : "56",
		"n2" : "57",
		"n3" : "58",
		"n4" : "59",
		"n5" : "60",
		"n6" : "61",
		"n7" : "62",
		"n8" : "63",
		"n9" : "64",
		"f1" : "71",
		"f2" : "72",
		"f3" : "73",
		"f4" : "74",
		"f5" : "75",
		"f6" : "76",
		"f7" : "77",
		"f8" : "78",
		"f9" : "79",
		"f10" : "80",
		"f11" : "81",
		"f12" : "82",
		"f13" : "83",
		"f14" : "84",
		"f15" : "85",
		"f16" : "86",
		"f17" : "87",
		"f18" : "88",
		"f19" : "89",
		"f20" : "90",
		"f21" : "91",
		"f22" : "92",
		"f23" : "93",
		"f24" : "94",
		"ctrl" : "95",
		"shift" : "96",
		"alt" : "97"
	}
	ReverseMouseMapJS = {
		"leftclick" : "0",
		"rightclick" : "2"
	},
	ReverseKeyMapJS = {
		"backspace" : "8",
		"tabulator" : "9",
		"return" : "13",
		"shift" : "16",
		"ctrl" : "17",
		"alt" : "18",
		"pause" : "19",
		"capslock" : "20",
		"escape" : "27",
		"space" : "32",
		"pageup" : "33",
		"pagedown" : "34",
		"end" : "35",
		"home" : "36",
		"left" : "37",
		"up" : "38",
		"right" : "39",
		"down" : "40",
		"insert" : "45",
		"delete" : "46",
		"0" : "48",
		"1" : "49",
		"2" : "50",
		"3" : "51",
		"4" : "52",
		"5" : "53",
		"6" : "54",
		"7" : "55",
		"8" : "56",
		"9" : "57",
		"a" : "65",
		"b" : "66",
		"c" : "67",
		"d" : "68",
		"e" : "69",
		"f" : "70",
		"g" : "71",
		"h" : "72",
		"i" : "73",
		"j" : "74",
		"k" : "75",
		"l" : "76",
		"m" : "77",
		"n" : "78",
		"o" : "79",
		"p" : "80",
		"q" : "81",
		"r" : "82",
		"s" : "83",
		"t" : "84",
		"u" : "85",
		"v" : "86",
		"w" : "87",
		"x" : "88",
		"y" : "89",
		"z" : "90",
		"leftwindowkey" : "91",
		"rightwindowkey" : "92",
		"selectkey" : "93",
		"n0" : "96",
		"n1" : "97",
		"n2" : "98",
		"n3" : "99",
		"n4" : "100",
		"n5" : "101",
		"n6" : "102",
		"n7" : "103",
		"n8" : "104",
		"n9" : "105" ,
		"*" : "106" ,
		"+" : "107",
		"f1" : "112",
		"f2" : "113",
		"f3" : "114",
		"f4" : "115",
		"f5" : "116",
		"f6" : "117",
		"f7" : "118",
		"f8" : "119",
		"f9" : "120",
		"f10" : "121",
		"f11" : "122",
		"f12" : "123",
		"f13" : "124",
		"f14" : "125",
		"f15" : "126",
		"f16" : "127",
		"f17" : "128",
		"f18" : "129",
		"f19" : "130",
		"f20" : "131",
		"f21" : "132",
		"f22" : "133",
		"f23" : "134",
		"f24" : "135",
		"numlock" : "144",
		"scrolllock" : "145",
		"semicolon" : "186",
		"equalsign" : "187",
		"comma" : "188",
		"dash" : "189",
		"dot" : "190",
		"forwardslash" : "191",
		"graveaccent" : "192",
		"openbracket" : "219",
		"backslash" : "220",
		"closebracket" : "221",
		"singlequote" : "222"
	}
};
