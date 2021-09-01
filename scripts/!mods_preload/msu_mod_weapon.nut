local gt = this.getroottable();

gt.Const.MSU.modWeapon <- function ()
{
	gt.Const.Items.WeaponType <- {
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

	gt.Const.Items.WeaponTypeName <- [
		"Axe",
		"Bow",
		"Cleaver",
		"Crossbow",
		"Dagger",
		"Firearm",
		"Flail",
		"Hammer",
		"Mace",
		"Polearm",
		"Sling",
		"Spear",
		"Sword",
		"Staff",
		"Throwing"
	]

	gt.Const.Items.getWeaponTypeName <- function(_weaponType)
	{
		foreach (w in this.Const.Items.WeaponType)
		{
			if (w == _weaponType)
			{
				return this.Const.Items.WeaponTypeName[log(w)/log(2)];
			}
		}

		return null;
	}

	gt.Const.Items.addNewWeaponType <- function(_weaponType, _weaponTypeName = "")
	{
		local n = 0;
		foreach (w in this.Const.Items.WeaponType)
		{
			n = this.Math.max(n, w);
		}

		gt.Const.Items.WeaponType[_weaponType] <- n * 2;

		if (_weaponTypeName == "")
		{
			_weaponTypeName = _weaponType;
		}

		gt.Const.Items.WeaponTypeName.push(_weaponTypeName);
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
