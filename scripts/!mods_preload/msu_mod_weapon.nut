local gt = this.getroottable();

gt.MSU.modWeapon <- function ()
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
				if (this.getCategories() == "")
				{
					if (this.m.WeaponType != null)
					{
						this.setupCategories();
					}
				}
				else
				{
					this.setupWeaponType();
				}
			}
		}
	});

	::mods_hookExactClass("items/weapons/weapon", function(o) {
		o.m.WeaponType <- null;

		local addSkill = o.addSkill;
		o.addSkill = function(_skill)
		{
			if (_skill.isType(this.Const.SkillType.Active))
			{
				_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
			}

			addSkill(_skill);
		}

		o.setCategories <- function(_s)
		{
			this.m.Categories = _s;
			this.setupWeaponType();
		}

		o.setupWeaponType <- function()
		{
			this.m.WeaponType = null;

			local categories = this.getCategories();
			if (categories.len() == 0)
			{
				return;
			}

			foreach (k, w in this.Const.Items.WeaponType)
			{
				if (categories.find(k) != null)
				{
					if (this.m.WeaponType == null)
					{
						this.m.WeaponType = w;
					}
					else
					{
						this.m.WeaponType = this.m.WeaponType | w;
					}
				}
			}

			if (categories.find("One-Handed") != null && !this.isItemType(this.Const.Items.ItemType.OneHanded))
			{
				this.m.ItemType = this.m.ItemType == null ? this.Const.Items.ItemType.OneHanded : this.m.ItemType | this.Const.Items.ItemType.OneHanded;
				if (this.isItemType(this.Const.Items.ItemType.TwoHanded))
				{
					this.m.ItemType -= this.Const.Items.ItemType.TwoHanded;
				}
			}

			if (categories.find("Two-Handed") != null && !this.isItemType(this.Const.Items.ItemType.TwoHanded))
			{
				this.m.ItemType = this.m.ItemType == null ? this.Const.Items.ItemType.TwoHanded : this.m.ItemType | this.Const.Items.ItemType.TwoHanded;
				if (this.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					this.m.ItemType -= this.Const.Items.ItemType.OneHanded;
				}
			}
		}

		o.isWeaponType <- function( _t )
		{
			return (this.m.WeaponType & _t) != 0;
		}

		o.addWeaponType <- function(_weaponType)
		{
			this.m.WeaponType = this.m.WeaponType == null ? _weaponType : this.m.WeaponType | _weaponType;
			this.setupCategories();
		}

		o.removeWeaponType <- function(_weaponType)
		{
			if (this.isWeaponType(_weaponType))
			{
				this.m.WeaponType -= _weaponType;
				if (this.m.WeaponType == 0)
				{
					this.m.WeaponType = null;
				}
			}
		}

		o.setupCategories <- function()
		{
			this.m.Categories = "";

			foreach (w in this.Const.Items.WeaponType)
			{
				if (this.isWeaponType(w))
				{
					this.m.Categories += this.Const.Items.getWeaponTypeName(w) + "/";
				}
			}

			this.m.Categories = this.m.Categories.slice(0, -1) + ", ";

			if (this.isItemType(this.Const.Items.ItemType.OneHanded))
			{
				this.m.Categories += "One-Handed";
			}
			else if (this.isItemType(this.Const.Items.ItemType.TwoHanded))
			{
				this.m.Categories += "Two-Handed";
			}
		}
	});
}
