# Modding Standards & Utilities (MSU)
Documentation for v0.6.27

This documentation follows a **Traffic Light** system:
- Green 🟢 signifies stable features which are unlikely to undergo major save-breaking changes.
- Yellow 🟡 signifies beta features which may undergo save-breaking changes.
- Red 🔴 signifies experimental features which are under development and may undergo significant changes.

The traffic light assigned to a main heading also applies to all of its sub-headings unless the sub-heading has its own traffic light.

# Skills 🟢
MSU provides groundbreaking functionality for clean, optimized, and highly inter-mod compatible skill modding. This solves two major problems in vanilla Battle Brothers skills.

Firstly, in vanilla BB, skills are often tightly coupled, so if one skill wants to modify a parameter in another skill, the two are tightly coupled via a function. Secondly, in vanilla BB, many parameters of skills cannot be changed in increments e.g. `this.m.ActionPointCost`. If a skill changes its `this.m.ActionPointCost` via an increment e.g. `+= 1` during its `onUpdate` or `onAfterUpdate` function, then the value of the `ActionPointCost` will continue to increase indefinitely every time that function is called. 

Let's take a random attack skill, Thrust, as an example. Let's say we have a skill that modifies the AP cost of Thrust by -1. The way to do this in vanilla would be:
```
function onAfterUpdate( _properties )
{
	this.m.ActionPointCost = this.getContainer().hasSkill("ourSkill") ? 3 : 4.	
}
```
Such a value is very hard for modders to modify without changing the entire `onAfterUpdate` function. MSU's **Automated Resetting** feature allows overcoming both of these problems in an elegant way, allowing you to write clean code for example like this:
```
// in ourSkill
function onAfterUpdate( _properties )
{
	local thrust = this.getContainer().getSkillByID("actives.thrust");
	if (thrust != null)
	{
		thrust.m.ActionPointCost -= 1
	}
}
```
This method keeps things encapsulated. Thrust doesn't need to know anything about whether "ourSkill" exists or not. Furthermore, it allows modders to modify the parameters of Thrust without breaking compatibility.

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

### `resetField( _field )`
This function can be used to reset a particular field back to its base value e.g. `<skill>.resetField(“Description”)`.

### Misc
The `HitChanceBonus` field of every skill is reset when a call to `onAnySkillUsed` is made. This allows other skills to modify the `HitChanceBonus` of a skill in increments without having to worry about infinite runaway changes.

### Use Cases
This system allows changing a value in a skill’s m table in increments rather than assigning it particular values, which opens up possibilities for flexible and compatible modding. For example, now you can do:
```
function onAfterUpdate( _properties )
{
	this.m.ActionPointCost -= 1
}
```
In the original game, doing this will cause the action point cost of the skill to continue to reduce indefinitely on every call to this function. However, with the MSU resetting system, this will ensure that the skill’s action point cost is only reduced by 1 compared to its base cost. Another mod can then hook the same function and add or subtract from the cost in further increments.

## Getting the saved base value of a field
`<skill>.getBaseValue( _field )`

`_field` is a key in the `m` table of skill. Returns the saved base value of that field.

## Scheduled Changes
Skills in Battle Brothers are updated in the order of their SkillOrder. Imagine we have two skills:

- Skill A with `this.m.SkillOrder = this.Const.SkillOrder.First`
- Skill B with `this.m.SkillOrder = this.Const.SkillOrder.Any`

Whenever the skill_container runs its `update()` or `buildPropertiesForUse` (which calls the `onAnySkillUsed` function in skills) functions, the respective functions are called on the skills in the order of their `SkillOrder`. Hence, skill A will update before skill B in the above example.

If you want skill A to modify something in skill B after skill B’s update, you would have to change the order of skill A to be something later than that of skill B e.g. set skill A’s order to `this.Const.SkillOrder.Last`. Usually this is quite doable. However, there may be cases where you absolutely want skill A to be updated before skill B but still want skill A to be able to change something in skill B when skill B is updated. MSU allows you to do this via the `scheduleChange` function.

Multiple changes to the same skill can be scheduled by using the function multiple times. Scheduled changes are executed in the `onAfterUpdate` function of the target skill after its base `onAfterUpdate` function (i.e. the one defined in the skill’s own file) has run.

### Usage:
`<skill>.scheduleChange( _field, _change, _set = false )`

`_field` is the key in the `m` table for which you want to schedule a change. `_change` is the new value. `_set` is a Boolean which, if `true`, sets the value of `_field` to `_change` and if `false` and if `_field` points to an integer or string value, adds `_change` to the value of `_field`.

#### Example:
The following code is written in skill A and will reduce the action point cost of skill B by 1 even if skill A updates before skill B:
```
function onUpdate( _properties )
{
	skillB.scheduleChange(“ActionPointCost”, -1);
}
```

## Damage Type 🟡
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

The skill’s rolled damage type’s Probability is also passed to `_hitInfo` calculated using the `<skill>.getDamageTypeProbability( _damageType )` function. This allows the target to access this information and receive different effects depending on how much weight of that `DamageType` the skill has.

MSU also adds the damage types of a skill to the skill’s tooltip automatically including their relative probabilities.

### Adding a new damage type
`this.Const.Damage.addNewDamageType( _damageType, _injuriesOnHead, _injuriesOnBody, _damageTypeName = "" )`

`_damageType` is a string which will become a key in the `this.Const.Damage.DamageType` table. `_injuriesOnHead` and `_injuriesOnBody` are arrays of strings where each entry is an ID of an injury skill. `_damageTypeName` is a string which can be used as the name of this damage type in tooltips; if not provided then `_damageType` is used as the name in tooltips.

### Getting a damage type's name
`this.Const.Damage.getDamageTypeName( _damageType )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns the name of the damage type as string, or returns an empty string if `_damageType` does not exist.

###	Getting a list of injuries a damage type can inflict
`this.Const.Damage.getDamageTypeInjuries( _damageType )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns a table `{ Head = [], Body = [] }` where Head and Body are arrays tables as their entries with each table having the following keys: `ID`, `Threshold`, `Script` for the injury skills that this damage type can apply on the respective body part. For examples of how such tables are constructed see the `character_injuries.nut` file in vanilla.

