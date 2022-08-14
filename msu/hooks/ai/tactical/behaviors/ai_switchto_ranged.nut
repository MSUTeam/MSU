::mods_hookExactClass("ai/tactical/behaviors/ai_switchto_ranged", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		_entity.getItems().m.IsMSUHandledItemAction = true;

		local itemsBefore = {};
		for (local i = 0; i < ::Const.ItemSlot.COUNT; i++)
		{
			itemsBefore[i] = _entity.getItems().getAllItemsAtSlot(i);
		}

		local ret = onExecute(_entity);
		if (ret)
		{

			local items = [];
			for (local i = 0; i < ::Const.ItemSlot.COUNT; i++)
			{
				local itemsNowInSlot = _entity.getItems().getAllItemsAtSlot(i);
				items.extend(itemsBefore[i].filter(@(idx, item) itemsNowInSlot.find(item) == null));
				items.extend(itemsNowInSlot.filter(@(idx, item) itemsBefore[i].find(item) == null));
			}
			_entity.getItems().payForAction(items);
		}

		_entity.getItems().m.IsMSUHandledItemAction = false;

		return ret;
	}
});
