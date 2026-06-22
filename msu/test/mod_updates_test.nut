// a number of test cases for modinfos 
local function __addDebugModVersions(_modInfos)
{
	_modInfos["A"] <- {
		UpdateInfo = {
			name = "Test_A_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "PATCH",
			changes = @"# H1
			## H2
			### H3
			#### H4
			##### H5",
			sources = {},
			isNew = true
	}};
	_modInfos["B"] <- {
		UpdateInfo = {
			name = "Test_B",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MAJOR",
			changes = "",
			sources = {},
			isNew = false
	}};
	_modInfos["C"] <- {
		UpdateInfo = {
			name = "Test_C_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = "",
			sources = {},
			isNew = true
	}};
	_modInfos["D"] <- {
		UpdateInfo = {
			name = "Test_D",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = "",
			sources = {},
			isNew = false
	}};
	_modInfos["E"] <- {
		UpdateInfo = {
			name = "Test_E_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = "",
			sources = {},
			isNew = true
	}};
	_modInfos["F"] <- {
		UpdateInfo = {
			name = "Test_F_Inline_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = @"This has **bold** and __also bold__ text.
			This has *italic* and _also italic_ text.
			This has ~~strikethrough~~ and `inline code` too.
			Mixed: **bold with *nested italic* inside**.",
			sources = {},
			isNew = true
	}};
	_modInfos["G"] <- {
		UpdateInfo = {
			name = "Test_G_Lists",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = @"Unordered list:
			- first item
			* second item (star bullet)
			+ third item (plus bullet)
			Ordered list:
			1. step one
			2. step two
			3. step three with **bold**",
			sources = {},
			isNew = false
	}};
	_modInfos["H"] <- {
		UpdateInfo = {
			name = "Test_H_Rules_Quotes_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = @"Text before the rule.
			---
			Text after a dash rule.
			***
			Text after a star rule.
			> This is a blockquote.
			> A second quoted line with a [link](https://example.com).",
			sources = {},
			isNew = true
	}};
	_modInfos["I"] <- {
		UpdateInfo = {
			name = "Test_I_Mixed",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = @"# Patch 1.2.2
			Fixed a bug in the **combat** system.
			## Changes
			- Reworked _morale_ checks
			- Added `MSU.Mod` hooks
			1. Migrate config
			2. Restart the game
			See [the docs](https://example.com/docs) for details.",
			sources = {},
			isNew = false
	}};
	_modInfos["J"] <- {
		UpdateInfo = {
			name = "Test_J_Edge_NEW",
			currentVersion = "1.2.3",
			availableVersion = "1.2.2",
			updateType = "MINOR",
			changes = @"###### H6 heading
			####### Seven hashes should cap at H6
			#NoSpaceAfterHash
			Identifier test: some_var_name and another_long_name
			Version mention 1.5x should not become a list item.",
			sources = {},
			isNew = true
	}};
}

local infos = {};
__addDebugModVersions(infos);
::MSU.UI.JSConnection.m.JSHandle.asyncCall("showModUpdates", infos);