### Setting the injuries an existing damage type can inflict
`this.Const.Damage.setDamageTypeInjuries( _damageType, _injuriesOnHead, _injuriesOnBody )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_injuriesOnHead` and `_injuriesOnBody` are arrays of tables as their entries with each table having the following keys: `ID`, `Threshold`, `Script` for the injury skills that this damage type can apply. For examples of how such tables are constructed see the `character_injuries.nut` file in vanilla.

###	Getting a list of injuries applicable to a situation
`this.Const.Damage.getApplicableInjuries( _damageType, _bodyPart, _targetEntity = null )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_bodyPart` is the body part hit. `_targetEntity` is the entity being attacked which, if not null, removes the ExcludedInjuries of the `_targetEntity` from the returned array.

Returns an array which contains tables as its entries with each table having the following keys: `ID`, `Threshold`, `Script` for the injury skills that this damage type can apply in the given situation. For examples of how such tables are constructed see the `character_injuries.nut` file in vanilla.

### Checking if a skill has a damage type
`<skill>.hasDamageType( _damageType, _only = false )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. If `_only` is true, then function only returns true if the skill has no other damage type.

Returns a `true` if the skill has the damage type and `false` if it doesn’t.

### Adding a damage type to a skill
`<skill>.addDamageType( _damageType, _weight )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_weight` is an integer.

Adds the given damage type to the skill’s `this.m.DamageType` array with the provided weight.

###	Removing a damage type from a skill
`<skill>.removeDamageType( _damageType )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Removes the given damage type from the skill if the skill has it.

### Getting the damage type of a skill
`<skill>.getDamageType()`

Returns the `this.m.DamageType` array of the skill.

### Getting the weight of a skill’s particular damage type
`<skill>.getDamageTypeWeight( _damageType )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns an integer which is the weight of the given damage type in the skill. Returns null if the skill does not have the given damage type.

###	Setting the weight of a skill’s particular damage type
`<skill>.setDamageTypeWeight( _damageType, _weight )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table. `_weight` is an integer.

Finds the given damage type in the skill’s damage types and sets its weight to the given value. Does nothing if the skill does not have the given damage type.

### Getting the probability of a skill's particular damage type
`<skill>.getDamageTypeProbability( _damageType )`

`_damageType` is a slot in the `this.Const.Damage.DamageType` table.

Returns a float between 0 and 1 which is the probability of rolling the given damage type when using a skill. Returns null if the skill does not have the given damage type.

###	Rolling a damage type from a skill
`<skill>.getWeightedRandomDamageType()`

Selects a damage type from the skill based on weighted random distribution and returns it. The returned value is a slot in the `this.Const.Damage.DamageType` table. For example, this function is used by MSU in the `msu_injuries_handler_effect.nut` to roll a damage type from the skill when attacking a target.

### Accessing a skill's rolled damage type and damage weight during an attack
MSU adds the following two slots to the `this.Const.Tactical.HitInfo` table:
- `DamageType`
- `DamageTypeProbability`

When a skill is used to attack a target, the damage type of the skill is rolled using the `msu_injuries_handler_effect.nut` using the `onBeforeTargetHit` function, which adds the rolled `DamageType` and it's `DamageTypeProbability` (calculated using the `getDamageTypeProbability` function) to the hit info. These parameters can then be accessed by all skills which have access to the `_hitInfo`.

#### Example
For example, if a skill should only do something when the attacker attacked with Cutting damage using a skill which has more than 50% probability for cutting damage.
```
function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )`
{
	if( _hitInfo.DamageType == this.Const.Damage.DamageType.Cutting && _hitInfo.DamageTypeProbability > 0.5)
	{
		// Do stuff
	}
}
```

## Item Actions
Item Action refers to swapping/equipping/removing items on a character during combat. MSU completely overhauls how the action point costs for this are handled. Now you can add skills that modify how many Action Points it costs to swap items, depending on what kind of items they are. This is accomplished via three things:

1. `ItemActionOrder`
2. `getItemActionCost( _items )`
3. `onPayForItemAction( _skill, _items )`

### Defining a skill's item action order
The `ItemActionOrder` parameter of a skill defines the priority in which a skill is consumed for changing the AP cost of an item action. The possible values are defined in a table `this.Const.ItemActionOrder` and can be expanded. A skill's order can then be defined during the `create()` function by an expression such as `this.m.ItemActionOrder = this.Const.ItemActionOrder.First`. 

By default all skills are assigned `this.m.ItemActionOrder = this.Const.ItemActionOrder.Any`.

### Allowing a skill to change an item action's Action Point cost
`getItemActionCost( _items )`

`_items` is an array containing the items involved in the item action.

The function returns either `null` or an `integer`. If it returns null, this means that this skill does not change the Action Point cost of this item action. Returning an integer means that this skill will make this item action's Action Point cost equal to the returned value. By default it returns null for all skills.

This function can be defined in a skill, and programmed to suit the needs and effects of that skill.

### Changing parameters in a skill after an item action
`onPayForItemActionCost( _skill, _items )`

`_skill` is the skill chosen for determining the Action Point cost of the item action. `_items` is an array containing the items involved in the item action.

This function is called on all skills after an item action.

### Example
Using this new system, Quick Hands is now implemented as follows:
```
this.m.IsSpent = false;
this.m.ItemActionOrder = this.Const.ItemActionOrder.Any;

function getItemActionCost( _items )
{
	return this.m.IsSpent ? null : 0;
}

function onPayForItemAction( _skill,  _items )
{
	if( _skill == this)
	{
		this.m.IsSpent = true;
	}
}

