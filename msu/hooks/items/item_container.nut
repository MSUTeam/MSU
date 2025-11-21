::MSU.MH.hook("scripts/items/item_container", function(q) {
	q.m.ActionSkill <- null;
	q.m.MSU_IsIgnoringItemAction <- false;

	q.isActionAffordable = @() function ( _items )
	{
		if (this.m.MSU_IsIgnoringItemAction) return true;

		local actionCost = this.getActionCost(_items);
		return this.m.Actor.getActionPoints() >= actionCost;
	}

	q.getActionCost = @() function( _items )
	{
		if (this.m.MSU_IsIgnoringItemAction) return 0;

		this.m.ActionSkill = null;

		local info = this.getActor().getSkills().getItemActionCost(_items);

		info.sort(@(info1, info2) info1.Skill.getItemActionOrder() <=> info2.Skill.getItemActionOrder());

		local cost = ::Const.Tactical.Settings.SwitchItemAPCost;

		foreach (entry in info)
		{
			if (entry.Cost < cost)
			{
				cost = entry.Cost;
				this.m.ActionSkill = ::MSU.asWeakTableRef(entry.Skill);
			}
		}

		return cost;
	}

	q.payForAction = @() function ( _items )
	{
		if (this.m.MSU_IsIgnoringItemAction || _items.len() == 0) return;

		local actionCost = this.getActionCost(_items);
		this.m.Actor.setActionPoints(::Math.max(0, this.m.Actor.getActionPoints() - actionCost));
		this.m.Actor.getSkills().onPayForItemAction(this.m.ActionSkill == null ? null : this.m.ActionSkill.get(), _items);
		this.m.ActionSkill = null;
	}

	q.getStaminaModifier <- function( _slots = null )
	{
		local ret = 0;

		if (_slots == null) _slots = ::Const.ItemSlotSpaces; // We use the ItemSlotSpaces array because its indices align perfectly with the actually usable ItemSlots
		else if (typeof _slots == "integer") _slots = [_slots];

		for (local i = 0; i < _slots.len(); i++)
		{
			foreach (item in this.getAllItemsAtSlot(_slots == ::Const.ItemSlotSpaces ? i : _slots[i]))
			{
				if (::MSU.isIn("getStaminaModifier", item, true)) ret += item.getStaminaModifier();
			}
		}

		return ret;
	}

	q.onNewRound = @(__original) function()
	{
		local ret = __original();
		this.m.ActionCost = ::Const.Tactical.Settings.SwitchItemAPCost;
		return ret;
	}

	q.equip = @(__original) function( _item )
	{
		local ret = __original(_item);
		if (ret == true && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive()) this.m.Actor.getSkills().onEquip(_item);
		return ret;
	}

	// Call our skill_container.onUnequip function
	q.unequip = @(__original) function( _item )
	{
		if (_item != null && _item != -1 && _item.getCurrentSlotType() != ::Const.ItemSlot.None && (_item.getCurrentSlotType() != ::Const.ItemSlot.Bag || _item.getSlotType() == ::Const.ItemSlot.Bag) && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive())
		{
			foreach (item in this.m.Items[_item.getSlotType()])
			{
				if (item == _item)
				{
					this.m.Actor.getSkills().onUnequip(_item);
					break;
				}
			}
		}

		// VanillaFix: https://steamcommunity.com/app/365360/discussions/1/684112192552961717/
		// `item_container.unequip` not properly removing bagged items while `item_container.equip` puts them in the bag.
		if (_item.getSlotType() == ::Const.ItemSlot.Bag)
		{
			return this.removeFromBag(_item);
		}

		return __original(_item);
	}

	// Call our skill_container.onUnequip function
	q.removeFromBag = @(__original) function( _item )
	{
		if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag && _item.getSlotType() == ::Const.ItemSlot.Bag)
		{
			foreach (item in this.m.Items[_item.getSlotType()])
			{
				if (item == _item)
				{
					this.m.Actor.getSkills().onUnequip(_item);
					break;
				}
			}
		}

		return __original(_item);
	}

	// Call our skill_container.onUnequip function
	q.removeFromBagSlot = @(__original) function( _slot )
	{
		local item = this.m.Items[::Const.ItemSlot.Bag][_slot];
		if (item != null && item.getSlotType() == ::Const.ItemSlot.Bag)
		{
			this.m.Actor.getSkills().onUnequip(item);
		}

		return __original(_slot);
	}
});
