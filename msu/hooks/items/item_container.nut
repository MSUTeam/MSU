::MSU.MH.hook("scripts/items/item_container", function(q) {
	q.m.ActionSkill <- null;

	// Part of adapting Quick Hands in vanilla < 1.5.2.2 to work with MSU onPayForItemAction
	if (::Hooks.getMod("vanilla").getVersion() < ::Hooks.SQClass.ModVersion("1.5.2-2"))
	{
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

		q.onNewRound = @(__original) function()
		{
			local ret = __original();
			this.m.ActionCost = ::Const.Tactical.Settings.SwitchItemAPCost;
			return ret;
		}
	}
	else
	{
		q.getActionCost = @() function( _items )
		{
			local isShield = false;
			local isTwoHanded = false;

			foreach (i in _items)
			{
				if (i != null)
				{
					if (i.isItemType(::Const.Items.ItemType.Shield))
					{
						isShield = true;
						break;
					}
					else if (i.getBlockedSlotType() != null)
					{
						isTwoHanded = true;
					}
				}
			}

			local cost = isShield ? this.m.ActionCostShield : (isTwoHanded ? this.m.ActionCost2H : this.m.ActionCost);

			this.m.ActionSkill = null;

			local info = this.getActor().getSkills().getItemActionCost(_items);
			info.sort(@(info1, info2) info1.Skill.getItemActionOrder() <=> info2.Skill.getItemActionOrder());

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
			local actionCost = this.getActionCost(_items);
			this.m.Actor.setActionPoints(::Math.max(0, this.m.Actor.getActionPoints() - actionCost));
			this.m.Actor.getSkills().onPayForItemAction(this.m.ActionSkill == null ? null : this.m.ActionSkill.get(), _items);
			this.m.ActionSkill = null;
		}
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

	q.equip = @(__original) function( _item )
	{
		local ret = __original(_item);
		if (ret == true && !::MSU.isNull(this.m.Actor) && this.m.Actor.isAlive()) this.m.Actor.getSkills().onEquip(_item);
		return ret;
	}

	q.unequip = @(__original) function( _item )
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

		return __original(_item);
	}
});