function onTurnStart()
{
	this.m.IsSpent = false;
}
```
Similarly, if a skill was designed to only allow 0 Action Point cost swapping between two one-handed items, the `getItemActionCost` function could be coded as follows:
```
function getItemActionCost( _items )
{
	local count = 0;
	foreach (item in _items)
	{
		if (item != null && item.isItemType(this.Const.Items.ItemType.OneHanded))
		{
			count++;
		}
	}

	return count == 2 ? 0 : null;
}
```

## Ranged Tooltips 🔴
You should now use the parameters `this.m.AdditionalAccuracy` and `this.m.AdditionalHitChance` for all ranged skills. The `this.m.AdditionalAccuracy` is the base hitchance modifier for the skill e.g. it can be 0 for Quick Shot and 10 for Aimed Shot. Then the `this.m.AdditionalHitChance` is the hit chance change per tile of distance away from the minimum range of the skill e.g. Quick Shot has a minimum range of 1 tile and `this.m.AdditionalHitChance` of `-4` which means that for every tile beyond 1 tile of distance, the hitchance is reduced by `4`. You still need to manually modify the hitchance in the `onAnySkillUsed` function of the skill using these parameters.

`this.getDefaultRangedTooltip()`

This function allows you to generate the tooltip of the ranged skill by using the `this.m.AdditionalAccuracy` and `this.m.AdditionalHitChance` values provided in the skill.

**Note: This function may be removed and the functionality transferred directly into the getDefaultTooltip() function in a future version of MSU.**

## New onXYZ functions
MSU adds the following onXYZ functions to all skills. These functions are called on all skills of an actor whenever they trigger.

### Checking for the execution of a movement skill
`<skill_container>.m.IsExecutingMoveSkill`

This boolean is true when the character executes a movement based skill e.g. Rotation. It is set to true during `onAnySkillExecuted` and then set to false at the end of the function. The purpose of this boolean is to make sure that no corrupt tiles are fetched in functions as otherwise it led to crashes when `onAnySkillExecuted` had a call to a tile and the player used Rotation, because at this point somehow the tile is not a valid tile. The tile is valid at the start of the movement, and at the end, but not during it.

Therefore, when fetching the actor's tile via the `<actor>.getTile()` function in a situation where you think that it may be possible that the character is using a movement skill e.g. in our own skill's `onAnySkillExecuted` function, make sure to always check that this boolean is false.

### Using a skill
- `onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity )`
- `onAnySkillExecuted( _skill, _targetTile, _targetEntity )`

`_skill` is the skill being used. `_targetTile` is the tile on which the skill is being used. `_targetEntity` is the entity occupying `_targetTile` and is null if the tile was empty.

The first function is called before the used skill's `use` function triggers, whereas the second function is called after the `use` function is complete. When using a movement related skill e.g. Rotation, the `this.m.IsUsingMoveSkill` boolean of the skill_container will be `true` during the call to this function.

### Actor movement
- `onMovementStarted( _tile, _numTiles )`
- `onMovementFinished( _tile )`
- `onMovementStep( _tile, _levelDifference )`

`_tile` is the tile on which the movement was started or finished and `_numTiles` is how many tiles the actor is trying to move (?). `_levelDifference` is the difference between the target tile and the current tile.

During the calls to `onMovementStarted` and `onMovementFinished`, the `this.m.IsMoving` parameter of the actor is `true`. Note that `onMovementStep` is triggered even when the movement is prevented e.g. due to an attack of opportunity from an adjacent enemy. Therefore, if you really want to be sure that the actor actually moved, you should do a check such as `if (!_tile.isSameTileAs(this.getContainer().getActor().getTile())`.

### Actor death
- `onDeathWithInfo( _killer, _skill, _deathTile, _corpseTile, _fatalityType )`

`_killer` is the actor who killed this actor and can be null if there was no killer. `_skill` is the skill used to kill and can be null if the death occurred without a skill being involved. `_deathTile` is the tile on which this actor was present when the death occurred and can be null if the actor died while `isPlacedOnMap()` is false. `_corpseTile` is the tile on which the corpse spawned and can be null if no valid corpse tile existed. `_fatalityType` is the fatality type that occurred.

This function is more useful than the standard `onDeath()` function of skills as it passes several parameters. Note, however, that this function is called via a hook into the `onDeath` function of actor.nut. That function is normally called at the end of each entity's own individual `onDeath` function. Hence, this function runs after the entity's own `onDeath()` function but before the base actor.nut `onDeath()` function.

- `onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )`

`_killer` is the actor who killed `_victim` and can be null if there was no killer. `_skill` is the skill used to kill and can be null if the death occurred without a skill being involved. `_deathTile` is the tile on which this actor was present when the death occurred and is never null. `_corpseTile` is the tile on which the corpse spawned and can be null if no valid corpse tile existed. `_fatalityType` is the fatality type that occurred.

This function is called for all actors on the tactical map when an actor dies. Note that this function is only called when the tactical state is not `Fleeing` and when the `_deathTile` is not null i.e. the dying actor `isPlacedOnMap()`. This function is called via a hook into the `onDeath()` function of the dying actor and hence is called before the `onOtherActorDeath` functions of the actors on the battlefield are called.

### Damage
- `onAfterDamageReceived()`

This function is called after the actor has received damage.

### Time of Day
- `onNewMorning()`

This function is called when the time of day reaches Morning. This is different from `onNewDay()` which runs at noon.

### Leveling up
- `onUpdateLevel()`

This function is called when the player character levels up.

### Tooltips
`onQueryTooltip( _skill, _tooltip )`

`_skill` is the skill for which the tooltip has been queried. `_tooltip` is the tooltip returned by `_skill`'s `getTooltip()` function.

This function is called for all skills the character has when the tooltip for any skill is queried. This allows other skills to modify the tooltip before it is displayed to the user.

`onGetHitFactors( _skill, _targetTile, _tooltip )`

`_skill` is the skill being used on `_targetTile` and `_tooltip` is what is generated by the `getHitFactors(_targetTile)` function of `skill.nut`.

This function is called for all skills the character has when the hit factors tooltip is displayed. This allows individual skills to modify and/or add entries to the hit factors tooltip before it is displayed to the user.

## Injuries 🟢
MSU adds a system to exclude certain sets of injuries from certain entities easily. MSU comes with the following sets of injuries built-in (only include vanilla injuries):
- Hand
- Arm
- Foot
- Leg
- Face
- Head

### Creating a new set of excluded injuries or expanding an existing set
`this.Const.Injury.ExcludedInjuries.add( _name, _injuries, _include = [] )`

`_name` is a string that will become a key in the `this.Const.Injury.ExcludedInjuries` table. `_injuries` is an array containing skill IDs of injuries. `_include` is an array of slots from the `this.Const.Injury.ExcludedInjuries` table.

Creates an entry in the `this.Const.Injury.ExcludedInjuries` table with `_name` as key and `{ Injuries = _injuries, Include = _include }` as value. The slots passed in the `_include` array must already exist.

If the key `_name` already exists in `this.Const.Injury.ExcludedInjuries` then its associated `Injuries` and `Include` are expanded to include `_injuries` and `_include`.

#### Example
```
this.Const.Injury.ExcludedInjuries.add(
	“Hand”,
	[
		“injury.fractured_hand”,
		“injury.crushed_finger”
	]
);

