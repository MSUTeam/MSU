local gt = this.getroottable();

gt.MSU.modWeapon <- function ()
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
		Throwing = 16384,
		Musical = 32768
	}

	gt.Const.Items.WeaponTypeName <- [
		"No Weapon Type",
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
		"Throwing Weapon",
		"Musical Instrument"
	]

	gt.Const.Items.getWeaponTypeName <- function(_weaponType)
	{
		// local idx = log(_weaponType) / log(2) + 1;
		// if (idx == idx.tointeger() && idx < this.Const.Items.WeaponTypeName.len())
		// {
		// 	return this.Const.Items.WeaponTypeName[idx]; 
		// }
		// return "";

		local w = 0;
		for (local i = 0; i < this.Const.Items.WeaponType.len(); i++)
		{
			this.logInfo("w = " + w + ", i = " + i);
			if (w == _weaponType)
			{
				return this.Const.Items.WeaponTypeName[i];
			}
			w = w == 0 ? 1 : w << 1;
		}

		this.logError("getWeaponTypeName: _weaponType \'" + _weaponType + "\' does not exist");

		return "";
	}

	gt.Const.Items.addNewWeaponType <- function(_weaponType, _weaponTypeName = "")
	{
		if (_weaponType in this.Const.Items.WeaponType)
		{
			this.logError("addNewWeaponType: \'" + _weaponType + "\' already exists.");
			return;
		}

		local max = 0;
		foreach (w, value in this.Const.Items.WeaponType)
		{
			if (value > max)
			{
				max = value;
			}
		}
		this.Const.Items.WeaponType[_weaponType] <- max << 1;

		if (_weaponTypeName == "")
		{
			_weaponTypeName = _weaponType;
		}

		this.Const.Items.WeaponTypeName.push(_weaponTypeName);
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
					if (this.m.WeaponType != this.Const.Items.WeaponType.None)
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

		o.setCategories <- function(_s, _setupWeaponType = true)
		{
			this.m.Categories = _s;

			if (_setupWeaponType)
			{
				this.setupWeaponType();
			}
		}

		o.setupWeaponType <- function()
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

			if (categories.find("One-Handed") != null && !this.isItemType(this.Const.Items.ItemType.OneHanded))
			{
				this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.OneHanded;
				if (this.isItemType(this.Const.Items.ItemType.TwoHanded))
				{
					this.m.ItemType -= this.Const.Items.ItemType.TwoHanded;
				}
			}

			if (categories.find("Two-Handed") != null && !this.isItemType(this.Const.Items.ItemType.TwoHanded))
			{
				this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.TwoHanded;
				if (this.isItemType(this.Const.Items.ItemType.OneHanded))
				{
					this.m.ItemType -= this.Const.Items.ItemType.OneHanded;
				}
			}
		}

		o.isWeaponType <- function( _t, _only = false )
		{
			return _only ? this.m.WeaponType == _t : (this.m.WeaponType & _t) != 0;
		}

		o.addWeaponType <- function(_weaponType, _setupCategories = true)
		{
			if (!this.isWeaponType(_weaponType))
			{
				this.m.WeaponType = this.m.WeaponType | _weaponType;

				if (_setupCategories)
				{
					this.setupCategories();
				}
			}
		}

		o.setWeaponType <- function(_t, _setupCategories = true)
		{
			this.m.WeaponType = _t;

			if (_setupCategories)
			{
				this.setupCategories();
			}
			
		}

		o.removeWeaponType <- function(_weaponType, _setupCategories = true)
		{
			if (this.isWeaponType(_weaponType))
			{
				this.m.WeaponType -= _weaponType;				
			}

			if (_setupCategories)
			{
				this.setupCategories();
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
