::mods_hookNewObject("items/item_container", function(o) {
	o.m.ActionSkill <- null;
	o.m.MSU <- {
		IsIgnoringItemAction = false
	}

	o.isActionAffordable = function ( _items )
	{
		if (this.m.MSU.IsIgnoringItemAction) return true;

		local actionCost = this.getActionCost(_items);
		return this.m.Actor.getActionPoints() >= actionCost;
	}

	o.getActionCost = function( _items )
	{
		if (this.m.MSU.IsIgnoringItemAction) return 0;

		this.m.ActionSkill = null;

		local info = this.getActor().getSkills().getItemActionCost(_items);

		info.sort(@(info1, info2) info1.Skill.getItemActionOrder() <=> info2.Skill.getItemActionOrder());

		local cost = ::Const.Tactical.Settings.SwitchItemAPCost;

		foreach (entry in info)
		{
			if (entry.Cost < cost)
			{
				cost = entry.Cost;
				this.m.ActionSkill = entry.Skill;
			}
		}

		return cost;
	}

	o.payForAction = function ( _items )
	{
		if (this.m.MSU.IsIgnoringItemAction) return;

		local actionCost = this.getActionCost(_items);
		this.m.Actor.setActionPoints(::Math.max(0, this.m.Actor.getActionPoints() - actionCost));
		if (_items.len() != 0) this.m.Actor.getSkills().onPayForItemAction(this.m.ActionSkill, _items);
		this.m.ActionSkill = null;
	}

	o.getStaminaModifier <- function( _slots = null )
	{
		if (_slots == null)
		{
			 _slots = clone ::Const.ItemSlot;
			 delete _slots.None;
			 delete _slots.COUNT;
		}
		else
		{
			if (typeof _slots == "integer") _slots = [_slots];
		}

		local ret = 0;

		foreach (slot in _slots)
		{
			local items = this.getAllItemsAtSlot(slot);
			foreach (item in items)
			{
				// Avoid exceptions for items which don't have getStaminaModifier()
				// This handles cases such as Quivers in ammo slot which don't have
				// this function in vanilla but do in mods like Legends
				if (::MSU.isIn("getStaminaModifier", item, true)) ret += item.getStaminaModifier();
			}
		}

		return ret;
	}

	local onNewRound = o.onNewRound;
	o.onNewRound = function()
	{
		onNewRound();
		this.m.ActionCost = ::Const.Tactical.Settings.SwitchItemAPCost;
	}

	local equip = o.equip;
	o.equip = function( _item )
	{
		local ret = equip(_item);
		if (ret == true && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive()) this.m.Actor.getSkills().onEquip(_item);
		return ret;
	}

	local unequip = o.unequip;
	o.unequip = function( _item )
	{
		if (_item != null && _item != -1 && _item.getCurrentSlotType() != ::Const.ItemSlot.None && _item.getCurrentSlotType() != ::Const.ItemSlot.Bag && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive())
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

		return unequip(_item);
	}
});
