::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/weapons/named/named_weapon");

::MSU.MH.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.getBaseItemFields = @() function()
	{
		return [
			// The following fields are used in vanilla randomizeValues()
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

			// The following fields aren't used in vanilla randomizeValues() but we copy them
			// for the sake of completion so that named items can be based on base items properly
			"Ammo",
			"AmmoMax",
			"AmmoCost",
			"IsAoE",
			"SlotType",
			"BlockedSlotType",
			"ItemType",
			"WeaponType",
			"IsDoubleGrippable",
			"IsAgainstShields",
			"RangeMin",
			"RangeMax",
			"RangeIdeal",
		];
	}
});
