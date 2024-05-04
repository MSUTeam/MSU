::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/weapons/named/named_weapon");

::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.getBaseItemFields = @() function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier",
			"RegularDamage",
			"RegularDamageMax",
			"ArmorDamageMult",
			"ChanceToHitHead",
			"DirectDamageMult",
			"DirectDamageAdd",
			"StaminaModifier",
			"ShieldDamage",
			"AdditionalAccuracy",
			"FatigueOnSkillUse",
		];
	}
});
