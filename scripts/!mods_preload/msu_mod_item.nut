local gt = this.getroottable();

gt.MSU.modItem <- function ()
{
	gt.Const.Items.ItemTypeName <- [];
	gt.Const.Items.ItemTypeName.resize(gt.Const.Items.ItemType.len(), "");
	
	foreach (itemType in this.Const.Items.ItemType)
	{
		local name = "";
		switch (itemType)
		{
			case this.Const.Items.ItemType.Legendary:
				name = "Legendary Item";
				break;

			case this.Const.Items.ItemType.Named:
				name = "Famed Item";				
				break;

			case this.Const.Items.ItemType.Tool:
				name = "Tool";				
				break;

			case this.Const.Items.ItemType.Crafting:
				name = "Crafting Item";				
				break;

			case this.Const.Items.ItemType.TradeGood:
				name = "Trade Good";				
				break;
		}
		local idx = this.MSU.Math.log2int(itemType) + 1;
		this.Const.Items.ItemTypeName[idx] = name;
	}

	gt.Const.Items.addNewItemType <- function( _itemType, _name = "" )
	{
		if (_itemType in this.Const.Items.ItemType)
		{
			this.logError("addNewItemType: \'" + _itemType + "\' already exists.");
			return;
		}

		local max = 0;
		foreach (w, value in this.Const.Items.ItemType)
		{
			if (value > max) max = value;
		}

		local val = max << 1;
		this.Const.Items.ItemType[_itemType] <- val;
		this.Const.Items.ItemFilter.All = this.Const.Items.ItemFilter.All | val;
		this.Const.Items.ItemTypeName.push(_name);
	}

	gt.Const.Items.getItemTypeName <- function( _itemType )
	{
		local idx = this.MSU.Math.log2int(_itemType) + 1;
		if (idx < this.Const.Items.ItemTypeName.len())
		{
			return this.Const.Items.ItemTypeName[idx];
		}

		this.logError("getItemTypeName: _itemType \'" + _itemType + "\' does not exist");
		return "";
	}

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

		o.removeItemType <- function( _t )
		{
			if (this.isItemType(_t))
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
			local ret = "[color=" + this.Const.UI.Color.NegativeValue + "]";
			local hasNamedItemType = false;
			foreach (itemType in this.Const.Items.ItemType)
			{
				if (this.isItemType(itemType))
				{
					local name = this.Const.Items.getItemTypeName(itemType);
					if (name != "")
					{
						hasNamedItemType = true;
						ret += name + ", "
					}	
				}
			}

			return hasNamedItemType ? ret.slice(0, -2) + "[/color]\n\n" + getDescription() : getDescription();
		}

		local addSkill = o.addSkill;
		o.addSkill = function( _skill )
		{
			if (_skill.isType(this.Const.SkillType.Active) && ("FatigueOnSkillUse" in child.m))
			{
				_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
			}

			addSkill(_skill);
		}

		o.onAfterUpdateProperties <- function( _properties )
		{			
		}
	});
}
