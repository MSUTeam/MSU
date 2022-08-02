::mods_hookExactClass("ai/tactical/behaviors/ai_throw_bomb", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		local ret = onExecute(_entity);
		if (ret && this.m.Skill == null)
		{
			// This assumes that the newly equipped bomb will always be in the offhand
			// If we don't want that, then we could first iterate over all equipped items, then call onExecute,
			// then iterate over all items again, detect the new item, and pass it
			_entity.getItems().payForAction([_entity.getOffhandItem()]);
		}
		return ret;
	}
});
