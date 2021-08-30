local gt = this.getroottable();

gt.Const.MSU.modWeapon <- function ()
{
	gt.Const.Items.WeaponType <- {
		None = 0,
		Axe = 1,
		Bow = 2,
		Cleaver = 4,
		Crossbow = 8,
		Dagger = 16,
		Firearm = 32,
		Flail = 64,
		Hammer = 128,
		Mace = 256,
		Polearm = 512,
		Sling = 1024,
		Spear = 2048,
		Sword = 4096,
		Staff = 8192,
		Throwing = 16384
	}

	gt.Const.Items.addNewWeaponType <- function(_weaponTypeName)
	{
		local n = 0;
		foreach (w in this.Const.Items.WeaponType)
		{
			n = this.Math.max(n, w);
		}

		gt.Const.Items.WeaponType[_weaponTypeName] <- n * 2;
	}

	::mods_hookDescendants("items/weapons/weapon", function(o) {
		if ("create" in o)
		{
			local create = o.create;
			o.create = function()
			{
				create();
				if (this.getCategories() != "")
				{
					this.setupWeaponTypes();
				}
			}
		}
	});

	::mods_hookExactClass("items/weapons/weapon", function(o) {
		o.m.WeaponType <- this.Const.Items.WeaponType.None;

		local addSkill = o.addSkill;
		o.addSkill = function(_skill)
		{
			if (_skill.isType(this.Const.SkillType.Active))
			{
				_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
			}

			addSkill(_skill);
		}

		o.setupWeaponTypes <- function()
		{
			this.m.WeaponType = this.Const.Items.WeaponType.None;

			local categories = this.getCategories();
			if (categories.len() == 0)
			{
				return;
			}

			foreach (k, w in this.Const.Items.WeaponType)
			{
				if (categories.find(k) != null)
				{
					if (this.m.WeaponType == this.Const.Items.WeaponType.None)
					{
						this.m.WeaponType = w;
					}
					else
					{
						this.m.WeaponType = this.m.WeaponType | w;
					}
				}
			}
		}

		o.isWeaponType <- function( _t )
		{
			return (this.m.WeaponType & _t) != 0;
		}
	});
}
