::MSU.MH.hook("scripts/skills/perks/perk_quick_hands", function(q) {
	q.m.IsSpent <- false;

	q.create = @(__original) function()
	{
		__original();
		this.m.ItemActionOrder = ::Const.ItemActionOrder.Any;
	}

	q.onUpdate = @() function( _properties )
	{
	}

	q.onCombatStarted = @() function()
	{
	}

	q.onCombatFinished = @() function()
	{
		this.skill.onCombatFinished();
	}

	q.isHidden <- function()
	{
		return this.m.IsSpent;
	}

	q.getItemActionCost <- function( _items )
	{
		foreach (item in _items)
		{
			if (item != null && item.isItemType(::Const.Items.ItemType.Shield))
			{
				return null;
			}
		}
		return this.m.IsSpent ? null : 0;
	}

	q.onPayForItemAction <- function( _skill, _items )
	{
		if (_skill == this)
		{
			this.m.IsSpent = true;
		}
	}

	q.onTurnStart <- function()
	{
		this.m.IsSpent = false;
	}
});
