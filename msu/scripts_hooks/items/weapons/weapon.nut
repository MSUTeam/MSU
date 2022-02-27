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

	o.setCategories <- function( _s, _setupWeaponType = true )
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

	o.isAllWeaponTypes <- function( _t )
	{
		return this.m.WeaponType & _t == _t;
	}

	o.addWeaponType <- function( _weaponType, _setupCategories = true )
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

	o.setWeaponType <- function( _t, _setupCategories = true )
	{
		this.m.WeaponType = _t;

		if (_setupCategories)
		{
			this.setupCategories();
		}
		
	}

	o.removeWeaponType <- function( _weaponType, _setupCategories = true )
	{
		if (this.isAllWeaponTypes(_weaponType))
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