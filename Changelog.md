# Modding Standards & Utilities (MSU)
Changelog

## 1.0.5
- Fixed the getMod function throwing exception even when the mod ID existed.
- Fixed MSU exceptions not adding a space before quotation marks.
- Fixed error message when trying to get a non-registered mod to say that you should create a mod object rather than register it.

## 1.0.4
- Added a requirement in the MSU mod_hooks queue for vanilla version 1.5 or later.
- The IsPreviewing boolean of skill_container is now set to false in onCombatFinished as well to avoid any cases where it might remain true due to some skills bugging out during combat.
- Fixed a typo in a function call in the AlreadyInState exception.
- Removed some leftover logging.
- Fixed an issue in exceptions when the passed parameter is a tile object.
