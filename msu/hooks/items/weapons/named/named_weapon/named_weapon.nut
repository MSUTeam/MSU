::mods_hookExactClass("items/weapons/named/named_weapon", function(o) {
	o.m.BaseWeaponScript <- null;

	local randomizeValues = o.randomizeValues;
	o.randomizeValues <- function()
	{
		if (this.m.BaseWeaponScript != null)
		{
			local baseWeapon = ::new(this.m.BaseWeaponScript);
			this.m.Condition = baseWeapon.m.Condition;
			this.m.ConditionMax = baseWeapon.m.ConditionMax;
			this.m.RegularDamage = baseWeapon.m.RegularDamage;
			this.m.RegularDamageMax = baseWeapon.m.RegularDamageMax;
			this.m.ArmorDamageMult = baseWeapon.m.ArmorDamageMult;
			this.m.ChanceToHitHead = baseWeapon.m.ChanceToHitHead;
			this.m.DirectDamageMult = baseWeapon.m.DirectDamageMult;
			this.m.DirectDamageAdd = baseWeapon.m.DirectDamageAdd;
			this.m.StaminaModifier = baseWeapon.m.StaminaModifier;
			this.m.ShieldDamage = baseWeapon.m.ShieldDamage;
			this.m.AdditionalAccuracy = baseWeapon.m.AdditionalAccuracy;
			this.m.FatigueOnSkillUse = baseWeapon.m.FatigueOnSkillUse;
		}

		randomizeValues();
	}
});
