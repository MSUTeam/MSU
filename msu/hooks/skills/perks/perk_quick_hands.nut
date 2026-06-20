::MSU.MH.hook("scripts/skills/perks/perk_quick_hands", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ItemActionOrder = ::Const.ItemActionOrder.Any;
	}

	q.getItemActionCost = @() function( _items )
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
});

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.MH.hook("scripts/skills/perks/perk_quick_hands", function(q) {
		q.onPayForItemAction = @(__original) function( _skill, _items )
		{
			__original(_skill, _items);

			// Compatibility with vanilla 1.5.2.2. We wrap all onPayForItemAction
			// calls to also call the vanilla-added `onSpend` function.
			if (_skill == this)
			{
				this.onSpend(_items);
			}
		}
	});
});
