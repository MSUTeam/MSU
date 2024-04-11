::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier",
			"RegularDamage",
			"RegularDamageMax"
			"ArmorDamageMult"
			"ChanceToHitHead"
			"DirectDamageMult"
			"DirectDamageAdd"
			"StaminaModifier"
			"ShieldDamage"
			"AdditionalAccuracy"
			"FatigueOnSkillUse"
		];
	}
});

::MSU.HooksMod.hookTree("scripts/items/weapons/named/named_weapon", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);
});
