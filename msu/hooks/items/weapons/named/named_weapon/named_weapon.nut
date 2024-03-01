::MSU.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	q.m.BaseItemScript <- null;

	q.getValuesForRandomize <- function()
	{
		if (this.m.BaseItemScript == null)
			return {};

		local baseWeapon = ::new(this.m.BaseItemScript);
		return {
			Condition = baseWeapon.m.Condition;
			ConditionMax = baseWeapon.m.ConditionMax;
			RegularDamage = baseWeapon.m.RegularDamage;
			RegularDamageMax = baseWeapon.m.RegularDamageMax;
			ArmorDamageMult = baseWeapon.m.ArmorDamageMult;
			ChanceToHitHead = baseWeapon.m.ChanceToHitHead;
			DirectDamageMult = baseWeapon.m.DirectDamageMult;
			DirectDamageAdd = baseWeapon.m.DirectDamageAdd;
			StaminaModifier = baseWeapon.m.StaminaModifier;
			ShieldDamage = baseWeapon.m.ShieldDamage;
			AdditionalAccuracy = baseWeapon.m.AdditionalAccuracy;
			FatigueOnSkillUse = baseWeapon.m.FatigueOnSkillUse;
		};
	}

	q.setValuesForRandomize <- function( _values )
	{
		foreach (key, value in _values)
		{
			this.m[key] = value;
		}
	}

	q.randomizeValues <- @(__original) function()
	{
		this.setValuesBeforeRandomize(this.getValuesBeforeRandomize());
		return __original();
	}
});
