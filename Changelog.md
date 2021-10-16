# Modding Standards & Utilities (MSU)
Changelog

## 0.6.15
- Skill Container will no longer update after onAnySkillExecuted when executing a movement skill e.g. Rotation.

## 0.6.14
- Added two new functions to modify tooltips: `onGetHitFactors` and `onQueryTooltip`. See documentation.
- Added `addNewItemType` function to add a new item type to the game. See documentation.
- Added Debug Log functionality inspired from TaroEld's work. See documentation.
- Temporarily disabled the hook on asset manager to check if this fixes crashes during saving a game.
- As a consequence of the above change, the onNewMorning() function will not trigger for the time being.
- Removed duplicate `onAfterDamageReceived` function.
- Removed the call to the vanilla `onAfterDamageReceived` function in the MSU `onAfterDamageReceived` hook because the vanilla only does `this.update()`.

## 0.6.13
- Fixed a bug in getDefaultRangedTooltip() causing ranged skills tooltips to not show.
- Improved the ranged tooltip for abilities without AdditionalAccuracy.

## 0.6.12
- Added onAttacked and onHit functions to skill_container and skill. These are called from the attackEntity and onScheduledTargetHit functions.
- Refactored the code of how the attackEntity function works: Broke apart the hitChance calculation into modular functions.
- The above two changes are currently disabled, pending review from Enduriel.
- Added addItemType, setItemType and removeItemType functions.
- Fixed some mistakes in Documentation about injuries.
- Removed the IsTraveling condition from skill_container update as it is unnecessary and doesn't fix what it was intended to fix.
- Disabled setDirty hook because it still seems to cause a crash. Need to discuss with @Enduriel before reenabling.
- Added functions to Math table for normal distribution.

## 0.6.11
- Fixed the String replace function not working.
- Added Math table with log2int function.
- Made it impossible for IsUpdating to be changed in an unexpected way.
- Prevent updating skills when moving to resolve crashes due to tile calls
- Re-enabled setDirty hook.
- Switch to log2int where appropriate.

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