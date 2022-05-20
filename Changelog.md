# Modding Standards & Utilities (MSU)
Changelog

## 1.0.4
- Added a requirement in the MSU mod_hooks queue for vanilla version 1.5 or later.
- The IsPreviewing boolean of skill_container is now set to false in onCombatFinished as well to avoid any cases where it might remain true due to some skills bugging out during combat.
- Fixed a typo in a function call in the AlreadyInState exception.
- Removed some leftover logging.
- Fixed an issue in exceptions when the passed parameter is a tile object.
