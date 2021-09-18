# Modding Standards & Utilities (MSU)
Changelog

## 0.6.10
- Fixed a wrong variable name causing getDamageTypeName to not working properly.

## 0.6.9
- Temporarily switched from log-based to bitwise indexing system for getWeaponTypeName and getDamageTypeName

## 0.6.8
- Added automatic positive and negative hitchance tooltip for ranged skills
- Disabled the hook on setDirty for now.
- Fixed onNewMorning() being called on every asset manager update.

## 0.6.7
- Fixed wrong function name causing a crash when hitting a target.
- Removed the .docx version of the documentation.

## 0.6.6
- Added MSU-Documentation.md.
- The `<skill>.onAnySkillExecuted` and `<skill>.onBeforeAnySkillExecuted` functions now have a third argument: `_targetEntity`.
- The `_set` parameter in `<skill>.scheduleChange` now defaults to false.
- Added `getDamageTypeProbability` function to skill.
- Added `getDamageTypeName` function to `this.Const.Damage`.
- The `getInjuriesForDamageType` function in `this.Const.Damage` is renamed to `getDamageTypeInjuries`.
- Added function `setDamageTypeInjuries` in `this.Const.Damage`.
- The `this.Const.Damage.addNewDamageType` function now takes an optional `_damageTypeName` parameter, which can be used to alter the damage type's name in tooltips.
- HitInfo now contains DamageTypeProbabilty.
- Added some error logging to various functions to check for bad input.