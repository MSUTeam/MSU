::mods_hookBaseClass("items/item", function(o) {
	local child = o;
	o = o[o.SuperName];

	o.addItemType <- function ( _t )
	{
		this.m.ItemType = this.m.ItemType | _t;
	}

	o.setItemType <- function( _t )
	{
		this.m.ItemType = _t;
	}

	o.isAllItemTypes <- function( _t )
	{
		return this.m.ItemType & _t == _t;
	}

	o.removeItemType <- function( _t )
	{
		if (this.isAllItemTypes(_t))
		{
			this.m.ItemType -= _t;		
		}
	}

	o.getSkills <- function()
	{
		return this.m.SkillPtrs;
	}

	local getDescription = o.getDescription;
	o.getDescription = function()
	{
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

		return names.len() > 1 ? "[color=" + ::Const.UI.Color.NegativeValue + "]" + names.slice(0, -2) + "[/color]\n\n" + getDescription() : getDescription();
	}

	local addSkill = o.addSkill;
	o.addSkill = function( _skill )
	{
		if (_skill.isType(::Const.SkillType.Active) && ("FatigueOnSkillUse" in child.m))
		{
			_skill.setFatigueCost(::Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
		}

		addSkill(_skill);
	}

	o.onAfterUpdateProperties <- function( _properties )
	{			
	}
});