this.Const.Injury.ExcludedInjuries.add(
	“Arm”, 
	[
		“injury.fractured_elbow”
	],
	[
		this.Const.Injury.ExcludedInjuries.Hand
	]
);
```

### Getting a set of excluded injuries
`this.Const.Injury.ExcludedInjuries.get( _injuries )`

`_injuries` is a slot in the `this.Const.Injury.ExcludedInjuries` table.

Returns an array including the skill IDs of all the injuries associated with that slot. The array is expanded using the all the sets of injuries defined in the associated `Include` of that set.

#### Example
```
this.Const.Injury.ExcludedInjuries.add(
	“Hand”,
	[
		“injury.fractured_hand”,
		“injury.crushed_finger”
	]
);

this.Const.Injury.ExcludedInjuries.add(
	“Arm”, 
	[
		“injury.fractured_elbow”
	],
	[
		this.Const.Injury.ExcludedInjuries.Hand
	]
);

local result = this.Const.Injury.ExcludedInjuries.get(this.Const.Injury.ExcludedInjuries.Arm);
```
In this example `result` will be equal to `["injury.fractured_elbow", “injury.fractured_hand”, “injury.crushed_finger”]`.

### Adding excluded injuries to actors
`<actor>.addExcludedInjuries( _injuries )`

`_injuries` is a slot in the `this.Const.Injury.ExcludedInjuries` table.

Uses the `this.Const.Injury.ExcludedInjuries.get` function using the passed parameter and adds the entries in the returned array to the `this.m.ExcludedInjuries` array of `<actor>`. Entries already present in `this.m.ExcludedInjuries` are not duplicated.

#### Example
In order to prevent Serpents from gaining Arm related injuries, hook the `onInit` function of serpent and add the following line of code:
```
this.addExcludedInjuries(this.Const.Injury.ExcludedInjuries.Arm);
```

# Actor 🟢
## `getActionPointsMax()`
MSU modifies the vanilla `getActionPointsMax` function of `actor` to now return a floored value.

## Convenience Functions
MSU adds several convenience functions to actor which allow for cleaner code and a faster modding experience.

### Getting actors at a certain distance
- `<actor>.getActorsAtDistanceAsArray( _distance, _relation = this.Const.FactionRelation.Any )`

Returns an array of all actors at a distance of `_distance` from `<actor>` and who have the faction relation `_relation` with `<actor>`'s faction.

- `<actor>.getRandomActorAtDistance( _distance, _relation = this.Const.FactionRelation.Any )`

Returns a random actor at a distance of `_distance` from `<actor>` and who has the faction relation `_relation` with `<actor>`'s faction.

### Getting actors within a certain distance
- `<actor>.getActorsWithinDistanceAsArray( _distance, _relation = this.Const.FactionRelation.Any )`

Returns an array of all actors within a distance of `_distance` inclusive from `<actor>` and who have the faction relation `_relation` with `<actor>`'s faction.

- `<actor>.getRandomActorWithinDistance( _distance, _relation = this.Const.FactionRelation.Any )`

Returns a random actor within a distance of `_distance` inclusive from `<actor>` and who has the faction relation `_relation` with `<actor>`'s faction.

### Getting items
- `<actor>.getMainhandItem()`

Returns the item currently equipped by `<actor>` in the Mainhand item slot. Returns null if no item is found in that slot.

- `<actor>.getOffhandItem()`

Returns the item currently equipped by `<actor>` in the Offhand item slot. Returns null if no item is found in that slot.

- `<actor>.getHeadItem()`

Returns the item currently equipped by `<actor>` in the Head item slot. Returns null if no item is found in that slot.

- `<actor>.getBodyItem()`

Returns the item currently equipped by `<actor>` in the Body item slot. Returns null if no item is found in that slot.

### Checking equipment
- `<actor>.isArmedWithOneHandedWeapon()`

Returns true if `<actor>` is currently holding a One-Handed item in their Mainhand, otherwise returns false.

- `<actor>.isArmedWithMeleeOrUnarmed()`

Returns true if `<actor>` is currently holding a Melee Weapon in their Mainhand or have the Hand to Hand active skill. Returns false if neither is true.

- `<actor>.isArmedWithTwoHandedWeapon()`

Returns true if `<actor>` is currently holding a Two-Handed item in their Mainhand, otherwise returns false.

- `<actor>.getRemainingArmorFraction( _bodyPart = null)`

Returns a float which is the current remaining armor durability as a fraction of the maximum durability. If `_bodyPart` is null then it returns the total remaining armor fraction calculated using both head and body armor.

- `<actor>.getTotalArmorStaminaModifier()`

Returns an integer which is the total stamina modifier of `<actor>`'s currently equippped head and body armor. Returns 0 if no armor is equipped.

### Checking situation
- `<actor>.isEngagedInMelee()`

Returns true only if `<actor>` is placed on the tactical map **and** there is an enemy who is exerting zone of control on `<actor>`. Otherwise returns false.

- `<actor>.isDoubleGrippingWeapon()`

Returns true if `<actor>` has access to the `special.double_grip` skill and the skill is not hidden. Otherwise returns false.

# Items 🟡

## New functions
### `onAfterUpdateProperties( _properties )`
Is called during update of the actor's skill container when the `onAfterUpdate` functions for skills are run. Similar to the `onUpdateProperties` function of items, this function is called via the `generic_item` skill that each item adds to the actor when that item is equipped. Hence, the `SkillOrder` of this function being called is `this.Const.SkillOrder.Item`.

### `getSkills()`
Returns an array which contains the skills of this item.

## Item Types
MSU provides functions to safely add a new ItemType to the game, and to modify the ItemType of items.

### Creating a new ItemType
`this.Const.Items.addNewItemType( _itemType )`

`itemType` is a string which will become a key in the `this.Const.Items.ItemType` table.

### Adding an item type to an item
`<item>.addItemType( _t )`

`_t` is an ItemType in the `gt.Const.Items.ItemType` table.

Adds the given item type to the item.

### Setting the item type of an item
`<item>.setItemType( _t )`

`_t` is an ItemType in the `gt.Const.Items.ItemType` table.

Sets the `this.m.ItemType` of the item to `_t`.

### Removing an item type from an item
`<item>.removeItemType( _t )`

`_t` is an ItemType in the `gt.Const.Items.ItemType` table.

Removes `_t` from the `this.m.ItemType` of this item. Does nothing if the item does not have the given item type.

# Weapons 🟢
## WeaponType and Categories
In the vanilla game, each item contains a `this.m.Categories` parameter which is a string and determines what is shown in the weapon’s tooltip e.g. `“Sword, Two-Handed”`. However, the actual type of the item is defined separately in `this.m.ItemType`. So it is entirely possible for someone to make a mistake and write `“Two-Handed”` in categories but assign `this.m.ItemType` as `this.Const.Items.ItemType.Onehanded`.

Similarly a weapon may be a Sword but someone can write `“Hammer, One-Handed”` in the categories and it won’t cause any errors. But this can lead to issues in terms of player confusion and especially if any mod adds skills/perks which require a certain type of weapon e.g. if the skill should only work with Swords.

MSU eliminates the need for manually typing `this.m.Categories` and builds this parameter automatically using assigned `WeaponType` and `ItemType` values.

### Weapon types
Weapon types are defined in the table `this.Const.Items.WeaponType`.

### Added a new weapon type
`this.Const.Items.addNewWeaponType( _weaponType, _weaponTypeName = "" )`

`_weaponType` is a string which will become a key in the `this.Const.Items.WeaponType` table. `_weaponTypeName` is an optional string parameter that will be used as the name of this weapon type in tooltips; if not provided then the same string as `_weaponType` is used as the name.

#### Example
`this.Const.Items.addNewWeaponType(“Musical”, “Musical Instrument”)` will add a weapon type that can then be accessed and checked against using `this.Const.Items.WeaponType.Musical` and will show up as `“Musical Instrument”` in tooltips.

### Getting the name of a weapon type
`this.Const.Items.getWeaponTypeName( _weaponType )`

Returns a string which is the the associated name of `_weaponType`. For instance, in the above example it will return `“Musical Instrument”` if `this.Const.Items.WeaponType.Musical` is passed as a parameter. If `_weaponType` does not exist as a weapon type, it returns an empty string.

### Adding a weapon type to a weapon
There are two methods of doing this. The recommended method is to use the `create()` function of the weapon to set its `this.m.WeaponType`. For example, for an Axe/Hammer hybrid weapon:
```
this.m.WeaponType = this.Const.Items.WeaponType.Axe | this.Const.Items.WeaponType.Hammer;
```

Alternatively, the following function can be used after the weapon has been created:
`<weapon>.addWeaponType( _weaponType, _setupCategories = true )`

`_weaponType` is a slot in the `this.Const.Items.WeaponType table`. If `_setupCategories` is true, then MSU will recreate the `this.m.Categories` of the weapon.

### Removing a weapon type from a weapon
`<weapon>.removeWeaponType( _weaponType, _setupCategories = true )`

`_weaponType` is a slot in the `this.Const.Items.WeaponType table`. If `_setupCategories` is true, then MSU will recreate the `this.m.Categories` of the weapon.

Removes a weapon type from the given weapon. Does nothing if the weapon does not have the given weapon type.

### Setting a weapon's weapon type
`<weapon>.setWeaponType( _weaponType, _setupCategories = true )`

`_weaponType` is a slot in the `this.Const.Items.WeaponType table`. If `_setupCategories` is true, then MSU will recreate the `this.m.Categories` of the weapon.

Sets the weapon’s `this.m.WeaponType` to `_weaponType`. Multiple weapon types can be passed `_weaponType` by using the bitwise |.

### Checking if a weapon has a certain weapon type
`<weapon>.isWeaponType( _weaponType, _only = false )`

`_weaponType` is a slot in the `this.Const.Items.WeaponType table`.

Returns true if the weapon has the given weapon type. If `_only` is true then it will only return true if the weapon has the given weapon type and no other weapon type.

### Setting a weapon's categories
This is generally discouraged, as modders are encouraged to use the WeaponType system to allow the categories to be automatically built. However, if the categories must be changed after a weapon has been created, it can be done using the following function:

`<weapon>.setCategories( _categories, _setupWeaponType = true )`

`_categories` is a string which will become the new `this.m.Categories` of that weapon. If `_setupWeaponType` is true, then MSU will automatically rebuild the WeaponType of the system based on the new categories string.

# Party, Player Party, Scenarios 🟢
MSU adds a robust movement speed system for parties on the world map. This is accomplished via new fields, new functions as well as some modified vanilla functions.

## `party`
### New fields
MSU adds the following new fields to `party`:
- `BaseMovementSpeedMult`
- `MovementSpeedMult`
- `RealBaseMovementSpeed` which is equal to `BaseMovementSpeed`
- `MovementSpeedFunctions` which is a table to which functions can be added which change the `MovementSpeedMultiplier`

### New functions
MSU adds the following new functions to `party`:
- `setRealBaseMovementSpeed(_speed)`

sets this.m.RealBaseMovementSpeed

- `getRealBaseMovementSpeed(_speed)`

returns this.m.RealBaseMovementSpeed

- `setBaseMovementSpeed ( _speed )`

Sets the `this.m.BaseMovementSpeed` field to `_speed`.

- `resetBaseMovementSpeed()`

Sets the `this.m.BaseMovementSpeed` to `this.m.RealBaseMovementSpeed`.

- `getBaseMovementSpeedMult()`

Returns `this.m.BaseMovementSpeedMult`.

- `setBaseMovementSpeedMult( _mult )`

Sets `this.m.BaseMovementSpeedMult` to `_mult`.

- `getMovementSpeedMult()`

Returns `this.m.MovementSpeedMult`.

- `setMovementSpeedMult( _mult )`

Sets `this.m.MovementSpeedMult` to `_mult`.

- `getFinalMovementSpeedMult()`

Calls all the functions in the `this.m.MovementSpeedFunctions` array and multiplies the returned values together. Then returns this resulting multiplier.

- `updateMovementSpeedMult()`

Sets `this.m.MovementSpeedMult` to the return value of `getFinalMovementSpeedMult()`. Intended to be called after any movement speed factors might have changed.

`Extracted speed functions`

`getSlowdownPerUnitMovementSpeedMult()`, `getGlobalMovementSpeedMult()`, `getRoadMovementSpeedMult()` `getNightTimeMovementSpeedMult()` `getRiverMovementSpeedMult()`, `getNotPlayerMovementSpeedMult()`
These functions have been extraced from `onUpdate()`, see below. They are added to the `MovementSpeedFunctions` table. They each return a multiplier.

`getTimeDelta`
This function has also been extracted from `onUpdate()`, see below. Returns the time delta since the last update of the party, and is used to calculate the distance moved by the party.

### Modified functions
- `setMovementSpeed(_speed)`

Overwritten. Now calls setBaseMovementSpeedMult with `_speed / 100.0`. This represents the move away from hardcoded BaseMovementSpeed values and towards multipliers.

- `getMovementSpeed(_update = false)`

Overwritten. Now returns the produce of `this.m.BaseMovementSpeed` and `this.m.MovementSpeedMult`. If `_update` is set to true, first calls  `updateMovementSpeedMult()`.

- `onUpdate()`

Overwritten. The individual speed factors of a party were each calculated here, now they have been extracted into the functions under the `Extracted speed functions` header.
Now calculates the speed of the party by calling `getMovementSpeed(true)`. This will first update the speed of the party to the currently correct value. Then, it is multiplied by the return of `getTimeDelta()`.
With this overwrite, it is now possible to finely tune the factors that go into the speed of a party.

- `onSerialize()`
Hooked. Adds flags to record BaseMovementSpeedMult and RealBaseMovementSpeed. Flags ensure that this is non-savebreaking.

- `onDeserialize()`
Hooked. Calls setBaseMovementSpeedMult() and setRealBaseMovementSpeed(), using the previously serialized flags.

## `player_party`
Calls `resetBaseMovementSpeed()` and sets `this.m.BaseMovementSpeedMult` to 1.05 to result in the vanilla player party movement speed of 105.

### New Functions
- `getRosterMovementSpeedMult()`

Queries any `movementSpeedMult` changes due to the roster, checks for `getMovementSpeedMult` key in each brother. Returns mult float.

- `getStashMovementSpeedMult()`

Queries any `movementSpeedMult` changes due to items, checks for `getMovementSpeedMult` key in each item in the player stash. Returns mult float.

- `getOriginMovementSpeedMult()`

Queries any `movementSpeedMult` changes due to the origin/scenario, checks for `getMovementSpeedMult` key in the origin. Returns mult float.

- `getRetinueMovementSpeedMult()`

Queries any `movementSpeedMult` changes due to the retinue, checks for `getMovementSpeedMult` key in each follower. Returns mult float.

### Modified Functions
- `create()`

Hooked to push the previous four functions to `this.m.MovementSpeedMultFunctions`.

##World.Common
- `this.Const.World.Common.assignTroops()`
Hooked to call `setBaseMovementSpeedMult()` on the `_party` with the `MovementSpeedMult` value of the `p` template.
Hooked to call `resetBaseMovementSpeed()` on the `_party`, to set it back to 100.
This represents the move away from hardcoded BaseMovementSpeed values and towards multipliers.

## Scenarios
The following scenarios were hooked to conform to the new MSU standards while achieving the same results as vanilla:

- Rangers scenario: `onInit()` was hooked to reset the `this.m.BaseMovementSpeed` to 100 and then added the `getMovementSpeedMult()` function to return the appropriate value to achieve the same speed as vanilla rangers scenario.

# Misc 🟢
MSU adds useful functionality to various miscellaneous classes.

## `turn_sequence_bar`
### Getting the active entity
`isActiveEntity( _entity )`

Returns true if the current active entity is not null and is `_entity`.

## `tactical_entity_manager`
### Getting all actors allied with a given faction
`getInstancesAlliedWithFaction( _faction )`

Returns an array containing all actors on the tactical map who are allied with `_faction`.

### Getting all actors hostile to a given faction
`getInstancesHostileWithFaction( _faction )`

Returns an array containing all actors on the tactical map who are hostile to `_faction`.

# Utilities 🟢
## Global UI Keyhandler and Custom Keybinds
MSU adds global input handlers, for mouse and keyboard inputs, on the Squirrel and the JS sides. This avoids having to hook the vanilla key handler functions when a mod wants to add a new keybind. It also allows users and modders to change or remove keybinds for actions.
To allow for this, the main input functions (onKeyInput and onMouseInput in world_state, tactical_state and main_menu_state) have been hooked. In JS, a new document-level event was registered.
Since we cannot have persistent mod data between saves, custom keybinds must be changed in a separate file. To do this, a new folder structure has been added: data/mod_config/keybinds. This keybinds folder currently comes with a file detailing all the vanilla keybinds. On game start, all the binds are parsed, and this allows for changing of vanilla binds. Mods adding new binds can add theirs in this same folder, and they will also be executed. See `CustomKeybinds` documentation for more information.

##Keyhandler
#General information
The keyhandler gathers arrays of events that are to be executed when a certain key or key combination is pressed. An event has an ID that is used to update and remove events, and a key combination expressed as a string. It is also executed via a certain context, which is world_state, tactical_state, main_menu_state or all of them. This context is passed to the function. 

- `AddHandlerFunction(_id, _key, _func, _state = 0)`
Adds a new handler function, when key `_key` is pressed. `_key` can also be a mouse input. `_key` is `_id` allows grouping and to remove the function once the screen is closed. `_func` is the function to execute. If `_func` returns false, no other function for the same key gets executed.

- `RemoveHandlerFunction(_id, _key)`
Removes a an event handling based on `_id`.

- `UpdateHandlerFunction = function(_id, _key)`
Updates a handler function to react to a new key, generally used by the backend when a custom keybind is found.

- `CallHandlerFunction(_key, _env, _state)`
Called when key is pressed. Calls each function registered under `_key` in reverse order of being added, so newest goes first. `_env` is the environment that has called the event. Only calls functions with with the same `_state` or `_state` all. If one function returns false, stops executing the other functions.

- `ProcessInput = function(_key, _env, _state, _inputType = 0)`
Parses the input from the hooked functions. Checks if the pressed key(s) exist in the key conversion table and adds the modifiers.

#JS side:
Mostly the same. Instead of individual hooks, there are two document-level event handlers for mouse and keyboard. The full event can be passed here.

##Custom Keybinds
#General Information
The Custom Binds module is used to be able to save and load custom keybinds for both vanilla and mod event handler functions. An input event is passed to this to be checked against the known custom keybinds, and if a match is found, the new keybind is returned instead. Keybinds are stored in the `CustomBindsJS` and `CustomBindsSQ` tables. On game start, the JS custom binds are passed over. To add custom keybinds in a manner that makes them easily editable by the user, include the data/mod_config/keybinds folder structure to your mod, and create a list of default actionID and keybind pairs in there- see MSU data structure.

- `ParseModifiers(_key)`
Gets the key input and parses modifiers: ctrl, shift, and alt.

- `get(_actionID, _defaultKey, _inSQ = true)`
Returns the keybind for `_actionID`. If none is found, the passed `_defaultKey` is used. If `_inSQ` is false, looks in the JS table.

- `set = function(_actionID, _key, _override = false, _inSQ = true)`
Sets a new `_key` for `_actionID`. Key must refer to to a string found in `KeyMapSQ`. Modifiers can be added with +, such as `delete+ctrl`.
If `_override` is not specified, will return if custom bind is already present. If `_inSQ` is false, sets in the JS table. Will update existing event handlers.

- `setForJS = function(_actionID, _key, _override = false, _inSQ = true)`
Convenience function for `_inSQ = false`. Use this for clarity.

- `remove(_actionID, _inSQ = true)`
Removes a custom keybind.

## Logging and Debugging
MSU adds functionality to improve the debugging capabilites of the user. It allows you to register a mod for debugging, optionally registering additional flags. This allows the user to leave debugging information in the code, but turn off specific parts when distributing the mod.
Every registered mod has a default flag. This allows for simple syntax, such as `printlog("My statement", "my_mod")`. If you want more granularity, you can add further flags to turn debug on and off for specific areas of the mod.

- `registerMod(_modID, _defaultFlagBool = false, _flagTable = null, _flagTableBool = null)`

Registers debugging for mod id `_modID`. Mod id should match up with modding script hooks registration name, if present. `_defaultFlagBool` sets the value of the `default` flag.
`_flagTable` is an optional table of `flagID` : `flagBool` pairs and must be of form `{ flag1 = false, flag2 = true ...}`, see this.MSU.Systems.Log.MSUDebugFlags for an example. If passed, sets these flags via setFlags().
`_flagTableBool` is an optional boolean for setFlags().
Example usage:

`local MSUDebugFlags = {
	debug = true,
	movement = true,
	skills = false
};
`

`
this.MSU.Systems.Log.registerMod("mod_MSU", true, MSUDebugFlags);
`

- `setFlags(_modID, _flagTable, _flagTableBool = null)`

Sets every flag in the `_flagTable` for mod `_modID`. If `_flagTableBool` is not null, every flag will be set to this value instead.

- `setFlag(_modID, _flagID, _flagBool)`

Sets one flag for mod `_modID` in the `ModTable`.

- `isEnabledForMod( _modID, _flagID = "default")`

Checks if debugging is enabled for mod `_modID` and flag `_flagID`.

- `::isDebugEnabled( _modID, _flagID = "default")`

Convenience function for this.MSU.Systems.Log.isEnabledForMod.

- `::printLog( _printText, _modID, _flagID = null)`, `::printWarning`, `::printError`

Substitutes for `this.logInfo`, `this.logWarning` and `this.logError`. Prints the log as `_printText` if debugging is enabled for the mod id `_modID`. `_flagID` specifies a flag of the mod, and is set to default if left empty.

`Other debugging tools`

- `this.MSU.Systems.Log.printStackTrace( _maxDepth = 0, _maxLen = 10, _advanced = false )`

Prints the entire stack trace at the point where it is called, including a list of all variables. Also prints the elements of any arrays or tables up to `_maxDepth` and `_maxLen`. If `_advanced` is set to true, it also prints the memory address of each object.

## Tile
`this.MSU.Tile.canResurrectOnTile( _tile, _force = false )`

`_tile` is a Battle Brothers tile instance.

Returns false if there is no corpse on the tile. If there is a corpse on the tile, then it returns true if that corpse can resurrect or if `_force` is set to true. This function can be hooked by mods to add additional functionality.

## String
`this.MSU.String.capitalizeFirst( _string )`

Returns the passed string `_string` with its first letter having been capitalized.

`this.MSU.String.replace( _string, _find, _replace )`

Finds the string `_find` in the string `_string` and replaces it with the string `_replace`. Then returns the result.

## Math
`this.MSU.log2int( _num )`

`_num` is an integer.

Returns the base 2 logarithm of `_num` floored as an int.

`this.MSU.normalDist( _x, _mean, _stdev )`

All three arguments can be any numbers, integer or float.

Returns the value of the Normal Distribution for `_x` for the provided mean value of `_mean` and standard deviation `_stdev`.

`this.MSU.normalDistDensity( _x, _mean, _stdev )`

All three arguments can be any numbers, integer or float.

Returns the probability density of `_x` using the Normal Distribution for the provided mean value of `_mean` and standard deviation `_stdev`.

## Classes
`this.this.MSU.Class.OrderedMap`

This is a class indexed by keys like a table,
but ordered like an array.
The only significant different is that
instead of an `in` check,
a call to the `contains` function must be used.

## UI

`this.MSU.UI.registerScreenToConnect( _screen )`

`_screen` is a UI screen with a `connect` function
 which will connect the SQ object to its JS counterpart.

This function will push the screen to an array of screens, 
which will then all be connected 
as soon as all JS & CSS files added by `::mods_register[CSS/JSS]` are loaded.

# Settings Manager 🟢

The settings manager is a save-compatible, automated system of
managing and displaying mod settings
which allows modders to easily setup configuration for their mods.

The system allows you to create a 'mod panel' for your mod,
add between 1 and 5 pages to it,
add it to the SettingsManager,
and finally create the settings you want to have.
All within Squirrel.

The settings are ordered by when they're added,
but this can be adjusted with a `sort()` on the Settings property
of the page.

These settings are automatically (de)serialized when loading/saving a game.

#### Adding a Panel to the SettingsManager
`this.MSU.Systems.ModSettings.add( _modPanel )`

`_modPanel` is a SettingsPanel.

## Settings Panel

#### Constructor
`local myModPanel = this.MSU.Class.SettingsPanel( _id, _name = null )`

`_id` and `_name` are strings,
`_name` defaults to `_id`,
`_id` has to be *unique* across all settings panels.

#### Adding a Page to a SettingsPanel
`<SettingsPanel>.add( _page )`

`_page` is a SettingsPage.

## Settings Page

#### Constructor
`local myPage = this.MSU.Class.SettingsPage( _id, _name = null )`

`_name` and `_id` are Strings, 
`_id` has to be *unique* for all SettingsPages within a SettingsPanel,
`_name` defaults to `_id`.

`myPage` then becomes the mod page that can have settings added to it.

#### Adding an Element to a SettingsPage
`<SettingsPage>.add( _element )`

`_element` is a `this.MSU.Class.SettingsElement`

## Setting Elements

All setting elements are classes
which inherit from `this.MSU.Class.SettingsElement`.
Custom elements *must* inherit from `SettingsElement`
or a descendant of it.

#### Setting Descripton for Tooltips

`function setDescription( _description )`

`_description` is a string

### Flags

Flags allow for settings to show up only during certain screens.

Use the `"NewCampaign"` flag to specify that a setting should show up
when creating a new campaign.

Use the `"NewCampaignOnly"` flag to specify that a setting should not show up
except when creating a new campaign.

#### Adding Flags

`<SettingElement>.addFlags( ... )`

`...` is an arbitrary number of string arguments eg: 
`("NewCampaign", "NewCampaignOnly")`

### AbstractSetting (extends SettingsElement)

Should not be initialized directly;
used as a parents for other settings.
All custom Settings should inherit from AbstractSetting.

#### Constructor
`local doNotUse = this.this.MSU.Class.AbstractSetting( _id, _value, _name = null )`

`_id` and `_name` are strings and `_id` defaults to `_name`.

`_id` *must* be unique for all settings within a mod panel.
`_value` sets the default value for the setting.

#### Lock the Setting
`function lock( _lockReason = "" )`

Prevents the setting from being changed by the user or by other code.
A `_lockReason` can be given which will show up in the tooltip.

#### Unlock the Setting
`function unlock()`

### BooleanSetting (extends AbstractSetting)

#### Constructor
`local myBooleanSetting = this.MSU.Class.BooleanSetting( _id, _value, _name = null )`

`_value` is a boolean.

Creates a simple checkbox.

### RangeSetting (extends AbstractSetting)

#### Constructor
`local myRangeSetting = this.MSU.Class.RangeSetting( _id, _value, _min, _max, _step, _name = null )`

`_name` and `_id` are strings,
`_value`, `_min`, `_max`, and `_step` are ints or floats.

Creates a slider 
which allows the user to select values between `_min` and `_max` 
with `_step` sized increments.

### EnumSetting (extends AbstractSetting)

#### Constructor
`local myEnumSetting = this.MSU.Class.EnumSetting( _id, _array, _value = null, _name = null )`

`_value` is a string element 
of the string array `_array`,
if `null` it will default to the first element of `_array`

Creates a Button 
which allows the user to switch between all the values in `_array`.

### Custom Settings

Additional Setting Types can be created by:

 - Creating a new setting class, 
 with a unique `Type`, 
 which inherits from AbstractSetting.
 - Defining a new JS var constructor for the Setting called 
 'TypeSetting' where 'Type' is replaced
 with the `Type` property of the setting class.
 - Adding an unbindTooltip function to that 'TypeSetting' var.
 - Defining the layout of the setting in a CSS

It is recommended to look at the already present implementations
as a guide.

### SettingsDivider (extends SettingsElement)

The settings system also allows adding a `this.MSU.Class.SettingsDivider`
to improve the layout of your mod page.
This is a horizontal line with an optional title.

`local myDivider = this.MSU.Class.SettingsDivider(_id, _name = "", _description = "")`

`_id` is a string and *must* be unique for the mod page.

If no name is provided,
the divider will be a thin horizontal line across the entire page.
