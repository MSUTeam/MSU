::mods_hookNewObject("items/item_container", function(o) {
	o.m.ActionSkill <- null;

	o.isActionAffordable = function ( _items )
	{
		local actionCost = this.getActionCost(_items);
		return this.m.Actor.getActionPoints() >= actionCost;
	}

	o.getActionCost = function( _items )
	{
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
		local actionCost = this.getActionCost(_items);
		this.m.Actor.setActionPoints(::Math.max(0, this.m.Actor.getActionPoints() - actionCost));
		this.m.Actor.getSkills().onPayForItemAction(this.m.ActionSkill, _items);
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
});
