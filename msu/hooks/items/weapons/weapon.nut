::MSU.MH.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.initWeaponType();
	}
});

::MSU.MH.hook("scripts/items/weapons/weapon", function(q) {
	q.m.WeaponType <- ::Const.Items.WeaponType.None;
	q.m.MSU_WeaponTypeInit <- false;

	q.setCategories <- function( _s, _rebuildWeaponType = true )
	{
		this.m.Categories = _s;

		if (_rebuildWeaponType)
		{
			this.buildWeaponTypeFromCategories();
		}
	}

	q.addSkill = @(__original) function( _skill )
	{
		local ret = __original(_skill);
		if (::MSU.isIn("AdditionalAccuracy", _skill.m, true))
		{
			_skill.resetField("AdditionalAccuracy");
			_skill.m.AdditionalAccuracy += this.m.AdditionalAccuracy;
			_skill.setBaseValue("AdditionalAccuracy", _skill.m.AdditionalAccuracy);
		}
		return ret;
	}

	q.buildWeaponTypeFromCategories <- function()
	{
		this.m.WeaponType = ::Const.Items.WeaponType.None;

		local categories = this.getCategories();
		if (categories.len() == 0)
		{
			return;
		}

		foreach (k, w in ::Const.Items.WeaponType)
		{
			if (categories.find(k) != null)
			{
				this.m.WeaponType = this.m.WeaponType | w;
			}
		}

		if (categories.find("One-Handed") != null && !this.isItemType(::Const.Items.ItemType.OneHanded))
		{
			this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.OneHanded;
			if (this.isItemType(::Const.Items.ItemType.TwoHanded))
			{
				this.m.ItemType -= ::Const.Items.ItemType.TwoHanded;
			}
		}

		if (categories.find("Two-Handed") != null && !this.isItemType(::Const.Items.ItemType.TwoHanded))
		{
			this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.TwoHanded;
			if (this.isItemType(::Const.Items.ItemType.OneHanded))
			{
				this.m.ItemType -= ::Const.Items.ItemType.OneHanded;
			}
		}
	}

	q.isWeaponType <- function( _t, _any = true, _only = false )
	{
		this.initWeaponType();
		if (_any)
		{
			return _only ? this.m.WeaponType - (this.m.WeaponType & _t) == 0 : (this.m.WeaponType & _t) != 0;
		}
		else
		{
			return _only ? (this.m.WeaponType & _t) == this.m.WeaponType : (this.m.WeaponType & _t) == _t;
		}
	}

	q.addWeaponType <- function( _weaponType, _rebuildCategories = true )
	{
		this.initWeaponType();
		this.m.WeaponType = this.m.WeaponType | _weaponType;

		if (_rebuildCategories)
		{
			this.buildCategoriesFromWeaponType();
		}
	}

	q.setWeaponType <- function( _t, _rebuildCategories = true )
	{
		this.initWeaponType();
		this.m.WeaponType = _t;

		if (_rebuildCategories)
		{
			this.buildCategoriesFromWeaponType();
		}
	}

	q.removeWeaponType <- function( _weaponType, _rebuildCategories = true )
	{
		this.initWeaponType();
		if (this.isWeaponType(_weaponType, false))
		{
			this.m.WeaponType -= _weaponType;

			if (_rebuildCategories)
			{
				this.buildCategoriesFromWeaponType();
			}
		}
	}

	q.buildCategoriesFromWeaponType <- function()
	{
		this.m.Categories = "";

		foreach (w in ::Const.Items.WeaponType)
		{
			if (this.isWeaponType(w))
			{
				this.m.Categories += ::Const.Items.getWeaponTypeName(w) + "/";
			}
		}

		if (this.m.Categories != "") this.m.Categories = this.m.Categories.slice(0, -1) + ", ";

		if (this.isItemType(::Const.Items.ItemType.OneHanded))
		{
			this.m.Categories += "One-Handed";
		}
		else if (this.isItemType(::Const.Items.ItemType.TwoHanded))
		{
			this.m.Categories += "Two-Handed";
		}
	}

	q.initWeaponType <- function()
	{
		if (this.m.MSU_WeaponTypeInit)
			return;

		this.m.MSU_WeaponTypeInit = true;

		if (this.getCategories() == "")
		{
			this.buildCategoriesFromWeaponType();
		}
		else
		{
			this.buildWeaponTypeFromCategories();
		}
	}
});
