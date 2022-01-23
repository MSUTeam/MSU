# Modding Standards & Utilities (MSU)
Changelog

## 0.6.26
- Fixed the getRemainingArmorFraction function. Also expanded it to now be able to be passed a bodyPart.

## 0.6.25
- Added `getBaseValue(_field)` function to skill to get the base value of a field in the m table from when the base values of the skill were saved.
- `onAnySkillUsed` now resets HitChanceBonus of skills before calling the functions.
- Implemented onDeathWithInfo function for skills.
- Implemented onMovementStep function for skills.
- Implemented onAfterUpdateProperties function for items.
- Implemented getSkills function in item which returns the array of this item's skills.

## 0.6.24
- Added a robust party movement speed system.
- Added hooks to party and player_party to improve movement speed handling
- Added hook to starting_scenario to to improve movement speed handling
- Added Array Utils. Currently with functions `getRandom( _array, _start = 0, _end = 0 )` and `shuffle()`.

## 0.6.23
- Removed the hooks on the AI functions of `onTurnStarted`, `onTurnResumed` and `onTurnEnd` which were being used to reset `IsExecutingSkillMove` of `skill_container` as this is no longer neceessary as the boolean is now reset within `onAnySkillExecuted`.
- Improved the formatting of the tooltip from the `getDefaultRangedTooltip` function.

## 0.6.22
- The `IsExecutingSkillMove` boolean of skill_container is now set to false at the end of the `onAnySkillExecuted` function after the `doOnFunction` has run. It is no longer set to false in `onMovementFinished`.
- Fixed the fatigue cost of skills not being properly reduced by items which have `FatigueOnSkillUse`.

## 0.6.21
- Added a hook on AI agent's `think` function, to block the evaluation when executing a move skill.
- The IsExecutingSkillMove boolean of skill_container is now reset to false at the end of the AI agent's `onTurnStarted`, `onTurnResumed` and `onTurnEnd` functions.

## 0.6.20
- Added function `isActiveEntity( _entity )` to turn_sequence_bar to conveniently check if the given entity is the current active entity.
- The `getActionPointsMax()` function of actor now returns a floored value, is at always should have.
- `onDeath` and `onPayForItemAction` functions of skill_container now call update at the end.
- Moved the hook on `addSkill` from weapon.nut to item.nut, so that any item that adds a skill with modified fatigue on skill use (e.g. named shields) will now work properly with the MSU save base values system for skills.
- Tile based hitchance modified by other skills/perks will now properly change a ranged skill's tooltip.

## 0.6.19
- Set several onXYZ functions which were set changed to not call update after doOnFunction in the 0.6.17 patch back to calling update after doOnFunction.

## 0.6.18
- Added back the IsExecutingMoveSkill boolean in skill_container.
- Fixed onAnySkillExecuted always allowing update. Now properly doesn't when using a movement skill e.g. Rotation.

## 0.6.17
- Removed the IsExecutingMoveSkill boolean from skill_container.
- Now the doOnFunction instead takes a `_update` parameter which if false will disable the update at the end of the doOnFunction.
- Added onUpdateLevel function which is called for all skills when the player character gains a level. This makes it possible for modders to add level-up effects without having to modify the player.nut `updateLevel` function.

## 0.6.16
- Re-enabled the hook on asset manager. onNewMorning() should work again now.

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