# Modding Standards & Utilities (MSU)
Changelog

## 1.1.0
- add Tooltip system to simplify adding tooltips to UI objects
- add Timer functions to benchmark code
- add: helpful log errors to type checking functions
- add onShow and onHide to ui_screen base class (JS)
- add addAIBehaviour function
- add dummy functions to get movement speed mult instead of checking for the presence of the function
- add simple state management functions
- simplify Movement Speed hook to no longer overwrite onUpdate() of party
- fix: quick hands incorrectly applying to shield item swaps
- fix: issue with Movement Speed module causing crashes
- fix: SemVer compare functions not accepting mod objects
- fix: MSU being unable to handle incompatibilities with specific versions
- fix: error during getActionCost function
- fix: new mods for save not getting printed to log
- fix: add getclass function to OrderedMap and WeightedContainer

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
