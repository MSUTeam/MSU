::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.m.BaseItemScript <- null;

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

	q.setValuesBeforeRandomize <- function()
	{
		if (this.m.BaseItemScript == null)
			return;

		local baseM = ::new(this.m.BaseItemScript).m;
		foreach (field in this.getFieldsForRandomize())
		{
			this.m[field] = baseM[field];
		}
	}

	q.randomizeValues <- @(__original) function()
	{
		this.setValuesBeforeRandomize();
		return __original();
	}
});
