# Modding Standards & Utilities (MSU)
Documentation for v0.6.6

# Skills
## Automated Resetting
MSU provides several functions to reset the m table of a skill back to its base values:

- `softReset()`
- `hardReset()`
- `resetField( _field )`

MSU stores the base values of a skill immediately before its first onUpdate is called. This ensures that any changes made to the skill before or during adding to an actor are considered as the base state of the skill.

### `softReset()`
This function resets the following fields of the skill's `m` table:

- ActionPointCost
- FatigueCost
- FatigueCostMult
- MinRange
- MaxRange

`softReset()` is automatically called during the `update()` function of the `skill_container` before any skills' `onUpdate` or `onAfterUpdate` are called. It can also be manually called using `<skill>.softReset()`.

### `hardReset()`
This function is never automatically called, but can be manually called using `<skill>.hardReset()` to reset every value in the `m` table back to its original value.

### `resetField ( _field )`
This function can be used to reset a particular field back to its base value e.g. `<skill>.resetField(“Description”)`.

### Use Cases
This system allows changing a value in a skill’s m table in increments rather than assigning it particular values, which opens up possibilities for flexible and compatible modding. For example, now you can do:
```
function onAfterUpdate ( _properties )
{
	this.m.ActionPointCost -= 1
}
```
In the original game, doing this will cause the action point cost of the skill to continue to reduce indefinitely on every call to this function. However, with the MSU resetting system, this will ensure that the skill’s action point cost is only reduced by 1 compared to its base cost. Another mod can then hook the same function and add or subtract from the cost in further increments.

## Scheduled Changes
Skills in Battle Brothers are updated in the order of their SkillOrder. Imagine we have two skills:

- Skill A with `this.m.SkillOrder = this.Const.SkillOrder.First`
- Skill B with `this.m.SkillOrder = this.Const.SkillOrder.Any`

Whenever the skill_container runs its `update()` or `buildPropertiesForUse` (which calls the `onAnySkillUsed` function in skills) functions, the respective functions are called on the skills in the order of their `SkillOrder`. Hence, skill A will update before skill B in the above example.

If you want skill A to modify something in skill B after skill B’s update, you would have to change the order of skill A to be something later than that of skill B e.g. set skill A’s order to `this.Const.SkillOrder.Last`. Usually this is quite doable. However, there may be cases where you absolutely want skill A to be updated before skill B but still want skill A to be able to change something in skill B when skill B is updated. MSU allows you to do this via the `scheduleChange` function.

Multiple changes to the same skill can be scheduled by using the function multiple times. Scheduled changes are executed in the `onAfterUpdate` function of the target skill after its base `onAfterUpdate` function (i.e. the one defined in the skill’s own file) has run.

### Usage:
`<skill>.scheduleChange ( _field, _change, _set = false )`

`_field` is the key in the `m` table for which you want to schedule a change. `_change` is the new value. `_set` is a Boolean which, if `true`, sets the value of `_field` to `_change` and if `false` and if `_field` points to an integer or string value, adds `_change` to the value of `_field`.

#### Example:
The following code is written in skill A and will reduce the action point cost of skill B by 1 even if skill A updates before skill B:
```
function onUpdate ( _properties )
{
	skillB.scheduleChange(“ActionPointCost”, -1);
}
```

## Damage Type
MSU adds a robust and flexible `DamageType` system for skills. The purpose of this system is to allow skills to deal a variety of damage types and to streamline the injuries system. This system also eliminates the need to use `this.m.InjuriesOnBody` and `this.m.InjuriesOnHead` in skills. Only the `DamageType` needs to be defined.

Each skill now has a parameter called `this.m.DamageType` which can be set during the skill’s `create()` function. This parameter is an array which contains tables as its entries. Each table contains two keys: `Type` and `Weight`. For example:
```
this.m.DamageType = [
	{ Type = this.Const.Damage.DamageType.Cutting, Weight = 75 },
	{ Type = this.Const.Damage.DamageType.Piercing, Weight = 25 }
]
```
The above example will give this skill 75% Cutting damage and 25% Piercing damage.

When attacking a target, the skill pulls a weighted random `DamageType` from its `this.m.DamageType` array. The rolled damage type is then passed to the `_hitInfo` during `onBeforeTargetHit`. The type of injuries the skill can inflict is also determined at this point based on what type of damage it rolled, and which part of the body is going to be hit.

The skill’s rolled damage type’s `Weight` parameter is also passed to `_hitInfo`. This allows the target to access this information and receive different effects depending on how much weight of that `DamageType` the skill has.

MSU also adds the damage types of a skill to the skill’s tooltip automatically including their relative probabilities.

### Adding a new damage type
*`this.Const.Damage.addNewDamageType ( _damageType, _injuriesOnHead, _injuriesOnBody )`*

`_damageType` is a string which will become a key in the `this.Const.Damage.DamageType` table. `_injuriesOnHead` and `_injuriesOnBody` are arrays of strings where each entry is an ID of an injury skill.

###	Getting a list of injuries a damage type can inflict
*`this.Const.Damage.getInjuriesForDamageType ( _damageType )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns a table `{ Head = [], Body = [] }` where Head and Body are arrays containing IDs of the injury skills this damage type can inflict on the respective body part.

### Setting the injuries an existing damage type can inflict
*`this.Const.Damage.setInjuriesForDamageType ( _damageType, _injuriesOnHead, _injuriesOnBody )`*

`_damageType` is a string which will become a key in the `this.Const.Damage.DamageType` table. `_injuriesOnHead` and `_injuriesOnBody` are arrays of strings where each entry is an ID of an injury skill.

###	Getting a list of injuries applicable to a situation
*`this.Const.Damage.getApplicableInjuries ( _damageType, _bodyPart, _targetEntity = null )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_bodyPart` is the body part hit. `_targetEntity` is the entity being attacked which, if not null, removes the ExcludedInjuries of the `_targetEntity` from the returned array.

Returns an array which contains IDs of the injury skills that this damage type can apply in the given situation.

### Checking if a skill has a damage type
*`<skill>.hasDamageType ( _damageType, _only = false )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. If `_only` is true, then function only returns true if the skill has no other damage type.

Returns a `true` if the skill has the damage type and `false` if it doesn’t.

### Adding a damage type to a skill
*`<skill>.addDamageType ( _damageType, _weight )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_weight` is an integer.

Adds the given damage type to the skill’s `this.m.DamageType` array with the provided weight.

###	Removing a damage type from a skill
*`<skill>.removeDamageType ( _damageType )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Removes the given damage type from the skill if the skill has it.

### Getting the damage type of a skill
*`<skill>.getDamageType()`*

Returns the `this.m.DamageType` array of the skill.

### Getting the weight of a skill’s particular damage type
*`<skill>.getDamageTypeWeight ( _damageType )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns an integer which is the weight of the given damage type in the skill. Returns null if the skill does not have the given damage type.

###	Setting the weight of a skill’s particular damage type
*`<skill>.setDamageTypeWeight ( _damageType, _weight )`*

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_weight` is an integer.

Finds the given damage type in the skill’s damage types and sets its weight to the given value. Does nothing if the skill does not have the given damage type.

###	Rolling a damage type from a skill
*`<skill>.getWeightedRandomDamageType()`*

Selects a damage type from the skill based on weighted random distribution and returns it. The returned value is a slot in the `this.Const.Damage.DamageType` table. For example, this function is used by MSU in the `msu_injuries_handler_effect.nut` to roll a damage type from the skill when attacking a target.
