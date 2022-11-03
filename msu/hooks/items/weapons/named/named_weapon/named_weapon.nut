::mods_hookExactClass("items/weapons/named/named_weapon", function(o) {
	o.m.BaseWeaponScript <- null;

	o.getValuesForRandomize <- function()
	{
		if (this.m.BaseWeaponScript == null) return {};

		local baseWeapon = ::new(this.m.BaseWeaponScript);
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

	o.setValuesForRandomize <- function( _values )
	{
		foreach (key, value in _values)
		{
			this.m[key] = value;
		}
	}

	local randomizeValues = o.randomizeValues;
	o.randomizeValues <- function()
	{
		this.setValuesBeforeRandomize(this.getValuesBeforeRandomize());
		randomizeValues();
	}
});
