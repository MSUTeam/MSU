::MSU.MH.hook("scripts/items/item", function(q) {
	q.isItemType = @() function( _t, _any = true, _only = false )
	{
		if (_any)
		{
			return _only ? this.m.ItemType - (this.m.ItemType & _t) == 0 : (this.m.ItemType & _t) != 0;
		}
		else
		{
			return _only ? (this.m.ItemType & _t) == this.m.ItemType : (this.m.ItemType & _t) == _t;
		}
	}

	q.addItemType <- function ( _t )
	{
		this.m.ItemType = this.m.ItemType | _t;
	}

	q.setItemType <- function( _t )
	{
		this.m.ItemType = _t;
	}

	q.removeItemType <- function( _t )
	{
		if (this.isItemType(_t, false)) this.m.ItemType -= _t;
		else throw ::MSU.Exception.KeyNotFound(_t);
	}

	q.getSkills <- function()
	{
		return this.m.SkillPtrs.filter(@(idx, skill) skill.getID() != "items.generic");
	}

	q.getMovementSpeedMult <- function()
	{
		return 1.0;
	}

	q.getDescription = @(__original) function()
	{
		if (!::MSU.Mod.ModSettings.getSetting("ExpandedItemTooltips").getValue())
		{
			return __original();
		}

		local names = "";
		foreach (itemType in ::Const.Items.ItemType)
		{
			if (this.isItemType(itemType))
			{
				local name = ::Const.Items.getItemTypeName(itemType);
				if (name != "")
				{
					names += name + ", "
				}
			}
		}

		return names != "" ? "[color=" + ::Const.UI.Color.NegativeValue + "]" + names.slice(0, -2) + "[/color]\n\n" + __original() : __original();
	}

	q.onAfterUpdateProperties <- function( _properties )
	{			
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
	}
});
