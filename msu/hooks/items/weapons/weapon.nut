::MSU.MH.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.setupWeaponType();
		this.setupCategories();
	}
});

::MSU.MH.hook("scripts/items/weapons/weapon", function(q) {
	q.m.WeaponType <- ::Const.Items.WeaponType.None;
	q.m.MSU_WeaponTypeInit <- false;

	q.setCategories <- function( _s, _setupWeaponType = true )
	{
		this.m.Categories = _s;

		if (_setupWeaponType)
		{
			this.setupWeaponType(true);
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

	q.setupWeaponType <- function( _force = false )
	{
		if (this.m.MSU_WeaponTypeInit && !_force)
			return;
		this.m.MSU_WeaponTypeInit = true;
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
		this.setupWeaponType();
		if (_any)
		{
			return _only ? this.m.WeaponType - (this.m.WeaponType & _t) == 0 : (this.m.WeaponType & _t) != 0;
		}
		else
		{
			return _only ? (this.m.WeaponType & _t) == this.m.WeaponType : (this.m.WeaponType & _t) == _t;
		}
	}

	q.addWeaponType <- function( _weaponType, _setupCategories = true )
	{
		this.setupWeaponType();
		this.m.WeaponType = this.m.WeaponType | _weaponType;

		if (_setupCategories)
		{
			this.setupCategories();
		}
	}

	q.setWeaponType <- function( _t, _setupCategories = true )
	{
		this.setupWeaponType();
		this.m.WeaponType = _t;

		if (_setupCategories)
		{
			this.setupCategories();
		}
	}

	q.removeWeaponType <- function( _weaponType, _setupCategories = true )
	{
		this.setupWeaponType();
		if (this.isWeaponType(_weaponType, false))
		{
			this.m.WeaponType -= _weaponType;

			if (_setupCategories)
			{
				this.setupCategories();
			}
		}
	}

	q.setupCategories <- function()
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
});
