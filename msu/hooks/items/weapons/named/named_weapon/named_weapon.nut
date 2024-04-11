::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);

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

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
		::MSU.HooksHelper.addBaseItemToNamedItemVeryLate(q);
	});
});
